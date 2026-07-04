/*
================================================================
RFM Customer Segmentation — SQL Analysis
================================================================
Database: rfm_analysis
Table: rfm_customer (4,338 rows)

Objective:
This script analyzes the RFM-segmented customer data (calculated 
and exported from Python) to answer key business questions around 
customer value, revenue concentration, and retention priority. 
Each query is paired with its business question and a written 
observation explaining the finding and its implication.
================================================================
*/

-- Setup
CREATE DATABASE rfm_analysis;
USE rfm_analysis;

-- Table structure and row count check
DESCRIBE rfm_customer;
SELECT COUNT(*) FROM rfm_customer;

-- Question
-- ========================================================
-- Q1: How many customers fall into each segment, and what is
--     their average Monetary value?
-- ========================================================
SELECT Segment,
     COUNT(CustomerID) AS Customer_count,
	 ROUND(AVG(Monetary),2) AS avg_monetary
FROM rfm_customer 
GROUP BY segment
ORDER BY avg_monetary DESC;

/*
Observation:
Champion has the highest average monetary value (₹9186.83), followed by 
Big Spender (₹5693.39). Champion outranking Big Spender may seem 
counter-intuitive since Big Spender is defined purely by top Monetary 
score (M=5), but this happens because customers who qualify as Champion 
(R=5 and F=5) are evaluated first in the segmentation logic and never 
reach the Big Spender check -- meaning Big Spender only captures 
high-spending customers who are NOT already recent and frequent buyers. 
At Risk and Potential Loyal show low average spend (₹869.89 and ₹718.37), 
and Lost is lowest overall (₹345.67), confirming spend naturally declines 
with disengagement.
*/

-- ========================================================
-- Q2: Who are the top 10 highest-value customers overall 
--     (by Monetary), and which segment do they belong to?
-- ========================================================

SELECT CustomerID, 
       Segment,
       Monetary
FROM rfm_customer 
ORDER BY Monetary DESC 
LIMIT 10;

/*
Observation:
CustomerID 14646 is the highest-value customer overall (₹280,206.02), confirming 
the same finding from Phase 1 EDA. The top 5 customers are dominated by Champion 
segment (3 of 5), as expected -- these are recent, frequent, high-spending buyers.

One outlier stands out: CustomerID 16446 ranks 4th by Monetary value (₹168,472.5) 
but falls into "Potential Loyal" rather than "Champion" or "Big Spender." This 
suggests the customer made very few purchases (low Frequency) but each purchase 
was extremely high value -- likely a bulk buyer or wholesale-type customer rather 
than a frequent repeat shopper. This customer represents a high-value but 
low-engagement risk: a single large order accounts for most of their lifetime 
value, and there's no purchase frequency pattern to indicate loyalty. Worth 
flagging for personalized account management rather than standard "Potential 
Loyal" nurture campaigns.
*/

-- ============================================================
-- Q3: Who are the top 10 At Risk customers by Monetary value? 
-- ============================================================
SELECT CustomerID, 
	   Monetary
FROM rfm_customer
WHERE segment = 'At Risk'
ORDER BY Monetary DESC 
LIMIT 10;

/*
Observation:
The top At Risk customer (CustomerID 15749) has a Monetary value of ₹44,534.30 -- 
over 50x higher than the segment's average of ₹869.89 calculated in Q1. This 
confirms the At Risk segment contains a small number of high-value customers 
whose spend is masked by the segment average. A blanket win-back campaign 
treating all 1,137 At Risk customers equally would waste budget; instead, this 
top-10 list should be prioritized for personalized, high-touch win-back outreach 
(e.g., account manager calls, custom offers), while the remaining lower-value At 
Risk customers can be targeted with lower-cost automated campaigns (email 
discounts). This tiered approach maximizes ROI on retention spend.
*/

-- ================================================
-- Q4: What is the average Recency, Frequency, and 
--     Monetary for each segment?
-- ================================================
SELECT segment,
	   ROUND(AVG(Recency),2) AS avg_recency,
	   ROUND(AVG(Frequency),2) AS avg_frequency,
       ROUND(AVG(Monetary),2) AS avg_monetary
FROM rfm_customer
GROUP BY segment;

/*
Observation:
Big Spender shows a high average recency (112.20 days) alongside strong 
monetary value (₹5693.39) -- meaning these customers spend heavily but haven't 
purchased in nearly 4 months on average. This is a time-sensitive segment: 
the longer they stay inactive, the higher the risk of permanent churn despite 
their high value, making them a priority for proactive re-engagement rather 
than passive retention.

Lost shows an average frequency of exactly 1.00 -- meaning nearly every 
customer in this segment made only a single purchase and never returned. This 
indicates the business's core challenge with this segment isn't win-back, it's 
a failed first-purchase-to-second-purchase conversion. This reframes "Lost" as 
an acquisition/onboarding problem rather than a loyalty problem, suggesting 
budget is better spent on improving the post-first-purchase experience (e.g., 
follow-up offers, second-purchase discounts) than on reactivation campaigns 
for this specific group.

Champion's low recency (4.70 days) confirms they are actively engaged right 
now, requiring no urgent intervention beyond standard loyalty maintenance.
*/

