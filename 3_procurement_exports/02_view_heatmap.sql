CREATE OR REPLACE VIEW V_HEATMAP AS
SELECT
  location,
  item,
  days_of_cover,
  risk_level,
  closing_stock,
  daily_demand_est
FROM V_STOCK_HEALTH;

SELECT * FROM V_HEATMAP;
