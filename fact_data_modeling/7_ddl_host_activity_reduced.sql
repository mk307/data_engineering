/* Task 7: A monthly, reduced fact table DDL host_activity_reduced */

CREATE TABLE host_activity_reduced (
    month DATE NOT NULL,
    host TEXT NOT NULL,
    hit_array INTEGER[] NOT NULL,
    unique_visitors_array INTEGER[] NOT NULL,
    PRIMARY KEY (month, host)
);