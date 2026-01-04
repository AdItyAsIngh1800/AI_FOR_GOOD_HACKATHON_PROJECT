CREATE OR REPLACE VIEW V_PROCUREMENT_PRIORITY AS
SELECT
  location,
  item,
  closing_stock,
  daily_demand_est,
  days_of_cover,
  risk_level,
  computed_at,

  CASE
    WHEN risk_level = 'CRITICAL' THEN 1
    WHEN risk_level = 'WARNING' THEN 2
    ELSE 3
  END AS priority_rank
FROM V_STOCK_HEALTH
WHERE risk_level IN ('CRITICAL','WARNING')
ORDER BY priority_rank, days_of_cover ASC;

SELECT * FROM V_PROCUREMENT_PRIORITY;
