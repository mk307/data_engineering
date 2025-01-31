/* Task 4: Backfill query for actors_history_scd */

INSERT INTO actors_history_scd (actor, actorid, current_year, quality_class, is_active, start_date, end_date, is_current)
SELECT 
    actor, 
    actorid, 
    current_year, 
    quality_class, 
    is_active, 
    MAKE_DATE(current_year, 1, 1) AS start_date,
    MAKE_DATE(LEAD(current_year) OVER (PARTITION BY actorid ORDER BY current_year), 1, 1) - INTERVAL '1 day' AS end_date,
    LEAD(current_year) OVER (PARTITION BY actorid ORDER BY current_year) IS NULL AS is_current
FROM actors;

SELECT * 
FROM actors_history_scd;