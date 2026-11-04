# Analytical Assumptions and Limitations

## 1. Project Scope

This project analyzes e-commerce product interaction events from October 1–31, 2019 (UTC).

The objective is to measure observed customer progression through product viewing, cart activity, and purchasing, and identify opportunities for further conversion analysis.

The analysis is observational and does not establish causal relationships.

## 2. Dataset Assumptions

- The original October dataset contains 42,448,764 event records.
- The analytical sample contains 849,220 records from 60,939 selected customers.
- Customer-level deterministic SHA-256 sampling was used.
- All observed October events belonging to selected customers were retained according to customer-level event-count reconciliation.
- The sample represents approximately 2% of original event records, not necessarily exactly 2% of customers.
- Timestamps are interpreted in UTC.
- October is the complete observation window for this analysis.

## 3. Funnel Assumptions

The primary unit of analysis is a customer-session-product journey, uniquely identified by:

- `user_id`
- `user_session`
- `product_id`

The funnel requires:

1. At least one observed `view` event.
2. A `cart` event strictly after an observed view.
3. A `purchase` event strictly after a qualifying cart.

All events must belong to the same customer, session, and product.

Events with identical timestamps do not establish strict chronological progression.

Each journey contributes at most once to each funnel stage, even if multiple qualifying events occur.

A customer may contribute multiple journeys.

## 4. Observed Funnel Results

| Stage | Qualifying journeys |
|---|---:|
| View | 552,900 |
| View → Cart | 12,725 |
| View → Cart → Purchase | 6,300 |

| KPI | Observed result |
|---|---:|
| View-to-cart conversion | 2.30% |
| Cart-to-purchase conversion | 49.51% |
| Overall funnel completion | 1.14% |
| View-to-cart drop-off | 97.70% |
| Cart-to-purchase drop-off | 50.49% |

These are observed journey-level rates, not unique-customer conversion rates.

## 5. Missing-Data Assumptions

- Missing `category_code` and `brand` values will be retained and handled explicitly during segmentation.
- Missing session identifiers prevent reliable assignment to the primary session-based funnel.
- Missing categorical information does not automatically justify removing an event.
- Data-cleaning decisions will be documented before implementing transformations.

## 6. Revenue Assumptions

- `price` represents the price recorded for an event.
- View and cart events are not treated as realized revenue.
- Purchase-event prices may support a purchase-value proxy, subject to further validation.
- The dataset does not independently establish payment settlement, refunds, discounts, taxes, or complete order quantities.
- No actual revenue uplift will be claimed without supporting evidence.
- Revenue modeling assumptions will be documented separately during the appropriate project phase.

## 7. Observation-Window Limitations

- Customers may have interacted with products before October 1 or after October 31.
- A purchase may appear without an observed preceding cart event.
- A session may span the boundary of the observation period.
- The same-session funnel can exclude valid longer customer journeys that cross sessions.
- Customers who have not purchased by October 31 may purchase later.
- A missing qualifying purchase event should be interpreted as no observed completion within the available data, not necessarily permanent abandonment.

## 8. Sampling Limitations

- The sample was selected at the customer level to preserve observed event histories.
- Sampling variation may affect category, brand, price, and conversion estimates.
- Small customer segments may have insufficient observations for reliable conclusions.
- Sample results should not automatically be treated as exact full-population metrics.
- Event-count reconciliation does not independently prove row-level identity.

## 9. Interpretation and Causality

- Product views do not necessarily indicate purchase intent.
- Funnel drop-offs are descriptive observations, not confirmed causes of abandonment.
- Customer behavior may be affected by factors not present in the dataset.
- Differences across products, brands, categories, or time periods do not independently establish causal effects.
- Business recommendations will distinguish observed evidence from hypotheses.
- Experiments would be required to estimate the causal effect of proposed changes.

## 10. Reproducibility and Validation

The project uses Python, pandas, PostgreSQL, SQL, Tableau, and Git.

Dataset exploration and funnel validation are recorded in:

`notebooks/01_data_exploration.ipynb`

Related documentation includes:

- `docs/01_business_understanding.md`
- `docs/02_dataset_selection.md`
- `docs/03_funnel_definition.md`
- `docs/data_dictionary.md`

The same funnel keys, stage-ordering rules, and KPI denominators should be reproduced consistently in PostgreSQL and Tableau.

## 11. Future Validation

The following activities remain for subsequent phases:

- Data cleaning and transformation validation.
- PostgreSQL schema and loading validation.
- SQL-to-Python funnel reconciliation.
- Category, brand, and price segmentation.
- Revenue proxy validation.
- Dashboard KPI reconciliation.
- Business recommendation and experiment design.