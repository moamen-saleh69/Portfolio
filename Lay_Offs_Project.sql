--Task: Find rows where the same company, location, and date appear more than once. Delete the extras.

With Duplicate_Police as (
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
    ORDER BY company
) as DUP_NUM
From PortfolioProject.dbo.layoffs A
)
Delete 
From Duplicate_Police
Where DUP_NUM > 1

--Task: Fix spelling errors. (e.g., Change "Crypto Currency" and "Crypto-currency" both to just "Crypto").
Select DISTINCT industry
From PortfolioProject.dbo.layoffs A
Order by 1

Update PortfolioProject.dbo.layoffs 
Set industry = 'Crypto'
Where industry like '%crypto%'

-- Task: Trim whitespace from company names.

Select DISTINCT company
From PortfolioProject.dbo.layoffs A
Order by 1

Update PortfolioProject.dbo.layoffs 
Set company = TRIM(company)


--Task: Convert the date column from "Text" format to a real "Date" format.


Select DISTINCT date 
From PortfolioProject.dbo.layoffs A

SELECT [date]
FROM PortfolioProject.dbo.layoffs
WHERE TRY_CONVERT(DATE, [date]) IS NULL
AND [date] IS NOT NULL;

UPDATE PortfolioProject.dbo.layoffs
SET [date] = NULL
WHERE [date] = 'NULL';

Alter table PortfolioProject.dbo.layoffs
Alter Column [date] date 

--Task: Find industries that are NULL or blank. Can you populate them by looking at other rows for the same company?

Select company,industry
From PortfolioProject.dbo.layoffs A
Where industry = ''
or industry = null

Select a.company,a.industry, b.company,b.industry
From PortfolioProject.dbo.layoffs A
join PortfolioProject.dbo.layoffs B
on a.company = b.company
and a.industry <> b.industry
Where a.industry = ''
or a.industry = null

Update a
Set a.industry =
b.industry
From PortfolioProject.dbo.layoffs A
join PortfolioProject.dbo.layoffs B
on a.company = b.company
and a.industry <> b.industry
Where a.industry = ''
or a.industry = null

--Task: Delete rows where both total_laid_off and percentage_laid_off are NULL (useless data).

Select total_laid_off, percentage_laid_off
 From PortfolioProject.dbo.layoffs A
 WHERE 
(total_laid_off IS NULL OR total_laid_off = 'NULL' OR total_laid_off = '')
AND 
(percentage_laid_off IS NULL OR percentage_laid_off = 'NULL' OR percentage_laid_off = '');

DELETE FROM PortfolioProject.dbo.layoffs
WHERE 
(total_laid_off IS NULL OR total_laid_off = 'NULL' OR total_laid_off = '')
AND 
(percentage_laid_off IS NULL OR percentage_laid_off = 'NULL' OR percentage_laid_off = '');

-- Question: What was the maximum number of people laid off in a single day? 

SELECT date, MAX(CAST(total_laid_off AS INT)) as Max_Lay_OffS
FROM PortfolioProject.dbo.layoffs
where total_laid_off <> 'NULL'
Group by date
Order by 2 desc

-- Question: Which companies laid off 100% of their workforce (went out of business)?

SELECT company, industry, location,percentage_laid_off
FROM PortfolioProject.dbo.layoffs
where percentage_laid_off = '1'

-- Question: Which year had the most layoffs? 

SELECT Year(date), SUM(CAST(total_laid_off AS INT)) as Max_Lay_OffS
FROM PortfolioProject.dbo.layoffs
WHERE TRY_CAST(total_laid_off AS INT) IS NOT NULL 
GROUP BY Year(date)
ORDER BY 2 DESC;


--Question: What is the "Rolling Total" of layoffs month-by-month?



WITH Monthly_Data AS 
(
    SELECT 
        YEAR(date) as Year,
        MONTH(date) as Month,
        SUM(CAST(total_laid_off AS INT)) as Total_Off
    FROM PortfolioProject.dbo.layoffs
    WHERE TRY_CAST(total_laid_off AS INT) IS NOT NULL
      AND date IS NOT NULL 
    GROUP BY YEAR(date), MONTH(date)
)
SELECT 
    Year, 
    Month, 
    Total_Off,
    SUM(Total_Off) OVER (ORDER BY Year, Month) as Rolling_Total
FROM Monthly_Data
ORDER BY Year, Month;


--Question: Which industry got hit the hardest?
 SELECT industry,AVG(CAST(percentage_laid_off as float)) as AVG_Lay_Off_Percentage , AVG(CAST(funds_raised_millions as float))  as AVG_funds_raised_millions 
    FROM PortfolioProject.dbo.layoffs
    WHERE TRY_CAST (percentage_laid_off as float) IS NOT NULL
    AND TRY_CAST(funds_raised_millions as float) IS NOT NULL
    Group by industry
    Order by 2 DESC


--Question: Which stage of company (Series A, IPO, Acquired) had the most layoffs?

SELECT SUM(CAST(total_laid_off as INT)) as SUM_Lay_Offs,stage
FROM PortfolioProject.dbo.layoffs
Where TRY_CAST (total_laid_off as INT) IS NOT NULL
GROUP BY stage
ORDER BY 1 DESC


