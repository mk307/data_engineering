/* Task 4: A datelist_int generation query. Convert the device_activity_datelist column into a datelist_int column */

WITH 
users AS (
	SELECT *
	FROM user_devices_cumulated
	WHERE curr_date = DATE('2023-01-31')
),
series AS (
	SELECT * 
	FROM generate_series(DATE('2023-01-01'), DATE('2023-01-31'), INTERVAL '1 day') 
		AS series_date
),
placeholder_ints AS (
	SELECT 
		CASE
			WHEN device_activity_datelist @> ARRAY[DATE(series_date)]
			THEN CAST(POW(2, 32 - (curr_date - DATE(series_date))) AS BIGINT)
			ELSE 0
		END AS placeholder_int_value,
		*
	FROM users
	CROSS JOIN series
)
SELECT 
	user_id,
	CAST(CAST(SUM(placeholder_int_value) AS BIGINT) AS bit(32)),
	BIT_COUNT(CAST(CAST(SUM(placeholder_int_value) AS BIGINT) AS bit(32))),
	BIT_COUNT(CAST(CAST(SUM(placeholder_int_value) AS BIGINT) AS bit(32))) > 0
		AS dim_is_monthly_active,
	BIT_COUNT(CAST('11111110000000000000000000000000' AS bit(32)) &
		CAST(CAST(SUM(placeholder_int_value) AS BIGINT) AS bit(32))) > 0
		AS dim_is_weekly_active,
	BIT_COUNT(CAST('10000000000000000000000000000000' AS bit(32)) &
		CAST(CAST(SUM(placeholder_int_value) AS BIGINT) AS bit(32))) > 0
		AS dim_is_daily_active
FROM placeholder_ints
GROUP BY user_id;