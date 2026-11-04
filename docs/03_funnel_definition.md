# Funnel Definition and KPI Methodology

## 1. Business Objective

Analyze observed e-commerce customer journeys to measure progression from product viewing to cart activity and purchase completion, identify major drop-off stages, and support data-driven conversion optimization.

## 2. Primary Funnel Definition

The primary funnel uses a **customer-session-product journey** as the unit of analysis.

Each journey is uniquely identified by:

- `user_id`
- `user_session`
- `product_id`

The funnel has three stages:

1. **View:** At least one recorded product-view event.
2. **Cart:** A cart event for the same customer, session, and product occurring strictly after an observed view.
3. **Purchase:** A purchase event for the same customer, session, and product occurring strictly after a qualifying cart event.

Only the first qualifying progression through the stages is counted for each journey.

Events with identical timestamps do not establish chronological progression.

Journeys with missing session identifiers are excluded from the primary funnel.

## 3. Verified Journey Counts

| Funnel stage | Qualifying journeys |
|---|---:|
| View | 552,900 |
| View → Cart | 12,725 |
| View → Cart → Purchase | 6,300 |

**Dataset:** October 2019 analytical customer sample.

## 4. Conversion Rate Definitions

### View-to-Cart Conversion Rate

Number of journeys reaching the cart stage divided by journeys reaching the view stage.

**Formula:** (12,725 / 552,900) × 100 = 2.30%

### Cart-to-Purchase Conversion Rate

Number of journeys reaching the purchase stage divided by journeys reaching the qualifying cart stage.

**Formula:** (6,300 / 12,725) × 100 = 49.51%

### Overall View-to-Purchase Conversion Rate

Number of journeys completing all three stages divided by journeys reaching the view stage.

**Formula:** (6,300 / 552,900) × 100 = 1.14%

## 5. Drop-Off Definitions

### View-to-Cart Drop-Off

Viewed journeys that do not reach a qualifying cart event.

**Count:** 552,900 − 12,725 = 540,175

**Rate:** 97.70%

### Cart-to-Purchase Drop-Off

Journeys reaching a qualifying cart event but not a qualifying purchase event.

**Count:** 12,725 − 6,300 = 6,425

**Rate:** 50.49%

## 6. Supporting Funnel Definitions

Three alternative customer-level analyses were performed:

| Funnel definition | Customers completing all three stages |
|---|---:|
| Customer-level chronological | 4,004 |
| Same-customer, same-product | 3,772 |
| Same-customer, same-session, same-product | 3,640 |

These results measure distinct customers and must not be directly substituted for journey-level counts.

## 7. Analytical Assumptions

- Funnel events must occur in chronological order.
- Funnel stages must refer to the same customer, session, and product.
- A customer may contribute multiple journeys.
- A journey is counted once per qualifying stage, even if it contains repeated events.
- A purchase without a qualifying earlier cart event does not count as a completed primary funnel.
- Customer journeys are observed only within the October 2019 dataset.
- Conversion measures describe observed behavior rather than causal effects.

## 8. Limitations

- Some customers may view products in one session and purchase them in another.
- The dataset may not capture every relevant event.
- October boundaries may truncate journeys.
- The strict same-session definition can undercount longer purchasing journeys.
- A product view does not necessarily indicate purchase intent.
- Missing session identifiers prevent journey assignment for affected records.
- Timestamp ordering alone cannot establish causation.
- The analytical sample may differ from the full customer population.
- These KPIs are observed sequential journey conversion rates, not necessarily checkout or transaction conversion rates.

## 9. Primary KPI Decision

The project will use the **customer-session-product chronological funnel** for its main conversion and drop-off reporting.

Customer-level and cross-session funnel results will be used as supporting sensitivity analyses.

The same journey definitions and denominators must be reproduced in PostgreSQL and Tableau.

## 10. Initial Analytical Observation

The largest observed drop-off occurs between product viewing and cart activity.

This is an area for further investigation, not evidence that a particular product experience causes abandonment.

Category, brand, price, and temporal segmentation may help identify patterns and generate hypotheses for future experimentation.