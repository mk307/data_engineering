/* Task 2: Cumulative table generation query */

INSERT INTO actors (actor, actorid, films, current_year, avg_rating, quality_class, is_active) 

WITH yesterday AS (
    SELECT *
    FROM actors
    WHERE current_year = 2021 
),
today AS (
    SELECT 
        actor,
        actorid,
        year AS film_year,
        ARRAY_AGG(ROW(film, votes, rating, filmid, year)::films) AS films_in_year, 
        AVG(rating) AS avg_rating 
    FROM actor_films
    WHERE year = 2022
    GROUP BY actor, actorid, year
)
SELECT 
    COALESCE(t.actor, y.actor) AS actor,
    COALESCE(t.actorid, y.actorid) AS actorid,
    COALESCE(y.films, '{}') || COALESCE(t.films_in_year, '{}') AS films, 
    COALESCE(t.film_year, y.current_year + 1) AS current_year, 
    COALESCE(t.avg_rating, y.avg_rating) AS avg_rating, 
    CASE
        WHEN t.avg_rating IS NOT NULL 
        THEN 
            CASE 
                WHEN t.avg_rating > 8 THEN 'star'
                WHEN t.avg_rating > 7 THEN 'good' 
                WHEN t.avg_rating > 6 THEN 'average'
                ELSE 'bad'
            END::quality_class
        ELSE y.quality_class
    END AS quality_class,
    CASE 
        WHEN t.film_year IS NOT NULL 
        THEN TRUE
        ELSE FALSE 
    END AS is_active
FROM today t 
FULL OUTER JOIN yesterday y 
ON t.actorid = y.actorid;