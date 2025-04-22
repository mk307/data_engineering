/* Task 6: The incremental query to generate host_activity_datelist */

INSERT INTO hosts_cumulated (host, host_activity_datelist, month_start)
WITH yesterday AS (
    SELECT *
    FROM hosts_cumulated
    WHERE month_start = '2023-01-01'::DATE
), today AS (
    SELECT 
        e.host,
        e.event_time::DATE AS event_date 
    FROM events e
    WHERE e.event_time::DATE = '2023-01-31'::DATE 
    GROUP BY e.host, e.event_time::DATE
), merged AS (
    SELECT 
        COALESCE(y.host, t.host) AS host,
        CASE 
            WHEN y.host_activity_datelist IS NULL THEN ARRAY[t.event_date]
            WHEN t.event_date IS NULL THEN y.host_activity_datelist
            ELSE y.host_activity_datelist || ARRAY[t.event_date]
        END AS host_activity_datelist,
		'2023-01-01'::DATE AS month_start
    FROM yesterday y
    FULL OUTER JOIN today t
        ON y.host = t.host
)
SELECT * FROM merged
ON CONFLICT (host, month_start)
DO UPDATE SET host_activity_datelist = EXCLUDED.host_activity_datelist;
