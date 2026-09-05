                                  ---Enterprise_nz_ecommerce_engine---

---1.Regional Financial Performance & 15% GST Breakdown---
--Techniques: Multi-table Joins, Aggregations, Safe Math, NZ IRD Tax Logic--
SELECT 
    r.region_name,
    r.island,
    COUNT(DISTINCT o.order_id) AS total_completed_orders,
    SUM(oi.quantity * oi.unit_price_nzd) AS gross_sales_nzd,
    -- 15% NZ GST Extraction
    ROUND(SUM(oi.quantity * oi.unit_price_nzd) - (SUM(oi.quantity * oi.unit_price_nzd) / 1.15), 2) AS gst_payable_nzd,
    ROUND(SUM(oi.quantity * oi.unit_price_nzd) / 1.15, 2) AS net_revenue_nzd
FROM nz_regions r
JOIN customers c ON r.region_id = c.region_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'COMPLETED'
GROUP BY r.region_name, r.island
ORDER BY gross_sales_nzd DESC;



---2.Customer Spend Segmentation (NTILE) & Tier Ranking---
--Techniques: CTEs, Aggregation Filtering (HAVING), NTILE(4) Quartiles, DENSE_RANK()--
WITH customer_spend AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.customer_tier,
        SUM(oi.quantity * oi.unit_price_nzd) AS total_spend_nzd
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'COMPLETED'
    GROUP BY c.customer_id, c.customer_name, c.customer_tier
),
quartile_buckets AS (
    SELECT 
        customer_id,
        customer_name,
        customer_tier,
        total_spend_nzd,
        NTILE(4) OVER (ORDER BY total_spend_nzd DESC) AS spend_quartile
    FROM customer_spend
)
SELECT 
    customer_id,
    customer_name,
    customer_tier,
    total_spend_nzd,
    spend_quartile,
    DENSE_RANK() OVER (PARTITION BY spend_quartile ORDER BY total_spend_nzd DESC) AS rank_in_quartile
FROM quartile_buckets
ORDER BY spend_quartile ASC, rank_in_quartile ASC;



---3.Rapid Transaction Fraud & Velocity Monitoring---
--Techniques: LAG(), Date Arithmetic (EPOCH), Time Interval Conversions, Fraud Analytics--
WITH transaction_velocity AS (
    SELECT 
        o.customer_id,
        o.order_id AS current_order_id,
        LAG(o.order_id) OVER (PARTITION BY o.customer_id ORDER BY o.order_timestamp) AS previous_order_id,
        SUM(oi.quantity * oi.unit_price_nzd) AS current_order_value,
        LAG(SUM(oi.quantity * oi.unit_price_nzd)) OVER (PARTITION BY o.customer_id ORDER BY o.order_timestamp) AS previous_order_value,
        o.order_timestamp AS current_time,
        LAG(o.order_timestamp) OVER (PARTITION BY o.customer_id ORDER BY o.order_timestamp) AS previous_time
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'COMPLETED'
    GROUP BY o.customer_id, o.order_id, o.order_timestamp
)
SELECT 
    c.customer_name,
    tv.customer_id,
    tv.previous_order_id,
    tv.current_order_id,
    tv.previous_order_value,
    tv.current_order_value,
    ROUND((EXTRACT(EPOCH FROM (tv.current_time - tv.previous_time)) / 60.0)::numeric, 2) AS minutes_between_orders
FROM transaction_velocity tv
JOIN customers c ON tv.customer_id = c.customer_id
WHERE tv.previous_order_id IS NOT NULL
  AND EXTRACT(EPOCH FROM (tv.current_time - tv.previous_time)) / 60.0 <= 5.0
  AND tv.current_order_value >= 1.5 * tv.previous_order_value;



---4.7-Day Moving Average Revenue & EFTPOS Channel Share---
--Techniques: ROWS BETWEEN, Frame Clauses, Conditional Aggregation (FILTER), Division Safety (NULLIF)--
WITH daily_channel_sales AS (
    SELECT 
        o.order_timestamp::date AS sales_date,
        SUM(oi.quantity * oi.unit_price_nzd) AS daily_revenue_nzd,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.order_id) FILTER (WHERE o.payment_method = 'EFTPOS') AS eftpos_orders
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'COMPLETED'
    GROUP BY o.order_timestamp::date
)
SELECT 
    sales_date,
    daily_revenue_nzd,
    -- 7-Day Moving Average (6 Preceding Days + Current Day)
    ROUND(
        AVG(daily_revenue_nzd) OVER (
            ORDER BY sales_date ASC 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_7d_nzd,
    -- EFTPOS Channel Adoption Rate (%)
    ROUND(
        (eftpos_orders::numeric / NULLIF(total_orders, 0)) * 100, 2
    ) AS eftpos_usage_pct
FROM daily_channel_sales
ORDER BY sales_date ASC;



---5.Product Category Revenue Performance Index---
--Identifies products in inventory that have NEVER generated a completed order
--Techniques: Subqueries, EXCEPT Set Operator, Product Inventory Auditing--

SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price_nzd,
    p.stock_quantity
FROM products p
WHERE p.product_id IN (
    SELECT product_id FROM products
    EXCEPT
    SELECT DISTINCT oi.product_id 
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'COMPLETED'
);

