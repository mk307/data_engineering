/* Task 8: An incremental query that loads host_activity_reduced */

INSERT INTO host_activity_reduced (month, host, hit_array, unique_visitors_array)
WITH 
 	yesterday AS (
        SELECT *
        FROM host_activity_reduced
        WHERE month = DATE_TRUNC('month', '2023-01-01'::DATE) -- this date remains constant
),
    today AS (
        SELECT
            host,
            COUNT(1) AS daily_hits,
            COUNT(DISTINCT user_id) AS daily_unique_visitors,
            '2023-01-01'::DATE AS today_date -- this date remains constant
        FROM events
        WHERE event_time::DATE = '2023-01-31'::DATE -- only this date increments
        GROUP BY host
    )
SELECT 
    DATE_TRUNC('month', t.today_date)::DATE AS month,
    COALESCE(t.host, y.host) AS host,
    CASE 
        WHEN y.hit_array IS NULL THEN ARRAY[t.daily_hits]
        WHEN t.daily_hits IS NULL THEN y.hit_array
        ELSE y.hit_array || t.daily_hits
    END AS hit_array,
    CASE 
        WHEN y.unique_visitors_array IS NULL THEN ARRAY[t.daily_unique_visitors]
        WHEN t.daily_unique_visitors IS NULL THEN y.unique_visitors_array
        ELSE y.unique_visitors_array || t.daily_unique_visitors
    END AS unique_visitors_array
FROM today t
FULL OUTER JOIN yesterday y
    ON t.host = y.host
ON CONFLICT (month, host)
DO UPDATE SET 
    hit_array = EXCLUDED.hit_array,
    unique_visitors_array = EXCLUDED.unique_visitors_array;