-- ==================================================================
-- Q5: What percentage of total revenue does each segment contribute?
-- ==================================================================
SELECT Segment, 
	   ROUND(SUM(Monetary),2) AS total_rev,
       ROUND((SUM(Monetary)*100/(SELECT SUM(Monetary) FROM rfm_customer)),2) AS revenue_pct
       FROM rfm_customer
       GROUP BY Segment;
       
/*
Observation:
Champion represents just 10.1% of customers (439 of 4,338, from Q1) but 
contributes 45.38% of total revenue -- nearly half the business runs on 
under 1 in 10 customers. This is a classic Pareto (80/20) pattern and confirms 
that retention investment in this segment isn't optional; losing even a small 
fraction of Champions would have an outsized revenue impact compared to losing 
an equivalent number of customers from any other segment.

At the other end, Lost makes up 12.8% of customers but only 2.16% of revenue -- 
proportionally low-impact, reinforcing the Q4 finding that this segment is best 
handled with low-cost automated reactivation rather than active investment.

Loyal (27.5% of customers, 31.19% of revenue) and At Risk (26.2% of customers, 
11.13% of revenue) are worth comparing directly: Loyal generates revenue 
roughly proportional to its size, while At Risk under-contributes relative to 
its customer count -- consistent with Q3's finding that this segment holds 
untapped high-value customers who have gone quiet. This strengthens the case 
for prioritizing At Risk win-back campaigns as the highest-ROI opportunity 
outside the Champion segment.
*/

-- ====================================================================
-- Q6: How many customers have a Frequency of only 1 (one-time buyers),
--     and what segment are most of them in?
-- ====================================================================
SELECT COUNT(CustomerID) AS Count_Cust,
	   Segment
       FROM rfm_customer
       WHERE frequency = 1
       GROUP BY segment
       ORDER BY Count_cust DESC;

/*
Observation:
One-time buyers (Frequency = 1) are not confined to a single segment -- they 
appear across four: Lost (556), Potential Loyal (533), At Risk (393), and even 
Big Spender (11). This confirms that Frequency alone doesn't determine segment 
outcome; Recency and Monetary are doing the real separating work here.

A one-time buyer who purchased recently lands in Potential Loyal (still has a 
chance to become repeat). A one-time buyer who purchased long ago lands in 
Lost (likely permanently churned). A one-time buyer with high spend regardless 
of timing can land in At Risk or even Big Spender (the single purchase was 
large enough to outweigh low frequency). 

This means "one-time buyer" is not itself an actionable business category -- 
it needs to be read alongside recency and spend before deciding an action. The 
533 Potential Loyal one-time buyers are the highest-priority group here: they 
are the most convertible, since they've purchased recently and simply haven't 
returned yet.
*/

-- ========================================================================
-- Q7: What is the average order value (Monetary ÷ Frequency) per segment? 
-- ========================================================================
SELECT Segment, 
	   ROUND(((SUM(Monetary))/SUM(Frequency)),2) AS avg_order
	FROM RFm_customer 
    GROUP By segment;

/*
Observation:
Big Spender has an average order value of ₹2930.42 -- more than 5x higher than 
the next highest segment, Champion (₹572.63). Combined with Q4's findings 
(Big Spender has low frequency at 1.94 orders and high recency at 112.20 days), 
this confirms Big Spender customers make rare, very large purchases rather than 
frequent smaller ones -- a fundamentally different buying pattern than Champion, 
who spends steadily and often.

This has a direct marketing implication: Big Spender should not receive the 
same engagement strategy as Champion (e.g., frequent promotional emails, small 
discount nudges). Instead, this segment calls for high-touch, low-frequency 
outreach -- such as personalized account management or exclusive high-value 
offers -- timed around their historical purchase cycle rather than a standard 
recurring campaign, since flooding a low-frequency high-value buyer with 
frequent contact risks feeling intrusive rather than engaging.

At Risk shows the lowest AOV (₹355.27) alongside Lost (₹345.67), reinforcing 
that these segments were never high-value order generators even before they 
disengaged -- win-back efforts here should focus on frequency and re-engagement 
rather than expecting large order values.
*/

-- =========================================================================
--  Q8: Which segment has the highest average Recency (i.e., most inactive),
--  and how many customers does it affect?
-- =========================================================================
SELECT Segment, 
	   ROUND(AVG(Recency),2) AS avg_recency,
       COUNT(CustomerID) AS cust_count
	FROM rfm_customer
    GROUP BY segment 
    ORDER BY avg_recency DESC
    LIMIT 1;
    
/*
Observation:
Lost is confirmed as the segment with the highest average inactivity 
(221.01 days), affecting 556 customers -- roughly 4x longer than the overall 
"active" threshold seen in Champion (4.70 days from Q8's initial unsorted 
result). While this restates findings already visible in Q4's full breakdown, 
isolating it as a single top-line statistic gives the business a clear headline 
KPI: "556 customers, representing 12.8% of the customer base, have been 
inactive for over 7 months on average." This framing is more useful for a 
dashboard summary card or executive briefing than the full segment table, 
since it immediately answers the question "how big is our churn problem" 
without requiring the reader to interpret a multi-row comparison.
*/
