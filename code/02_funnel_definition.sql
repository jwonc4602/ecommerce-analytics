-- 02_funnel_definition.sql
-- Purpose: build session-level funnel flags (UA Enhanced Ecommerce)

WITH session_funnel AS (
  SELECT
    fullVisitorId,
    visitId,
    trafficSource.source AS source,
    trafficSource.medium AS medium,

    MAX(IF(hits.eCommerceAction.action_type = '2', 1, 0)) AS viewed_product,
    MAX(IF(hits.eCommerceAction.action_type = '3', 1, 0)) AS added_to_cart,
    MAX(IF(hits.eCommerceAction.action_type = '5', 1, 0)) AS checkout,
    MAX(IF(hits.eCommerceAction.action_type = '6', 1, 0)) AS purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
  UNNEST(hits) AS hits
  GROUP BY fullVisitorId, visitId, source, medium
)

SELECT * FROM session_funnel
LIMIT 100;
