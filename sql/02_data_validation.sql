
-- =====================================================
-- PHASE 02: DATA VALIDATION
-- Project: Product Funnel and Conversion Drop-off Analysis
-- Database: product_funnel
-- Table: public.ecommerce_events
-- =====================================================

-- 1. Total rows and unique entities
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(DISTINCT user_session) AS unique_sessions,
    COUNT(DISTINCT product_id) AS unique_products
FROM public.ecommerce_events;


-- 2. Event type distribution
SELECT
    event_type,
    COUNT(*) AS event_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM public.ecommerce_events
GROUP BY event_type
ORDER BY event_count DESC;


-- 3. Missing value validation
SELECT
    COUNT(*) FILTER (WHERE event_time IS NULL) AS null_event_time,
    COUNT(*) FILTER (WHERE event_type IS NULL) AS null_event_type,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE category_id IS NULL) AS null_category_id,
    COUNT(*) FILTER (WHERE category_code IS NULL) AS null_category_code,
    COUNT(*) FILTER (WHERE brand IS NULL) AS null_brand,
    COUNT(*) FILTER (WHERE price IS NULL) AS null_price,
    COUNT(*) FILTER (WHERE user_id IS NULL) AS null_user_id,
    COUNT(*) FILTER (WHERE user_session IS NULL) AS null_user_session
FROM public.ecommerce_events;


-- 4. Duplicate event validation
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (
        event_time,
        event_type,
        product_id,
        category_id,
        category_code,
        brand,
        price,
        user_id,
        user_session
    )) AS distinct_rows
FROM public.ecommerce_events;


-- 5. Price validation
SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    COUNT(*) FILTER (WHERE price = 0) AS zero_price_events,
    COUNT(*) FILTER (WHERE price < 0) AS negative_price_events
FROM public.ecommerce_events;


-- 6. Event date range (UTC)
SELECT
    MIN(event_time) AT TIME ZONE 'UTC' AS earliest_event_utc,
    MAX(event_time) AT TIME ZONE 'UTC' AS latest_event_utc
FROM public.ecommerce_events;


-- 7. Unknown category and brand values
SELECT
    COUNT(*) FILTER (
        WHERE category_code = 'Unknown'
    ) AS unknown_category_codes,
    COUNT(*) FILTER (
        WHERE brand = 'Unknown'
    ) AS unknown_brands
FROM public.ecommerce_events;


-- 8. Product, category and brand diversity
SELECT
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT category_id) AS unique_categories,
    COUNT(DISTINCT brand) AS unique_brands
FROM public.ecommerce_events;


-- 9. Index verification
SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename = 'ecommerce_events'
ORDER BY indexname;
