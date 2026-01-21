-- 01_raw_exploration.sql
-- Purpose: dataset sanity checks + ecommerce action distribution

-- 1) Total sessions in dataset
SELECT COUNT(*) AS sessions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`;

-- 2) Ecommerce action_type distribution
SELECT
  hits.eCommerceAction.action_type AS action_type,
  COUNT(*) AS events
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
UNNEST(hits) AS hits
WHERE hits.eCommerceAction.action_type IS NOT NULL
GROUP BY action_type
ORDER BY events DESC;
