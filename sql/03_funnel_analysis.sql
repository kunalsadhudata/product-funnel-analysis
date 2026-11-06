
-- =====================================================
-- PHASE 04: SQL FUNNEL & CONVERSION ANALYSIS
-- Project: Product Funnel and Conversion Drop-off Analysis
-- Database: product_funnel
-- Table: public.ecommerce_events
-- =====================================================

-- Step 04.5: Count Unique Product-View Journeys
-- Journey key: user_id + user_session + product_id
-- Each journey is counted once, even with repeated views.
-- Verified Python baseline: 552,900 journeys.

SELECT COUNT(*) AS view_journeys
FROM (
    SELECT DISTINCT
        user_id,
        user_session,
        product_id
    FROM public.ecommerce_events
    WHERE event_type = 'view'
      AND user_session IS NOT NULL
) AS unique_view_journeys;



---------------------------------------------------------------------------------------------------------------------


-- =====================================================
-- Step 04.7: Count View-to-Cart Journeys
-- =====================================================
-- A cart qualifies only if it occurs strictly after
-- a view for the same user, session, and product.
-- Repeated cart events do not increase journey counts.
-- Verified Python baseline: 12,725 journeys.
-- Verified PostgreSQL result: 12,725 journeys.

WITH first_views AS (
    SELECT
        user_id,
        user_session,
        product_id,
        MIN(event_time) AS first_view_time
    FROM public.ecommerce_events
    WHERE event_type = 'view'
      AND user_session IS NOT NULL
    GROUP BY
        user_id,
        user_session,
        product_id
)

SELECT COUNT(*) AS view_to_cart_journeys
FROM first_views AS v
WHERE EXISTS (
    SELECT 1
    FROM public.ecommerce_events AS c
    WHERE c.user_id = v.user_id
      AND c.user_session = v.user_session
      AND c.product_id = v.product_id
      AND c.event_type = 'cart'
      AND c.event_time > v.first_view_time
);




--------------------------------------------------------------------------------------------------------------------


-- =====================================================
-- Step 04.9: Count Completed Purchase Journeys
-- =====================================================
-- A completed journey requires:
-- 1. A product view.
-- 2. A cart strictly after the view.
-- 3. A purchase strictly after the qualifying cart.
-- All events must share the same user, session, product.
-- Verified Python baseline: 6,300 journeys.
-- Verified PostgreSQL result: 6,300 journeys.

WITH first_views AS (
    SELECT
        user_id,
        user_session,
        product_id,
        MIN(event_time) AS first_view_time
    FROM public.ecommerce_events
    WHERE event_type = 'view'
      AND user_session IS NOT NULL
    GROUP BY
        user_id,
        user_session,
        product_id
),

first_carts AS (
    SELECT
        v.user_id,
        v.user_session,
        v.product_id,
        MIN(c.event_time) AS first_cart_time
    FROM first_views AS v
    JOIN public.ecommerce_events AS c
      ON c.user_id = v.user_id
     AND c.user_session = v.user_session
     AND c.product_id = v.product_id
     AND c.event_type = 'cart'
     AND c.event_time > v.first_view_time
    GROUP BY
        v.user_id,
        v.user_session,
        v.product_id
)

SELECT COUNT(*) AS completed_purchase_journeys
FROM first_carts AS c
WHERE EXISTS (
    SELECT 1
    FROM public.ecommerce_events AS p
    WHERE p.user_id = c.user_id
      AND p.user_session = c.user_session
      AND p.product_id = c.product_id
      AND p.event_type = 'purchase'
      AND p.event_time > c.first_cart_time
);




-- =====================================================
-- Step 04.16: Verified Funnel KPI Calculations
-- =====================================================
-- These counts were independently verified in PostgreSQL.
-- This is a baseline calculation section.
-- A data-driven KPI query will be added later.

WITH verified_counts AS (
    SELECT
        552900::NUMERIC AS view_journeys,
        12725::NUMERIC AS cart_journeys,
        6300::NUMERIC AS purchase_journeys
)

SELECT
    view_journeys,
    cart_journeys,
    purchase_journeys,

    ROUND(
        cart_journeys / NULLIF(view_journeys, 0) * 100,
        2
    ) AS view_to_cart_conversion_pct,

    ROUND(
        purchase_journeys / NULLIF(cart_journeys, 0) * 100,
        2
    ) AS cart_to_purchase_conversion_pct,

    ROUND(
        purchase_journeys / NULLIF(view_journeys, 0) * 100,
        2
    ) AS overall_conversion_pct,

    view_journeys - cart_journeys
        AS view_to_cart_dropoff,

    ROUND(
        (view_journeys - cart_journeys)
        / NULLIF(view_journeys, 0) * 100,
        2
    ) AS view_to_cart_dropoff_pct,

    cart_journeys - purchase_journeys
        AS cart_to_purchase_dropoff,

    ROUND(
        (cart_journeys - purchase_journeys)
        / NULLIF(cart_journeys, 0) * 100,
        2
    ) AS cart_to_purchase_dropoff_pct

