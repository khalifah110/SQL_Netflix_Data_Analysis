-- 11. Rank content release years by number of titles added
SELECT
    release_year,
    COUNT(*) AS total_titles,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS year_rank
FROM netfilex
GROUP BY release_year;

-- 12. Find the top 3 most common ratings per country
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
WHERE rn <= 3;
 
-- 13. Which countries specialize more in TV Shows than Movies?
SELECT
    country
FROM netfilex
GROUP BY country
HAVING
    COUNT(*) FILTER (WHERE type = 'TV Show')
    >
    COUNT(*) FILTER (WHERE type = 'Movie');

-- 14. Find content added most recently to Netflix
SELECT
    title,
    type,
    date_added
FROM netfilex
ORDER BY date_added DESC
LIMIT 10;

-- 15. Identify binge-worthy TV Shows (more than 5 seasons)
SELECT
    title,
    duration
FROM netfilex
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC;
