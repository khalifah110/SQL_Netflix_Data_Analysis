# 🎬 SQL Netflix Data Analysis

## 📌 Project Overview
This project explores Netflix’s content catalog using SQL to uncover patterns in content distribution, genres, ratings, release trends, and country-level contributions. By analyzing movies and TV shows stored in a PostgreSQL database, the project answers practical business and analytical questions that help understand Netflix’s global content strategy.

The goal is to demonstrate **real-world SQL analytics skills**—from aggregations and joins to window functions and data transformation—while extracting meaningful insights from raw entertainment data.

---

## 🎯 Project Objectives
- Analyze the **distribution of Netflix content** by country, type, and year  
- Identify **dominant genres, ratings, and directors**
- Compare **Movies vs TV Shows**
- Apply **advanced SQL techniques** to answer business-style questions
- Present insights in a **clear, portfolio-ready format**

---

## 🛠️ Tools & Technologies
- **SQL** – Core language used for querying and analysis  
- **PostgreSQL** – Database management system  
- **Visual Studio Code** – SQL execution and database connection  
- **Git & GitHub** – Version control and project documentation  

---

## 🗂️ Dataset Description
**Database:** PostgreSQL  
**Table:** `netfilex`

**Key Columns:**
- `show_id`
- `type`
- `title`
- `directer`
- `country`
- `date_added`
- `release_year`
- `rating`
- `duration`
- `listend_in`
- `description`

---

## 🔍 Analysis & Key Queries

### 1️⃣ Top 5 Countries With the Most Netflix Content

This question analyzes the geographical distribution of Netflix content by identifying which countries contribute the highest number of titles to the platform. Understanding this helps reveal Netflix’s strongest content-producing markets and highlights regions where Netflix invests heavily in production or licensing.

```sql
SELECT
    country,
    COUNT(*) AS total_titles
FROM netfilex
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
```


<img width="1000" height="600" alt="Code_Generated_Image" src="https://github.com/user-attachments/assets/e585e5d0-44c9-42c9-8767-d5ba5556f875" />


**-** The United States dominates Netflix’s catalog, contributing more than 2,800 titles, which is significantly higher than any other country.

**-** India ranks second, reflecting Netflix’s growing focus on regional and international markets, especially in Asia.

**-** The presence of countries like the United Kingdom, Japan, and South Korea shows Netflix’s strategic investment in diverse, global content to appeal to international audiences.

Overall, the results highlight Netflix’s balance between Hollywood-driven content and international expansion.


 ### 2️⃣ Most Common Rating for Movies and TV Shows

This query identifies the most frequent content rating separately for Movies and TV Shows. By grouping ratings by content type, it reveals the maturity level and target audience Netflix most commonly serves across different formats.

```SQL
SELECT DISTINCT ON (type)
    type,
    rating,
    COUNT(*) AS rating_count
FROM netfilex
WHERE rating IS NOT NULL
GROUP BY type, rating
ORDER BY type, rating_count DESC;
```
<img width="1000" height="600" alt="Code_Generated_Image (1)" src="https://github.com/user-attachments/assets/ae03cd88-6993-4351-af97-a3121c3d540a" />

 **-** TV-MA is the most common rating for both Movies and TV Shows, indicating that Netflix heavily focuses on mature content.

**-** This suggests Netflix’s audience is largely adult-oriented, prioritizing complex storytelling, mature themes, and uncensored narratives.

**-** The consistency of TV-MA across both formats reflects a strong brand positioning toward edgier, premium entertainment rather than family-only programming.

### 3️⃣ Directors With the Most Netflix Content

This query identifies the most frequent content rating separately for Movies and TV Shows. By grouping ratings by content type, it reveals the maturity level and target audience Netflix most commonly serves across different formats.