FROM verified_counts;






-- =====================================================
-- Step 04.18: Fully Data-Driven Funnel Counts
-- =====================================================
-- Calculates View -> Cart -> Purchase journeys
-- directly from public.ecommerce_events.
-- Uses strict chronological ordering.
-- Verified PostgreSQL results:
-- View: 552,900
-- Cart: 12,725
-- Purchase: 6,300

-- Step 04.18: Fully Data-Driven Funnel Counts
-- Same user, session, and product
-- Strict event ordering: View -> Cart -> Purchase

WITH first_views AS (
    SELECT
        user_id,
        user_session,
        product_id,
        MIN(event_time) AS first_view_time
    FROM public.ecommerce_events
    WHERE event_type = 'view'
      AND user_session IS NOT NULL
    GROUP BY user_id, user_session, product_id
),

first_carts AS (
    SELECT
        v.user_id,
        v.user_session,
        v.product_id,
        MIN(c.event_time) AS first_cart_time
    FROM first_views v
    JOIN public.ecommerce_events c
      ON c.user_id = v.user_id
     AND c.user_session = v.user_session
     AND c.product_id = v.product_id
     AND c.event_type = 'cart'
     AND c.event_time > v.first_view_time
    GROUP BY v.user_id, v.user_session, v.product_id
),

completed_purchases AS (
    SELECT
        c.user_id,
        c.user_session,
        c.product_id
    FROM first_carts c
    WHERE EXISTS (
        SELECT 1
        FROM public.ecommerce_events p
        WHERE p.user_id = c.user_id
          AND p.user_session = c.user_session
          AND p.product_id = c.product_id
          AND p.event_type = 'purchase'
          AND p.event_time > c.first_cart_time
    )
)

SELECT
    (SELECT COUNT(*) FROM first_views)
        AS view_journeys,

    (SELECT COUNT(*) FROM first_carts)
        AS cart_journeys,

    (SELECT COUNT(*) FROM completed_purchases)
        AS purchase_journeys;


-- =====================================================
-- Step 04.20: Fully Data-Driven Funnel KPIs
-- =====================================================
-- Calculates funnel counts, conversion rates,
-- and drop-offs directly from ecommerce_events.
-- No hardcoded funnel counts.
-- Verified against Python baseline and PostgreSQL.



-- Step 04.18: Fully Data-Driven Funnel Counts
-- Same user, session, and product
-- Strict event ordering: View -> Cart -> Purchase

WITH first_views AS (
    SELECT
        user_id,
        user_session,
        product_id,
        MIN(event_time) AS first_view_time
    FROM public.ecommerce_events
    WHERE event_type = 'view'
      AND user_session IS NOT NULL
    GROUP BY user_id, user_session, product_id
),

first_carts AS (
    SELECT
        v.user_id,
        v.user_session,
        v.product_id,
        MIN(c.event_time) AS first_cart_time
    FROM first_views v
    JOIN public.ecommerce_events c
      ON c.user_id = v.user_id
     AND c.user_session = v.user_session
     AND c.product_id = v.product_id
     AND c.event_type = 'cart'
     AND c.event_time > v.first_view_time
    GROUP BY v.user_id, v.user_session, v.product_id
),

completed_purchases AS (
    SELECT
        c.user_id,
        c.user_session,
        c.product_id
    FROM first_carts c
    WHERE EXISTS (
        SELECT 1
        FROM public.ecommerce_events p
        WHERE p.user_id = c.user_id
          AND p.user_session = c.user_session
          AND p.product_id = c.product_id
          AND p.event_type = 'purchase'
          AND p.event_time > c.first_cart_time
    )
)


, funnel_counts AS (
    SELECT
        (SELECT COUNT(*) FROM first_views)::NUMERIC
            AS view_journeys,
        (SELECT COUNT(*) FROM first_carts)::NUMERIC
            AS cart_journeys,
        (SELECT COUNT(*) FROM completed_purchases)::NUMERIC
            AS purchase_journeys
)

SELECT
    view_journeys,
    cart_journeys,
    purchase_journeys,

    ROUND(
        cart_journeys / NULLIF(view_journeys, 0) * 100, 2
    ) AS view_to_cart_conversion_pct,

    ROUND(
        purchase_journeys / NULLIF(cart_journeys, 0) * 100, 2
    ) AS cart_to_purchase_conversion_pct,

    ROUND(
        purchase_journeys / NULLIF(view_journeys, 0) * 100, 2
    ) AS overall_conversion_pct,

    view_journeys - cart_journeys
        AS view_to_cart_dropoff,

    ROUND(
        (view_journeys - cart_journeys)
        / NULLIF(view_journeys, 0) * 100, 2
    ) AS view_to_cart_dropoff_pct,

    cart_journeys - purchase_journeys
        AS cart_to_purchase_dropoff,

    ROUND(
        (cart_journeys - purchase_journeys)
        / NULLIF(cart_journeys, 0) * 100, 2
    ) AS cart_to_purchase_dropoff_pct

FROM funnel_counts;

