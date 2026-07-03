RFM Customer Segmentation & Retention Strategy
End-to-end customer segmentation analysis of 541,909 transactions from a UK-based online retailer, using the RFM (Recency, Frequency, Monetary) framework to identify high-value customers, quantify churn risk, and prioritize retention spend.
Tools: Python (Pandas, EDA) → MySQL (business analysis) → Power BI (interactive dashboard)
Dataset: UCI Online Retail Dataset — 541,909 transactions, Dec 2010–Dec 2011
---
Business Objective
A retailer with over half a million transactions has no systematic way to tell which customers are worth protecting, which are convertible, and which are already lost. This project segments 4,338 unique customers into six actionable groups and answers three core business questions:
Where is revenue actually concentrated, and how much risk does that create?
Which "At Risk" customers are worth a personal win-back call vs. an automated email?
Is customer loss a loyalty problem or an onboarding problem?
---
Project Roadmap
Phase	Task	Tool	Status
1	Data cleaning — remove cancellations, nulls, negative quantities	Python (Pandas)	✅ Done
2	EDA — Recency/Frequency/Monetary distributions	Python	✅ Done
3	RFM scoring & segmentation logic (6 segments)	Python	✅ Done
4	Business analysis — 8 SQL queries + findings	MySQL	✅ Done
5	Interactive dashboard — 2 pages, 9 DAX measures	Power BI	✅ Done
6	Documentation & business narrative	README	✅ Done
---
Phase 1–2: Data Cleaning & EDA (Python)
Raw dataset (541,909 rows) cleaned for cancelled orders (`InvoiceNo` starting with "C"), missing `CustomerID`, and negative/zero quantities. Result: clean transaction table ready for RFM calculation.
[Screenshot: Recency / Frequency / Monetary distribution plots]
[Screenshot: Segment counts across all 6 segments]
---
Phase 3: RFM Scoring & Segmentation (Python)
Calculated Recency, Frequency, and Monetary value per customer, scored each 1-5, and combined into a rule-based segmentation logic. Result: zero unclassified customers across all 4,338 unique customers, split into six segments — Champion, Loyal, Potential Loyal, At Risk, Big Spender, Lost.
---
Phase 4: Business Analysis (SQL)
Eight business questions answered in MySQL, each paired with a written interpretation connecting the number to a specific action. Full queries in `sql/SQL_analysis.sql`.
[Screenshot: one representative SQL query + result table]
Key Findings
Revenue is dangerously concentrated in a small group.
Champions make up just 10.1% of customers (439 of 4,338) but generate 45.4% of total revenue. Losing even a small fraction of this segment would have an outsized impact compared to losing an equivalent number of customers anywhere else.
The "At Risk" segment average hides its most valuable customers.
At Risk customers average ₹870 in spend, but the top 10 by value exceed ₹6,900 each — one customer alone accounts for ₹44,534, over 50x the segment average. A blanket win-back campaign wastes budget; the top 10 warrant personalized outreach, the rest automated campaigns.
"Lost" customers were never won in the first place.
The Lost segment has an average Frequency of exactly 1.00 — nearly every customer made one purchase and never returned. This reframes the problem as a failed first-to-second-purchase conversion, not a loyalty failure.
One-time purchases alone don't predict outcome.
Frequency-1 customers appear across four different segments — Recency and Monetary, not Frequency alone, determine where a customer lands. The 533 "Potential Loyal" one-time buyers are the highest-priority conversion target.
Big Spenders behave nothing like Champions.
Big Spenders have an average order value 5x higher than Champions (₹2,930 vs ₹573) but purchase far less often. They need high-touch, low-frequency outreach — not the frequent promotional cadence that works for Champions.
---
Phase 5: Interactive Dashboard (Power BI)
Two-page report built on 9 DAX measures.
Page 1 — Executive Overview
![Executive Overview](assets/page1_executive_overview.png)
Page 2 — Segment Deep Dive
![Segment Deep Dive](assets/page2_segment_deep_dive.png)
Interactive `.pbix` file included in `dashboard/` — open in Power BI Desktop (free) to explore the segment slicer and drill-through table directly.
---
Repository Structure
```
├── notebooks/          # Python EDA + RFM scoring
├── sql/                 # SQL_analysis.sql — 8 business queries + observations
├── dashboard/            # RFM_analysis.pbix + PDF export
├── assets/               # Dashboard screenshots
└── README.md
```
