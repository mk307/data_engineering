/* Task 1: DDL for actors table */

CREATE TYPE films AS(
	film TEXT,
	votes INTEGER,
	rating REAL,
	filmid TEXT,
	year INTEGER
);

CREATE TYPE quality_class AS
	ENUM ('bad', 'average', 'good', 'star');

CREATE TABLE actors (
    actor TEXT,
    actorid TEXT,
    current_year INTEGER,
    films films[], 
    avg_rating REAL, 
    quality_class quality_class,
    is_active BOOLEAN,
    PRIMARY KEY (actorid, current_year)
);