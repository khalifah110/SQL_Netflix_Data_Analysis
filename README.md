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

**-** Directors like Rajiv Chilaka and Raúl Campos & Jan Suter appear frequently, indicating repeat collaborations with Netflix.

 **-** A mix of international and Hollywood directors shows Netflix’s openness to diverse creative voices.

 **-** Well-known names such as Martin Scorsese and Steven Spielberg appearing in the top list reinforce Netflix’s credibility as a platform for high-profile filmmakers.

 **-** The results suggest Netflix values consistent content production from trusted directors.


### 4️⃣ Percentage of Movies vs TV Shows

This question compares the overall content mix on Netflix by calculating the percentage of Movies versus TV Shows. It helps understand Netflix’s strategic focus between standalone films and episodic content.

``` SQL
SELECT
    type,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM netfilex
GROUP BY type;
```

| TYPE     | PERCENTAGE   |
|----------|--------------|
|Movie     | 69.62        |
|TV Show   | 30.38        |


**-** Movies make up nearly 70% of Netflix’s catalog, indicating a stronger emphasis on film content.

**-** TV Shows account for just over 30%, yet they often drive longer user engagement through binge-watching.

**-** The imbalance suggests Netflix prioritizes content volume through movies, while still leveraging TV Shows for subscriber retention and engagement.

**-** This mix supports Netflix’s dual strategy of broad content availability and long-form storytelling.

### 5️⃣ Year With the Highest Content Releases

This query identifies the year with the highest volume of content releases, offering insight into Netflix’s peak production or acquisition period.

```SQL
SELECT
    release_year,
    COUNT(*) AS total_releases
FROM netfilex
GROUP BY release_year
ORDER BY total_releases DESC
LIMIT 1;
```

|RELEASE YEAR|TOTAL RELEASE|
|------------|-------------|
| 2018       | 1147        |


**-** 2018 recorded the highest number of releases, with over 1,100 titles added.

**-** This peak aligns with Netflix’s aggressive expansion phase, where it heavily invested in original content to outpace competitors.

**-** The spike suggests a strategic push to rapidly grow the content library and attract new subscribers globally.

**-** Understanding this trend helps contextualize Netflix’s content growth strategy over time.

### 6️⃣ Most Common Genre by Content Type

What is the most common genre for Movies and TV Shows on Netflix?

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


**-** Movies: The dominance of Dramas, International Movies shows Netflix’s strong focus on emotionally driven and globally diverse storytelling.

**-** TV Shows: Kids’ TV being the most common genre highlights Netflix’s strategic investment in family-friendly and children’s programming.

**-** Business Insight: Netflix balances global drama content with long-term engagement genres like kids’ shows that encourage repeat viewing and subscriptions.

### 7️⃣ Countries Adding the Most Content in the Last 5 Years

Which countries have contributed the most new content to Netflix in the past five years?

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

**-** The United States continues to dominate Netflix’s content pipeline.

**-** India and South Korea reflect Netflix’s expansion into high-growth international markets.

**-** Business Insight: Netflix is actively diversifying content production globally to reach broader audiences and localize its offerings.

### 8️⃣ Average Movie Duration by Rating

What is the average duration of movies based on their content rating?

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

**-** Higher-rated content (NC-17, TV-14) tends to be significantly longer, often due to complex narratives.

**-** Children’s content has shorter runtimes to match attention spans.

**-** Business Insight: Runtime varies strategically by target audience, influencing content pacing and production decisions.

### 9️⃣ Longest Movie on Netflix

Which movie has the longest runtime on Netflix?

``` SQL
SELECT
    title,
    duration
FROM netfilex
WHERE type = 'Movie'
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 1;

```
**-** The result reveals data quality issues, where duration information is missing.

**-** Business Insight: Incomplete metadata can affect analytics accuracy and user experience (e.g., filtering by length).

**-** Highlights the importance of data validation and cleaning in real-world analytics projects.

### 🔟 Directors With Both Movies & TV Shows

Which directors have created both Movies and TV Shows on Netflix?

``` SQL
SELECT
    directer
FROM netfilex
WHERE directer IS NOT NULL
GROUP BY directer
HAVING COUNT(DISTINCT type) = 2
LIMIT 1O;
```
**-** These directors demonstrate cross-format versatility, contributing to both long-form series and standalone films.

**-** Business Insight: Directors capable of working across formats offer Netflix flexibility in content strategy and production planning.

### 1️⃣1️⃣ Ranking Release Years by Content Volume

Which years saw the highest number of content releases on Netflix?

``` SQL
SELECT
    release_year,
    COUNT(*) AS total_titles,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS year_rank
FROM netfilex
GROUP BY release_year
LIMIT 10;
```
**-** 2018 stands out as Netflix’s most aggressive expansion year.

**-** A steady increase from 2015–2019 reflects Netflix’s rapid global growth phase.

**-** The drop after 2020 may reflect content production disruptions and shifts in strategy.

**-** Business Insight: Understanding peak release years helps evaluate content investment cycles and platform growth phases.


### 1️⃣2️⃣ Top 3 Ratings Per Country

What are the most common content ratings across different countries?

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

**-** TV-MA and TV-14 dominate globally, suggesting Netflix prioritizes mature and teen audiences.

**-** Rating distribution varies by region, reflecting cultural and regulatory differences.

**-** Business Insight: Rating trends guide content localization and compliance strategies across countries.


### 1️⃣3️⃣ Countries With More TV Shows Than Movies

Which countries produce more TV Shows than Movies on Netflix?
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

**-** These regions show a strong preference for episodic content.

**-** TV Shows encourage longer user engagement and repeat viewing.

**-** Business Insight: Netflix may focus series-based investments in these regions to maximize retention.


### 1️⃣4️⃣ Most Recently Added Content

What content was added most recently to Netflix?

``` SQL
SELECT
    title,
    type,
    date_added
FROM netfilex
ORDER BY date_added DESC
LIMIT 10;
```

**-** Several recent entries lack date metadata, revealing data completeness issues.

**-** Business Insight: Accurate “date added” fields are critical for content freshness analysis, recommendations, and marketing campaigns.

**-** This highlights the real-world challenge of working with imperfect datasets.


### 1️⃣5️⃣ Binge-Worthy TV Shows (More Than 5 Seasons)

Which TV Shows on Netflix are considered binge-worthy based on season count?

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
**-** Long-running shows dominate binge-watching behavior.

**-** These titles are high-retention assets, often driving long-term subscriptions.

**-** Business Insight: Investing in multi-season content increases user lifetime value and platform loyalty.

# 📈 Key Takeaways

Netflix content is heavily concentrated in a few key countries

Movies and TV Shows show distinct rating and genre patterns

Recent years reflect aggressive content expansion

Advanced SQL techniques enable deeper, more meaningful insights

# 📌 Closing Thoughts

This project strengthened my ability to analyze real-world datasets using SQL and translate raw data into actionable insights. It reflects the kind of analytical thinking and technical skill expected in data analyst roles, particularly when working with large, structured datasets.
