/* Task 2: A DDL for an user_devices_cumulated table */

CREATE TABLE user_devices_cumulated (
    user_id NUMERIC,
    curr_date DATE,
    browser_type TEXT,
    device_activity_datelist DATE[],
    PRIMARY KEY (user_id, browser_type, curr_date)
);