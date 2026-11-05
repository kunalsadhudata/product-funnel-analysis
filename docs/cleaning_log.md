
# Data Cleaning and Quality Audit Log

## Phase 2 — Mission 01: Data Quality Audit

### Dataset Information

- Source: October 2019 eCommerce analytical sample
- Original sample rows: 849,220
- Columns: 9
- Sampling method: Deterministic 2% customer-level SHA-256 selection
- Audit notebook: `notebooks/02_data_cleaning.ipynb`

### 1. Missing Values

| Column | Missing Count | Missing % |
|---|---:|---:|
| category_code | 268,555 | 31.62% |
| brand | 121,933 | 14.36% |
| Other 7 columns | 0 | 0.00% |

- Rows with at least one missing value: 315,791
- Complete rows: 533,429
- Primary funnel identifier and event columns have no missing values.

### 2. Duplicate Records

- Exact duplicate rows beyond the first occurrence: 600
- Duplicate percentage: 0.07%
- Hypothetical rows after deduplication: 848,620

Decision: Flag duplicate candidates for further investigation.
No records have been removed.

### 3. Data Types

- Text columns: str
- Identifier columns: int64
- Price column: float64
- Event timestamp column: str

Action required: Convert event_time to a timezone-aware
UTC datetime during the cleaning phase.

### 4. Invalid Values

- Negative prices: 0
- Zero prices: 1,469
- Nonpositive product IDs: 0
- Nonpositive category IDs: 0
- Nonpositive user IDs: 0
- Invalid event types: 0
- Blank session IDs: 0

Decision: Investigate zero-price events before determining
their treatment in revenue analysis.

### 5. Timestamp Validation

- Invalid timestamps: 0
- Events outside October 2019: 0
- Unique event dates: 31
- Earliest event: 2019-10-01 00:00:56 UTC
- Latest event: 2019-10-31 23:57:44 UTC
- Parsed timezone: UTC

### 6. Preliminary Audit Conclusions

1. All 849,220 records remain in the original sample.
2. Missing values occur only in category_code and brand.
3. There are 600 exact duplicate candidates.
4. There are 1,469 zero-price events requiring investigation.
5. All timestamps parsed successfully and fall within October 2019.
6. Timestamp conversion is required for downstream analysis.
7. No cleaning transformations have been applied.

### 7. Next Mission

Mission 02 — Cleaning Rules and Decisions

Pending decisions:
- Missing category and brand values
- Exact duplicate handling
- Zero-price event handling
- Timestamp conversion
- Preservation of primary funnel integrity



---

## Mission 02 — Cleaning Rules and Decisions

### Decision 01 — Missing Category and Brand Values

#### Evidence

- Missing category_code: 268,555 events (31.62%)
- Missing brand: 121,933 events (14.36%)
- Purchase events missing category_code: 3,527 (22.85%)
- Purchase events missing brand: 1,318 (8.54%)

#### Cleaning Rules

1. Preserve all original event records.
2. Replace missing category_code values with "Unknown"
   in the cleaned analytical dataset.
3. Replace missing brand values with "Unknown"
   in the cleaned analytical dataset.
4. Do not modify the original raw CSV.
5. Do not infer missing brands or categories without
   verified supporting information.

#### Business Justification

Removing records with missing descriptive attributes
could distort conversion and revenue analysis.

Using "Unknown" allows incomplete descriptive values
to remain visible in category and brand reporting.

#### Implementation Status

Decision documented — not yet implemented.

#### Validation Required

- Confirm original row count is preserved.
- Confirm no missing category_code or brand values remain
  after applying the reporting labels.
- Confirm original non-missing values remain unchanged.
- Confirm primary funnel KPIs remain consistent with Phase 1.




### Decision 02 — Exact Duplicate Handling

#### Evidence

- Total exact duplicate candidates: 600 (0.07%)
- View duplicate candidates: 35
- Cart duplicate candidates: 564
- Purchase duplicate candidates: 1
- Duplicate count reconciliation: Passed

#### Cleaning Rule

Retain all 600 exact duplicate candidates in the
primary cleaned analytical dataset.

Do not automatically remove identical event records.

#### Business Justification

The source dataset does not contain a unique event ID.

Identical records may represent repeated customer
actions or duplicate tracking events.

Removing records without sufficient evidence could
change event counts and compromise comparability
with the Phase 1 analytical sample.

#### Revenue Consideration

One duplicate purchase candidate was identified
with a recorded price of 185.08.

This represents potential sensitivity in raw
purchase-event revenue calculations, not a
confirmed revenue overstatement.

#### Validation Required

1. Preserve all original event records.
2. Confirm duplicate candidates remain identifiable.
3. Compare primary funnel KPIs before and after
   hypothetical exact deduplication.
4. Evaluate potential revenue sensitivity.
5. Document any differences transparently.

#### Implementation Status

Provisional decision documented.
No duplicate records have been removed.




### Decision 03 — Zero-Price Event Handling

#### Evidence

- Total zero-price events: 1,469
- Zero-price view events: 1,468
- Zero-price cart events: 1
- Zero-price purchase events: 0
- Unique affected products: 852
- Zero-price events missing category_code: 699

#### Cleaning Rule

Retain all 1,469 zero-price events in the
primary cleaned analytical dataset.

Preserve the original price value of 0.

Do not replace zero prices with averages,
estimated values, or fabricated product prices.

#### Business Justification

Zero-price events may reflect missing product
pricing, promotions, or legitimate zero-value
records. The available data does not establish
the underlying reason.

Removing these records could affect the
customer journey and funnel population.

No purchase events have a zero recorded price,
so these events do not directly contribute
zero-priced purchase records to revenue totals.

#### Analytical Considerations

