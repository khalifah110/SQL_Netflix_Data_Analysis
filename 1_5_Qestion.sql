-- 1. What are the top 5 countries with the most Netflix content?
SELECT
    country,
    COUNT(*) AS total_titles
FROM netfilex
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 5;


-- 2. What is the most common rating for Movies and TV Shows?
SELECT DISTINCT ON (type)
    type,
    rating,
    COUNT(*) AS rating_count
FROM netfilex
WHERE rating IS NOT NULL
GROUP BY type, rating
ORDER BY type, rating_count DESC;

-- 3. Which directors have produced the most content on Netflix?
SELECT
    directer,
    COUNT(*) AS total_titles
FROM netfilex
WHERE directer IS NOT NULL
GROUP BY directer
ORDER BY total_titles DESC
LIMIT 10;

-- 4. What percentage of Netflix content is Movies vs TV Shows?
SELECT
    type,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM netfilex
GROUP BY type;

-- 5. Which year had the highest number of content releases?
SELECT
    release_year,
    COUNT(*) AS total_releases
FROM netfilex
GROUP BY release_year
ORDER BY total_releases DESC
LIMIT 1;
