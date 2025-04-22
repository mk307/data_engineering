/* Task 3: A cumulative query to generate device_activity_datelist from events */

INSERT INTO user_devices_cumulated
WITH yesterday AS (
    SELECT *
    FROM user_devices_cumulated
    WHERE curr_date = '2023-01-30'::DATE
), today AS (
    SELECT 
        e.user_id AS user_id,
        d.browser_type AS browser_type,
        e.event_time::DATE AS event_date
    FROM events e 
        LEFT JOIN
        devices d 
        ON e.device_id = d.device_id
    WHERE e.event_time::DATE = '2023-01-31'::DATE
        AND e.user_id IS NOT NULL
        AND d.device_id IS NOT NULL
    GROUP BY e.user_id, d.browser_type, e.event_time::DATE
)
SELECT 
    COALESCE(y.user_id, t.user_id) AS user_id,
    COALESCE(t.event_date, y.curr_date + INTERVAL '1 day') AS curr_date,
    COALESCE(y.browser_type, t.browser_type) AS browser_type,
    CASE 
        WHEN y.device_activity_datelist IS NULL
        THEN ARRAY[t.event_date]
        WHEN t.event_date IS NULL
        THEN y.device_activity_datelist
        ELSE y.device_activity_datelist || ARRAY[t.event_date]
    END AS device_activity_datelist
FROM yesterday y FULL OUTER JOIN today t 
ON y.user_id = t.user_id AND y.browser_type = t.browser_type;