``` SQL
SELECT
    directer,
    COUNT(*) AS total_titles
FROM netfilex
WHERE directer IS NOT NULL
GROUP BY directer
ORDER BY total_titles DESC
LIMIT 10;
```
<img width="1200" height="800" alt="Code_Generated_Image (2)" src="https://github.com/user-attachments/assets/061dd713-70d4-4083-a78e-945ad32b7dfa" />




### 4️⃣ Percentage of Movies vs TV Shows
``` SQL
SELECT
    type,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM netfilex
GROUP BY type;
```

### 5️⃣ Year With the Highest Content Releases
```SQL
SELECT
    release_year,
    COUNT(*) AS total_releases
FROM netfilex
GROUP BY release_year
ORDER BY total_releases DESC
LIMIT 1;
```
### 6️⃣ Most Common Genre by Content Type
``` SQL
WITH genre_count AS (
    SELECT
        type,
        listend_in,
        COUNT(*) AS genre_total,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netfilex
    WHERE listend_in IS NOT NULL
    GROUP BY type, listend_in
)
SELECT
    type,
    listend_in,
    genre_total
FROM genre_count
WHERE ranking = 1;
```

### 7️⃣ Countries Adding the Most Content in the Last 5 Years
``` SQL
SELECT
    country,
    COUNT(*) AS recent_additions
FROM netfilex
WHERE country IS NOT NULL
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 5
GROUP BY country
ORDER BY recent_additions DESC
LIMIT 5;
```


### 8️⃣ Average Movie Duration by Rating
``` SQL
SELECT
    rating,
    ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INT)), 1) AS avg_minutes
FROM netfilex
WHERE type = 'Movie'
  AND duration LIKE '%min%'
GROUP BY rating
ORDER BY avg_minutes DESC;
```

### 9️⃣ Longest Movie on Netflix
``` SQL
SELECT
    title,
    duration
FROM netfilex
WHERE type = 'Movie'
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 1;

```



### 🔟 Directors With Both Movies & TV Shows
``` SQL
SELECT
    directer
FROM netfilex
WHERE directer IS NOT NULL
GROUP BY directer
HAVING COUNT(DISTINCT type) = 2
LIMIT 1O;
```


### 1️⃣1️⃣ Ranking Release Years by Content Volume
``` SQL
SELECT
    release_year,
    COUNT(*) AS total_titles,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS year_rank
FROM netfilex
GROUP BY release_year
LIMIT 10;
```



### 1️⃣2️⃣ Top 3 Ratings Per Country
``` SQL
WITH rating_rank AS (
    SELECT
        country,
        rating,
        COUNT(*) AS rating_count,
        ROW_NUMBER() OVER (
            PARTITION BY country
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM netfilex
    WHERE country IS NOT NULL AND rating IS NOT NULL
    GROUP BY country, rating
)
SELECT
    country,
    rating,
    rating_count
FROM rating_rank
WHERE rn <= 3
LIMIT 10;
```



### 1️⃣3️⃣ Countries With More TV Shows Than Movies
``` SQL
SELECT
    country
FROM netfilex
GROUP BY country
HAVING
    COUNT(*) FILTER (WHERE type = 'TV Show')
    >
    COUNT(*) FILTER (WHERE type = 'Movie')
LIMIT 10;

```


### 1️⃣4️⃣ Most Recently Added Content
``` SQL
SELECT
    title,
    type,
    date_added
FROM netfilex
ORDER BY date_added DESC
LIMIT 10;
```

### 1️⃣5️⃣ Binge-Worthy TV Shows (More Than 5 Seasons)
``` SQL
SELECT
    title,
    duration
FROM netfilex
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 10;
```

#📈 Key Takeaways

Netflix content is heavily concentrated in a few key countries

Movies and TV Shows show distinct rating and genre patterns

Recent years reflect aggressive content expansion

Advanced SQL techniques enable deeper, more meaningful insights

#📌 Closing Thoughts

This project strengthened my ability to analyze real-world datasets using SQL and translate raw data into actionable insights. It reflects the kind of analytical thinking and technical skill expected in data analyst roles, particularly when working with large, structured datasets.
