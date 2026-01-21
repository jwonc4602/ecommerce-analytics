-- 03_channel_performance.sql
-- Purpose: channel-level funnel performance + conversion rates

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
),
channel_summary AS (
  SELECT
    source,
    medium,
    COUNT(*) AS sessions,
    SUM(viewed_product) AS product_view_sessions,
    SUM(added_to_cart) AS add_to_cart_sessions,
    SUM(checkout) AS checkout_sessions,
    SUM(purchase) AS purchase_sessions
  FROM session_funnel
  GROUP BY source, medium
)

SELECT
  source,
  medium,
  sessions,
  product_view_sessions,
  add_to_cart_sessions,
  checkout_sessions,
  purchase_sessions,
  SAFE_DIVIDE(purchase_sessions, sessions) AS purchase_rate,
  SAFE_DIVIDE(purchase_sessions, checkout_sessions) AS checkout_to_purchase_rate,
  SAFE_DIVIDE(add_to_cart_sessions, product_view_sessions) AS view_to_cart_rate
FROM channel_summary
WHERE sessions >= 1000
ORDER BY purchase_rate DESC;
