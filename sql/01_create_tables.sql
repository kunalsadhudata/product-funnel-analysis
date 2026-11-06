
-- Phase 02: PostgreSQL Table Schema
-- Source: October 2019 cleaned customer sample

CREATE TABLE IF NOT EXISTS public.ecommerce_events (
    event_time TIMESTAMPTZ,
    event_type TEXT,
    product_id BIGINT,
    category_id BIGINT,
    category_code TEXT,
    brand TEXT,
    price NUMERIC(12,2),
    user_id BIGINT,
    user_session TEXT
);
