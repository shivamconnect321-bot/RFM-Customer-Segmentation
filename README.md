RFM Customer Segmentation & Retention Strategy
End-to-end customer segmentation analysis of 541,909 transactions from a UK-based online retailer, using the RFM (Recency, Frequency, Monetary) framework to identify high-value customers, quantify churn risk, and prioritize retention spend.
Tools used: Python (Pandas, EDA) → MySQL (business analysis) → Power BI (interactive dashboard)
---
Business Objective
A retailer with over half a million transactions has no systematic way to tell which customers are worth protecting, which are convertible, and which are already lost. This project segments 4,338 unique customers into six actionable groups and answers three core business questions:
Where is revenue actually concentrated, and how much risk does that create?
Which "At Risk" customers are worth a personal win-back call vs. an automated email?
Is customer loss a loyalty problem or an onboarding problem?
---
Dashboard
Page 1 — Executive Overview
![Executive Overview](assets/page1_executive_overview.png)
Page 2 — Segment Deep Dive
![Segment Deep Dive](assets/page2_segment_deep_dive.png)
Interactive `.pbix` file included in this repo — open in Power BI Desktop (free) to explore the segment slicer and drill-through table directly.
---
Methodology
1. Data Cleaning (Python)
Raw UCI Online Retail dataset (541,909 rows) cleaned for cancelled orders, missing CustomerIDs, and negative quantities.
2. RFM Scoring (Python)
Calculated Recency, Frequency, and Monetary value per customer, scored each on a 1-5 scale, and combined into a rule-based segmentation logic — zero unclassified customers across all 4,338 unique customers, split into six segments: Champion, Loyal, Potential Loyal, At Risk, Big Spender, Lost.
3. Business Analysis (SQL)
Eight business questions answered in MySQL, each paired with a written interpretation connecting the number to a specific business action (full queries in `SQL\_analysis.sql`).
4. Dashboard (Power BI)
Two-page interactive report — an executive summary and a segment-level deep dive — built on 9 DAX measures.
---
Key Findings
Revenue is dangerously concentrated in a small group.
Champions make up just 10.1% of customers (439 of 4,338) but generate 45.4% of total revenue. Losing even a small fraction of this segment would have an outsized impact compared to losing an equivalent number of customers anywhere else — this is not an optional retention investment.
The "At Risk" segment average hides its most valuable customers.
At Risk customers average ₹870 in spend, but the top 10 by value exceed ₹6,900 each — one customer alone accounts for ₹44,534, over 50x the segment average. A blanket win-back campaign treating all 1,137 At Risk customers identically wastes budget. The top 10 warrant personalized outreach; the rest are better served by low-cost automated campaigns.
"Lost" customers were never won in the first place.
The Lost segment has an average Frequency of exactly 1.00 — nearly every customer here made one purchase and never returned. This reframes the problem: it isn't a loyalty failure, it's a failed first-to-second-purchase conversion. Budget is better spent improving the post-first-purchase experience than on reactivation campaigns for this group.
One-time purchases alone don't predict outcome.
Frequency-1 customers appear across four different segments (Lost, Potential Loyal, At Risk, even Big Spender) — Recency and Monetary, not Frequency alone, determine where a customer lands. The 533 "Potential Loyal" one-time buyers are the highest-priority conversion target: recent enough to still be won.
Big Spenders behave nothing like Champions.
Big Spenders have an average order value 5x higher than Champions (₹2,930 vs ₹573) but purchase far less often and haven't bought in ~112 days on average. They need high-touch, low-frequency outreach timed to their purchase cycle — not the frequent promotional cadence that works for Champions.
---
Repository Structure
```
├── notebooks/          # Python EDA + RFM scoring
├── sql/                # SQL\_analysis.sql — 8 business queries + observations
├── dashboard/           # RFM\_analysis.pbix + PDF export
├── assets/              # Dashboard screenshots
└── README.md
```
Dataset
UCI Online Retail Dataset — 541,909 transactions, UK-based online retailer, Dec 2010–Dec 2011.
