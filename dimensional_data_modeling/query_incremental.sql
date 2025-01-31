/* Task 5: Incremental query for actors_history_scd */

/* Step 1: Closing existing records */

UPDATE actors_history_scd
SET end_date = current_date - INTERVAL '1 day',
    is_current = FALSE
WHERE is_current = TRUE
  AND EXISTS (
      SELECT 1 
      FROM actors i
      WHERE actors_history_scd.actorid = i.actorid
        AND actors_history_scd.current_year = i.current_year
        AND (actors_history_scd.quality_class IS DISTINCT FROM i.quality_class 
             OR actors_history_scd.is_active IS DISTINCT FROM i.is_active)
  );

/* Step 2: Insert new records */

INSERT INTO actors_history_scd (actor, actorid, current_year, quality_class, is_active, start_date, end_date, is_current)
SELECT 
    i.actor, 
    i.actorid, 
    i.current_year, 
    i.quality_class, 
    i.is_active, 
    MAKE_DATE(i.current_year, 1, 1) AS start_date,
    NULL AS end_date,
    TRUE AS is_current
FROM actors i
WHERE NOT EXISTS (
    SELECT 1
    FROM actors_history_scd h
    WHERE h.actorid = i.actorid
      AND h.current_year = i.current_year
      AND h.start_date = MAKE_DATE(i.current_year, 1, 1)
);
