# 🍜 SQL Case Study: Danny's Diner

### 📄 Project Overview
This repository contains my solutions for the "Danny's Diner" SQL Challenge. The goal was to use advanced SQL techniques to answer business questions regarding customer purchasing habits, menu popularity, and membership retention.

### 🛠️ Key Techniques Demonstrated
* **Window Functions:** `RANK()`, `DENSE_RANK()`, `ETC..` for ranking sales and finding "first" purchases.
* **Common Table Expressions (CTEs):** Used chained CTEs to break down complex logic into readable steps.
* **Joins:** `INNER JOIN` and `FULL JOIN` to combine Sales, Menu, and Members tables.
* **Date Manipulation:** Filtering transactions based on membership `join_date`.
* **Conditional Logic:** `CASE` statements to calculate custom point systems and conditional rankings.

### 🧠 Logic Highlights
* **Problem:** Rank customer orders, but only *after* they became a member.
* **Solution:** Implemented a `CASE` statement wrapping a Window Function to conditionally assign ranks or `NULL` values based on membership status.

```sql
-- Snippet: Ranking Member Orders Only
CASE 
    WHEN Member_status = 'N' THEN NULL
    ELSE RANK() OVER (PARTITION BY customer_id, Member_status ORDER BY order_date) 
END AS Member_Rank
```
Solutions by [Moamen Saleh]
