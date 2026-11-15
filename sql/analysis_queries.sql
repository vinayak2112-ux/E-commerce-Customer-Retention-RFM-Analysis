USE olist_ecommerce;

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

SHOW TABLES;

RENAME TABLE
    customers_dataset TO customers,
    geolocation_dataset TO geolocation,
    order_items_dataset TO order_items,
    order_payments_dataset TO order_payments,
    order_reviews_dataset TO order_reviews,
    orders_dataset TO orders,
    products_dataset TO products,
    sellers_dataset TO sellers,
    product_category_name_translation TO category_translation;
    
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT
    COUNT(*) AS total_records,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(order_purchase_timestamp IS NULL) AS missing_date,
    SUM(order_status IS NULL) AS missing_status
FROM orders;

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date,
    COUNT(*) AS total_orders
FROM orders;


SELECT
    COUNT(DISTINCT o.order_id) AS total_delivered_orders,
    ROUND(SUM(oi.price), 2) AS total_product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY sales_month
ORDER BY sales_month;


SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY sales_month
ORDER BY monthly_revenue DESC
LIMIT 1;

SELECT
    oi.product_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.order_item_id IS NOT NULL) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'delivered'

GROUP BY oi.product_id

ORDER BY total_revenue DESC

LIMIT 10;


SELECT
    COALESCE(
        ct.product_category_name_english,
        'Unknown'
    ) AS product_category,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    COUNT(*) AS total_items_sold,

    ROUND(SUM(oi.price), 2) AS total_revenue

FROM orders o

JOIN order_items oi
    ON o.order_id = oi.order_id

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name =
       ct.product_category_name

WHERE o.order_status = 'delivered'

GROUP BY product_category

ORDER BY total_revenue DESC

LIMIT 10;

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM orders o

    JOIN customers c
        ON o.customer_id = c.customer_id

    WHERE o.order_status = 'delivered'

    GROUP BY c.customer_unique_id
)

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,

    COUNT(*) AS total_customers,

    SUM(total_orders) AS total_orders

FROM customer_orders

GROUP BY customer_type;

WITH customer_orders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)

SELECT
    COUNT(*) AS total_customers,

    SUM(total_orders = 1) AS one_time_customers,

    SUM(total_orders > 1) AS repeat_customers,

    ROUND(
        SUM(total_orders > 1) * 100.0 / COUNT(*),
        2
    ) AS repeat_purchase_rate

FROM customer_orders;

WITH customer_rfm AS
(
    SELECT
        c.customer_unique_id,

        MAX(o.order_purchase_timestamp) AS last_purchase_date,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(SUM(oi.price), 2) AS monetary

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    DATEDIFF(
        (SELECT MAX(order_purchase_timestamp)
         FROM orders),
        last_purchase_date
    ) AS recency_days,

    frequency,
    monetary

FROM customer_rfm

ORDER BY monetary DESC
LIMIT 20;

WITH customer_rfm AS
(
    SELECT
        c.customer_unique_id,
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp)
             FROM orders),
            MAX(o.order_purchase_timestamp)
        ) AS recency,

        COUNT(DISTINCT o.order_id) AS frequency,

        SUM(oi.price) AS monetary

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY c.customer_unique_id
),

rfm_scores AS
(
    SELECT
        customer_unique_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency ASC
        ) AS R_score,

        NTILE(5) OVER (
            ORDER BY frequency DESC
        ) AS F_score,

        NTILE(5) OVER (
            ORDER BY monetary DESC
        ) AS M_score

    FROM customer_rfm
)

SELECT
    *,
    CONCAT(R_score, F_score, M_score) AS RFM_score

FROM rfm_scores

ORDER BY RFM_score DESC
LIMIT 30;


WITH customer_rfm AS
(
    SELECT
        c.customer_unique_id,

        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp)
             FROM orders
             WHERE order_status = 'delivered'),
            MAX(o.order_purchase_timestamp)
        ) AS recency,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(SUM(oi.price), 2) AS monetary

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY c.customer_unique_id
),

rfm_scores AS
(
    SELECT
        customer_unique_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency ASC
        ) AS R_score,

        NTILE(5) OVER (
            ORDER BY frequency DESC
        ) AS F_score,

        NTILE(5) OVER (
            ORDER BY monetary DESC
        ) AS M_score

    FROM customer_rfm
),

customer_segments AS
(
    SELECT
        *,
        CASE
            WHEN R_score >= 4 AND F_score >= 4
                 AND M_score >= 4
                THEN 'Champions'

            WHEN R_score >= 3 AND F_score >= 3
                THEN 'Loyal Customers'

            WHEN R_score >= 4 AND F_score <= 2
                THEN 'Potential Loyalists'

            WHEN R_score <= 2 AND F_score >= 3
                THEN 'At Risk'

            WHEN R_score <= 2 AND F_score <= 2
                THEN 'Lost Customers'

            ELSE 'Others'
        END AS customer_segment

    FROM rfm_scores
)

SELECT
    customer_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(monetary), 2) AS total_revenue,
    ROUND(AVG(monetary), 2) AS average_customer_spending

FROM customer_segments

GROUP BY customer_segment

ORDER BY total_revenue DESC;


WITH customer_first_purchase AS
(
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)

SELECT
    DATE_FORMAT(first_purchase_date, '%Y-%m') AS cohort_month,
    COUNT(*) AS new_customers
FROM customer_first_purchase
GROUP BY cohort_month
ORDER BY cohort_month;

WITH delivered_orders AS (
    SELECT DISTINCT
        c.customer_unique_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS order_month
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_cohorts AS (
    SELECT
        customer_unique_id,
        MIN(order_month) AS cohort_month
    FROM delivered_orders
    GROUP BY customer_unique_id
),

cohort_activity AS (
    SELECT
        d.customer_unique_id,
        c.cohort_month,
        d.order_month,
        TIMESTAMPDIFF(
            MONTH,
            STR_TO_DATE(c.cohort_month, '%Y-%m-%d'),
            STR_TO_DATE(d.order_month, '%Y-%m-%d')
        ) AS month_number
    FROM delivered_orders d
    JOIN customer_cohorts c
        ON d.customer_unique_id = c.customer_unique_id
),

cohort_counts AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT customer_unique_id) AS active_customers
    FROM cohort_activity
    GROUP BY cohort_month, month_number
),

cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(*) AS cohort_size
    FROM customer_cohorts
    GROUP BY cohort_month
)

SELECT
    cc.cohort_month,
    cc.month_number,
    cc.active_customers,
    cs.cohort_size,
    ROUND(
        cc.active_customers * 100.0 / cs.cohort_size,
        2
    ) AS retention_rate
FROM cohort_counts cc
JOIN cohort_sizes cs
    ON cc.cohort_month = cs.cohort_month
ORDER BY cc.cohort_month, cc.month_number;

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS lifetime_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY lifetime_spending DESC
LIMIT 10;

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) = 1
ORDER BY total_spending DESC
LIMIT 10;

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) = 1
ORDER BY total_spending DESC
LIMIT 10;	
