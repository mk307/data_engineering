/* Task 5: A DDL for hosts_cumulated table */

CREATE TABLE hosts_cumulated (
    host TEXT,
    host_activity_datelist DATE[],
    month_start DATE,
    PRIMARY KEY (host, month_start)
);