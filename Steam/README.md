# 🎮 Steam Store Analytics: From Raw Data to Dashboard

## 📌 Project Overview
A full-stack data analysis project exploring the Steam Game Store economy. This project analyzes player behavior, pricing strategies, and genre popularity to answer the question: **"Which games offer the best value for money?"**

The project moves from raw data processing in **SQL Server** (cleaning, normalization, ranking) to a fully interactive, custom-designed dashboard in **Power BI**.

![Steam Dashboard](https://github.com/user-attachments/assets/99dd0634-d108-4e4a-96d8-853c93129a37)
---

## 🛠️ Tech Stack
* **Database:** Microsoft SQL Server (SSMS)
* **Visualization:** Microsoft Power BI
* **Data Cleaning:** Advanced SQL (`CROSS APPLY`, `CASE`, `Window Functions`) 
* **Design:** Custom UI (Glassmorphism, Dark Mode)

---

## 🧠 The Logic (SQL)
The raw data contained nested JSON-like strings (e.g., `'Action;Indie;Adventure'`). To analyze this, I had to normalize the database using `CROSS APPLY` and `STRING_SPLIT` to explode these rows into distinct countable tags.

**Key SQL Techniques Used:**
* **`CROSS APPLY STRING_SPLIT`**: To turn one row (`"Action;RPG"`) into multiple rows for accurate counting.
* **`CASE WHEN` Logic**: To categorize messy genre tags into clean buckets (e.g., grouping "Roguelike" and "JRPG" under "RPG").
* **Window Functions (`RANK()` over Partition)**: To identify the top sub-categories within each main genre.

```sql
-- Example of the Logic used to rank Categories within Genres
SELECT 
    genres,
    Clean_Category,
    COUNT(*) as Frequency,
    RANK() OVER (PARTITION BY genres ORDER BY COUNT(*) DESC) as Rank_Num
FROM Unpacked_Steam_Data
GROUP BY genres, Clean_Category
---

## 📊 The Dashboard (Power BI)
The visual layer was designed to mimic the **Steam Store UI** (Dark Mode) rather than a corporate report.

### 1. The "Galaxy" Chart (Value Analysis)
* **Visual:** Scatter Plot (Playtime vs. Price).
* **Insight:** The chart reveals a "Power Law" distribution.
    * **The Tower (Left):** Low-cost Indie games often provide hundreds of hours of playtime (High ROI).
    * **The Tail (Right):** AAA titles ($60+) show diminishing returns on playtime per dollar.

### 2. Interactive Filtering
* **Genre Slicer:** Filters the entire dashboard by game type.
* **Price & Year Sliders:** Allows users to simulate specific buying scenarios (e.g., "Games under $10 released after 2015").

### 3. Deep Dive Matrices
* **Developer Leaderboard:** Ranks studios by total positive ratings.
* **Category Drill-Down:** Reveals what players actually want in a genre (e.g., "Single-player" is the #1 requested feature even in Action games).

---

## 🚀 Key Insights
1.  **Indie Supremacy:** Mathematically, Indie games offer a better "Hours per Dollar" ratio than AAA games.
2.  **Single-Player Demand:** Despite the multiplayer trend, "Single-Player" remains the most tagged category across major genres.
3.  **Pricing Sweet Spot:** The highest concentration of positive reviews exists in the **$10 - $20** price range.

---

## 📂 Repository Structure
* `📁 /SQL_Scripts` - The raw cleaning and ranking queries.
* `📁 /Dashboard` - The `.pbix` file with the visual model.
* `📁 /Screenshots` - High-res images of the dashboard.

---

*Created by [Your Name]*