1. Retain zero-price views and carts in funnel analysis.
2. Use observed purchase-event prices for revenue analysis.
3. Flag zero-price records as a data-quality limitation.
4. Avoid interpreting zero prices as confirmed free products.

#### Implementation Status

Decision documented — not yet implemented.

No zero-price records have been removed or modified.

#### Validation Required

- Confirm all 1,469 zero-price records are retained.
- Confirm zero-price purchase count remains 0.
- Confirm original price values remain unchanged.
- Confirm primary funnel metrics remain consistent
  with Phase 1.



### Decision 04 — Timestamp Conversion and Timezone Handling

#### Evidence

- Total events: 849,220
- Invalid timestamps: 0
- Events outside October 2019: 0
- Unique event dates: 31
- Source timestamp timezone: UTC
- Current pandas event_time dtype: str

#### Cleaning Rule

1. Preserve the original raw CSV without modification.
2. Convert event_time to a timezone-aware UTC datetime
   in the cleaned analytical dataset.
3. Use pd.to_datetime() with utc=True and
   errors="raise" during final conversion.
4. Preserve the original timestamp's meaning.
5. Do not shift timestamps to local time.
6. Do not remove events based on timestamp values.

#### PostgreSQL Preparation

Use TIMESTAMPTZ for the event_time column.

Configure the PostgreSQL session timezone to UTC
when validating or querying timestamps.

#### Business Justification

The primary funnel requires chronological ordering
of view, cart, and purchase events within the same
customer-session-product journey.

Correct timestamp handling prevents timezone-related
ordering errors and supports reproducible analysis.

#### Validation Required

- Confirm all timestamps convert successfully.
- Confirm all 849,220 records remain present.
- Confirm earliest and latest timestamps are unchanged.
- Confirm UTC timezone awareness.
- Confirm event ordering remains consistent.
- Reconcile primary funnel KPIs against Phase 1.

#### Implementation Status

Decision documented — not yet implemented.



### Decision 05 — Primary Funnel Integrity Preservation

#### Primary Funnel Definition

Journey key:
user_id + user_session + product_id

Required chronological sequence:
view -> cart -> purchase

All funnel stages must belong to the same
customer, session, and product.

#### Verified Phase 1 Baseline

- View journeys: 552,900
- View-to-cart journeys: 12,725
- Completed purchase journeys: 6,300
- View-to-cart conversion: 2.30%
- Cart-to-purchase conversion: 49.51%
- Overall conversion: 1.14%

#### Cleaning Rules

1. Preserve all customer identifiers.
2. Preserve all session identifiers.
3. Preserve all product identifiers.
4. Preserve original event types.
5. Preserve event timestamps and chronological meaning.
6. Retain exact duplicate candidates in the primary dataset.
7. Retain zero-price events.
8. Replace missing descriptive attributes with "Unknown".
9. Do not modify the original raw CSV.

#### Validation Requirements

After creating the cleaned dataset:

1. Verify the cleaned row count is 849,220.
2. Verify all journey identifiers remain unchanged.
3. Verify all event types remain unchanged.
4. Verify timestamp conversion preserves event times.
5. Recalculate the primary funnel using the
   same Phase 1 journey definition and ordering rules.
6. Compare all funnel counts against Phase 1.
7. Investigate any discrepancies before proceeding.

#### Business Justification

Data cleaning must improve analytical usability
without introducing artificial changes to
customer behavior or conversion metrics.

The cleaned dataset must remain reproducible
and consistent with the documented funnel definition.

#### Implementation Status

Decision documented — not yet implemented.
Funnel reconciliation will occur in Mission 04.




---

## Mission 03 — Cleaned Dataset Creation

**Status: COMPLETED**

### Cleaning Transformations

1. Created an independent working copy of the raw analytical sample.
2. Replaced missing category_code values with "Unknown".
3. Replaced missing brand values with "Unknown".
4. Converted event_time to timezone-aware UTC timestamps.
5. Preserved all original event records.
6. Retained exact duplicate candidates for funnel integrity.
7. Retained zero-price events for analytical transparency.

### Final Dataset

- File: data/clean/october_customer_sample_clean.csv
- Rows: 849,220
- Columns: 9
- Missing category_code: 0
- Missing brand: 0
- Exact duplicate candidates: 600
- Zero-price events: 1,469
- Timestamp timezone: UTC

### CSV Read-Back Verification

- Row count matched: PASSED
- Column structure matched: PASSED
- Missing value validation: PASSED
- Timestamp integrity: PASSED
- Duplicate count reconciliation: PASSED
- Zero-price count reconciliation: PASSED
- Full DataFrame equality: PASSED

### Conclusion

The cleaned dataset has been successfully created,
exported, reloaded, and validated.

The original raw dataset remains unchanged.

Mission 03 is complete.

Next: Mission 04 — Funnel Reconciliation and Final Validation.






## Final Funnel Reconciliation

### Validation Method

The cleaned dataset was validated against the original Phase 1 journey-level funnel.

Journey identifier:
- `user_id`
- `user_session`
- `product_id`

Event sequence:
- View must occur before cart.
- Cart must occur before purchase.
- Events must belong to the same customer-session-product journey.

### Reconciliation Results

| Metric | Phase 1 Baseline | Cleaned Dataset | Difference |
|---|---:|---:|---:|
| View journeys | 552,900 | 552,900 | 0 |
| View → Cart journeys | 12,725 | 12,725 | 0 |
| View → Cart → Purchase journeys | 6,300 | 6,300 | 0 |

### Final Validation Status

**PASS — All journey-level funnel counts match Phase 1 exactly.**

Cleaning preserved the original funnel results.

The cleaned dataset contains 849,220 rows and is saved at:

`data/clean/october_customer_sample_clean.csv`

The cleaned dataset is ready for downstream analysis.
