# Data Dictionary — E-commerce Funnel Analysis

## 1. Dataset Overview

**Dataset:** eCommerce Behavior Data from Multi-Category Store

**Source:** Kaggle — mkechinov/ecommerce-behavior-data-from-multi-category-store

**Period:** October 1–31, 2019 (UTC)

**Original records:** 42,448,764

**Analytical sample:** 849,220 records

**Unique sampled customers:** 60,939

**Unique sampled sessions:** 185,065

## 2. Source Data Fields

| Column | Description | Analytical use |
|---|---|---|
| `event_time` | Timestamp when an event occurred, interpreted as UTC | Event ordering, daily trends, funnel chronology |
| `event_type` | Recorded customer action: `view`, `cart`, or `purchase` | Funnel stage identification |
| `product_id` | Identifier for the product involved in the event | Product-level funnel grouping |
| `category_id` | Identifier for the product category | Category segmentation |
| `category_code` | Hierarchical category description, when available | Category reporting and segmentation |
| `brand` | Product brand, when available | Brand-level analysis |
| `price` | Recorded price associated with the event | Price segmentation and potential purchase-value analysis |
| `user_id` | Identifier for the customer | Customer-level analysis and sampling |
| `user_session` | Identifier for the recorded session | Session-level funnel grouping |

## 3. Missing-Value Profile

The following results are based on the full October dataset.

| Column | Missing records | Missing percentage |
|---|---:|---:|
| `category_code` | 13,515,609 | 31.84% |
| `brand` | 6,117,080 | 14.41% |
| `user_session` | 2 | Less than 0.01% |
| All remaining columns | 0 | 0% |

Missing `category_code` and `brand` values will require careful handling during segmentation.

Rows with missing session identifiers cannot be assigned to the primary customer-session-product funnel.

## 4. Primary Funnel Keys

A journey is identified using:

- `user_id`
- `user_session`
- `product_id`

A journey can contain multiple event records.

The primary funnel requires chronological `view → cart → purchase` events for the same customer, session, and product.

## 5. Derived Analytical Fields

These fields are planned for the cleaned or analytical dataset. They are not original source columns.

| Derived field | Definition |
|---|---|
| `event_date` | UTC calendar date extracted from `event_time` |
| `event_hour` | UTC hour extracted from `event_time` |
| `journey_id` | Derived identifier representing the customer-session-product combination |
| `first_view_time` | Earliest observed view timestamp for a journey |
| `first_valid_cart_time` | Earliest cart timestamp strictly after the first view |
| `first_valid_purchase_time` | Earliest purchase timestamp strictly after a qualifying cart |
| `reached_view` | Indicator that a journey has an observed view |
| `reached_cart` | Indicator that a journey has a qualifying view-to-cart progression |
| `reached_purchase` | Indicator that a journey completes all three funnel stages |

## 6. Data Type Considerations

The original CSV does not enforce database data types.

For PostgreSQL, the intended types are:

| Field | Intended PostgreSQL type |
|---|---|
| `event_time` | `TIMESTAMPTZ` |
| `event_type` | `TEXT` |
| `product_id` | `BIGINT` |
| `category_id` | `BIGINT` |
| `category_code` | `TEXT` |
| `brand` | `TEXT` |
| `price` | `NUMERIC` |
| `user_id` | `BIGINT` |
| `user_session` | `TEXT` |

These are proposed schema types and will be validated during PostgreSQL data preparation.

## 7. Important Analytical Rules

- A recorded event is not equivalent to a unique customer.
- A customer can generate multiple events, sessions, and product journeys.
- A product journey is counted once at each qualifying funnel stage.
- Events must occur in chronological order to establish funnel progression.
- Events with equal timestamps do not establish strict chronological progression.
- Missing category or brand information does not automatically make a record unusable.
- Recorded prices must not be interpreted as total business revenue without additional assumptions.
- All analysis dates and timestamps will be handled consistently in UTC.

## 8. Validation Status

The October dataset has undergone full-file profiling, customer-level sampling, daily coverage checks, sampling-rule validation, and customer-level event-count reconciliation.

The primary funnel has also been tested at customer, customer-product, and customer-session-product levels.

Cleaning rules, database constraints, and derived-field implementation will be completed in subsequent phases.