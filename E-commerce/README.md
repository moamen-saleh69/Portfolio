# 📊 E-commerce Regional Performance Analysis

### 🚀 Project Overview
This project analyzes sales, profit margins, and return rates across different US regions to identify operational bottlenecks. By combining **SQL** for data processing and **Tableau** for visualization, I discovered that specific regions are draining profitability due to high return rates and slow shipping times.

**[👉 View the Interactive Tableau Dashboard Here](https://public.tableau.com/app/profile/moamen.saleh/viz/E-commerce_17665161105250/Regiosconcerns)**

---

### 📸 Dashboard Preview
![Dashboard Screenshot](https://github.com/moamen-saleh69/Portfolio/tree/main/E-commerce/Dashboard)

---

### 🔍 Key Insights ("The Story")
1.  **The "Problem" Region:** The **East Region** has the highest Return Rate (~5.9%), which is significantly impacting net profit despite high sales volume.
2.  **The "Star" Region:** The **North Region** is the most efficient, with the fastest average delivery time (3 days) and lower return rates.
3.  **Delivery Correlation:** Regions with delivery times exceeding 4 days showed a correlation with higher return rates, suggesting customers cancel or return items when shipping is too slow.

---

### 🛠️ Tools Used
* **SQL:** Used for complex data cleaning, `CTE`s to calculate Ranking, and Window Functions for rolling profit totals.
* **Tableau:** Built interactive dashboards to visualize geographic disparities.
* **Excel:** Preliminary data validation and csv formatting.

---

### 📂 Project Structure
* `/SQL_Scripts`: Contains the queries used for data cleaning and analysis.
* `/Dashboard`: Screenshots of the final visualizations.
* `Final_Data.xlsx`: The processed dataset used for the Tableau dashboard.

---

### 💡 Recommendations
Based on the data, the company should:
1.  Investigate the logistics partners in the **East Region** to reduce shipping times.
2.  Implement a stricter return policy or quality check for the East region distribution centers.
3.  Replicate the **North Region's** shipping model across other territories.
