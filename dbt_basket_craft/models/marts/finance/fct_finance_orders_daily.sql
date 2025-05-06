/*
These come directly from tables in the warehouse
More for specific use cases
*/

WITH fct_finance_orders_daily AS (
  SELECT
      -- Time dimensions for financial reporting periods
      fdo.order_day,
    
      -- High-level financial KPIs (aggregated across all products)
      SUM(fdo.total_revenue_usd) AS daily_revenue_usd,
      SUM(fdo.total_cost_usd) AS daily_cost_usd,
      SUM(fdo.total_profit_usd) AS daily_profit_usd,
    
      -- Financial ratios CFOs track
      ROUND((SUM(fdo.total_profit_usd) / NULLIF(SUM(fdo.total_revenue_usd), 0) * 100)::numeric, 2) AS profit_margin_pct,
    
      -- Order volume
      SUM(fdo.total_orders) AS daily_order_count,
    
      -- Audit/metadata fields
      CURRENT_TIMESTAMP AS finance_report_generated_at
  FROM {{ ref('fct_orders_product_daily') }} fdo
  GROUP BY
      fdo.order_day
  ORDER BY
      fdo.order_day DESC
)
SELECT *
FROM fct_finance_orders_daily
