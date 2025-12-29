
--Need to make genre less verstile!
DROP TABLE IF EXISTS  Genre_Cleaned
CREATE TABLE Genre_Cleaned (
    appid float,
    name nvarchar(255),
    release_date date,
    english float,
    developer nvarchar(255),
    publisher nvarchar(255),
    platforms nvarchar(255),
    required_age float,
    categories nvarchar(max),
    genres nvarchar(255), 
    steamspy_tags nvarchar(max),
    achievements float,
    positive_ratings float,
    negative_ratings float,
    average_playtime float,
    median_playtime float,
    owners nvarchar(255),
    price float
);
INSERT INTO Genre_Cleaned
SELECT 
    appid,
    name,
    release_date,
    english,
    developer,
    publisher,
    platforms,
    required_age,
    categories,
    CASE 
        WHEN genres LIKE '%Utilities%' 
             OR genres LIKE '%Design%' 
             OR genres LIKE '%Photo Editing%' 
             OR genres LIKE '%Web Publishing%' 
             OR genres LIKE '%Software Training%' 
             OR genres LIKE '%Audio Production%' 
             OR genres LIKE '%Video Production%' 
             THEN 'Software'  
        WHEN genres LIKE '%RPG%' THEN 'RPG'
        WHEN genres LIKE '%Strategy%' THEN 'Strategy'
        WHEN genres LIKE '%Simulation%' THEN 'Simulation'
        WHEN genres LIKE '%Racing%' THEN 'Racing'
        WHEN genres LIKE '%Sports%' THEN 'Sports'
        WHEN genres LIKE '%Fighting%' THEN 'Fighting'   
        WHEN genres LIKE '%Massively Multiplayer%' THEN 'MMO'
        WHEN genres LIKE '%Platformer%' THEN 'Platformer' 
        WHEN genres LIKE '%Puzzle%' THEN 'Puzzle'      
        WHEN genres LIKE '%Horror%' THEN 'Horror'
        WHEN genres LIKE '%FPS%' OR genres LIKE '%Shooter%' THEN 'Shooter'
        WHEN genres LIKE '%Adventure%' THEN 'Adventure'
        WHEN genres LIKE '%Action%' THEN 'Action'       
        WHEN genres LIKE '%Casual%' THEN 'Casual'
        WHEN genres LIKE '%Indie%' THEN 'Indie'
        WHEN genres LIKE '%Free to Play%' THEN 'Free to Play' 
        ELSE 'Other'
    END,
    steamspy_tags,
    achievements,
    positive_ratings,
    negative_ratings,
    average_playtime,
    median_playtime,
    owners,
    price
FROM PortfolioProject.dbo.steam;

--Highest rated genre 
SELECT genres, SUM(CAST(positive_ratings AS FLOAT)) AS SUM_Rating
FROM  Genre_Cleaned
GROUP BY genres
ORDER BY SUM_Rating DESC

--Most played genres
SELECT genres, AVG(median_playtime) AS AVG_Playtime_PER_Genre
FROM  Genre_Cleaned
GROUP BY genres
ORDER BY AVG_Playtime_PER_Genre DESC
 
--Most common three categories per genre 
WITH Unpacked_Steam_Data AS (
    SELECT 
        genres, 
        TRIM(value) as Clean_Category 
    FROM  Genre_Cleaned
    CROSS APPLY STRING_SPLIT(categories, ';') 
    WHERE genres != 'Other' AND genres != 'Software'
),
Ranked_Categories AS (
    SELECT 
        genres,
        Clean_Category,
        COUNT(*) as Frequency,
        RANK() OVER (PARTITION BY genres ORDER BY COUNT(*) DESC) as Rank_Num
    FROM Unpacked_Steam_Data
    GROUP BY genres, Clean_Category
)
SELECT * FROM Ranked_Categories
WHERE Rank_Num <= 3
ORDER BY genres, Rank_Num;



--Highest achiving DEVS
WITH DEV_RANK
AS(
SELECT developer, SUM(CAST(positive_ratings AS INT)) AS Total_Positive, SUM(CAST(negative_ratings AS INT)) AS Total_Negative, (SUM(CAST(positive_ratings AS INT)) - SUM(CAST(negative_ratings AS INT))) AS Total_Vote
FROM PortfolioProject.dbo.steam
GROUP BY developer
)
SELECT *, 
RANK () OVER (ORDER BY Total_Vote DESC) AS DEV_RANK
FROM DEV_RANK

--Does price increase the demand?
SELECT name, genres,median_playtime, price,
CASE WHEN median_playtime > 0 THEN median_playtime / CAST (price AS FLOAT)
END  AS Playability_for_Price
FROM  Genre_Cleaned
WHERE median_playtime > 0 AND price > 0
ORDER BY Playability_for_Price DESC

