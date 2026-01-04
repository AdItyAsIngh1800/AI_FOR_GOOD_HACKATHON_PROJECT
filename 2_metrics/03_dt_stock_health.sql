USE DATABASE inventory_a4g;      -- replace with the DB admin granted
USE SCHEMA PUBLIC;        -- or whatever schema admin granted
USE WAREHOUSE WH_INVENTORY;


CREATE OR REPLACE VIEW V_STOCK_HEALTH AS
WITH latest AS (
  SELECT *
  FROM RAW_DAILY_STOCK
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY location, item
    ORDER BY stock_date DESC
  ) = 1
)
SELECT
  l.stock_date,
  l.location,
  l.item,
  l.closing_stock,
  d.avg_daily_issued AS daily_demand_est,

  CASE
    WHEN d.avg_daily_issued IS NULL OR d.avg_daily_issued = 0 THEN 9999
    ELSE l.closing_stock / d.avg_daily_issued
  END AS days_of_cover,

  CASE
    WHEN d.avg_daily_issued IS NOT NULL
         AND (l.closing_stock / d.avg_daily_issued) <= 5
      THEN 'CRITICAL'
    WHEN d.avg_daily_issued IS NOT NULL
         AND (l.closing_stock / d.avg_daily_issued) <= 10
      THEN 'WARNING'
    ELSE 'OK'
  END AS risk_level,

  CURRENT_TIMESTAMP() AS computed_at
FROM latest l
LEFT JOIN DT_DEMAND_EST d
  ON l.location = d.location
 AND l.item = d.item;

SELECT * FROM V_STOCK_HEALTH;
