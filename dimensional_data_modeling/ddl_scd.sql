/* Task 3: DDL for actors_history_scd table */

CREATE TABLE actors_history_scd (
    scd_id SERIAL PRIMARY KEY,
    actor TEXT NOT NULL,
    actorid TEXT NOT NULL,
    current_year INTEGER NOT NULL,
    quality_class quality_class NOT NULL,
    is_active BOOLEAN NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE DEFAULT NULL,
    is_current BOOLEAN DEFAULT TRUE,
    UNIQUE (actorid, current_year, start_date)
);