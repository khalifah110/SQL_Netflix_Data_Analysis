-- 6. Find the most common genre (listend_in) for each content type
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

-- 7. Which countries added the most content in the last 5 years?
SELECT
    country,
    COUNT(*) AS recent_additions
FROM netfilex
WHERE country IS NOT NULL
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 5
GROUP BY country
ORDER BY recent_additions DESC
LIMIT 5;

-- 8. What is the average movie duration by rating?
SELECT
    rating,
    ROUND(AVG(CAST(SPLIT_PART(duration, ' ', 1) AS INT)), 1) AS avg_minutes
FROM netfilex
WHERE type = 'Movie'
  AND duration LIKE '%min%'
GROUP BY rating
ORDER BY avg_minutes DESC;

-- 9. Identify the longest movie available on Netflix
SELECT
    title,
    duration
FROM netfilex
WHERE type = 'Movie'
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 1;


-- 10. Which directors have both Movies and TV Shows on Netflix?
SELECT
    directer
FROM netfilex
WHERE directer IS NOT NULL
GROUP BY directer
HAVING COUNT(DISTINCT type) = 2;
