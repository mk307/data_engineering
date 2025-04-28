# data_engineering

Project 1: Dimensional Data Modeling — Cumulative Host and User Activity Tracking

OVERVIEW

This project involves creating a dimensional data model to track cumulative daily activity of users and hosts. The goal was to build a stable, time-aware structure that accumulates daily event activity over a month while anchoring each record to a fixed month_start date.

The data model supports efficient analysis of activity trends, growth patterns, and engagement windows, and is ideal for systems where history must be retained and incrementally updated without duplicating records.

TECH STACK

- Database: PostgreSQL

- Techniques Used:

  1. FULL OUTER JOIN to combine previous and current day’s activity without loss.

  2. COALESCE logic to prioritize the latest available user or host activity data.

  3. ARRAY aggregation (ARRAY[] and || concatenation) to store daily active dates as arrays.

  4. Fixed month_start (2023-01-01) maintained for all entries across increments.

  5. Efficient incremental accumulation without duplicating or overwriting past history.

  6. Conflict handling and duplicate avoidance via key constraints on (host, month_start) and (user_id, curr_date).

TABLES DESIGNED

1. user_devices_cumulated: Tracks daily device activity per user with device_activity_datelist array.

2. hosts_cumulated: Tracks daily activity per host with host_activity_datelist array.

OUTCOMES

1. Managed slowly changing dimensions with array fields.

2. Handled time series accumulation across daily inserts.

3. Designed for future-proof incremental loads in relational databases.


Project 2: Fact Data Modeling — Incremental Host Activity Aggregation

OVERVIEW

This project extends the dimensional model by creating a monthly reduced fact table that captures daily hits and unique visitor counts for each host. This fact table is designed for incremental updates to optimize reporting and analytics on host-level usage patterns.

TECH STACK

- Database: PostgreSQL

- Techniques Used:

  1. Daily aggregation of COUNT(1) (total hits) and COUNT(DISTINCT user_id) (unique visitors).

  2. Storage of daily metrics in arrays (hit_array, unique_visitors_array) aligned with the day of the month.

  3. Fixed month column (2023-01-01) maintained to group daily arrays within the same logical month.

  4. Use of ON CONFLICT (host, month) DO UPDATE to efficiently append new day's metrics without duplication.

  5. Built-in support for incremental loading, enabling smooth updates without reprocessing the entire month.

TABLES DESIGNED

1. host_activity_reduced:

  - host: the host name

  - month: month start date (fixed as 2023-01-01)

  - hit_array: array storing daily total hits

  - unique_visitors_array: array storing daily unique visitor counts

OUTCOMES

1. Fact table optimization for performance and scalability.

2. Complex incremental insert and update patterns (ON CONFLICT DO UPDATE) for time series data.

3. Advanced use of arrays to efficiently capture daily granularity within a monthly partition.

4. Balanced normalization and denormalization for reporting needs.

