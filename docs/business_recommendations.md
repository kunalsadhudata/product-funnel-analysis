# Business Recommendations

## Product Funnel and Conversion Drop-off Analysis

### 1. Executive Summary

The Python exploratory data analysis examined 60,939 unique customers and 849,220 event records.

The analysis identified substantial differences in customer activity, product exploration, purchase frequency, and purchase participation.

These findings provide opportunities to investigate customer engagement and develop measurable conversion-improvement experiments.

### 2. Key Findings

**Customer Activity**

- Low Activity customers represent 50.26% of customers.
- Very High Activity customers represent 4.99% of customers but generate 40.84% of events.
- Customer engagement is unevenly distributed.

**Product Exploration**

Across 185,065 customer-session pairs:

- 50.16% explored exactly one unique product.
- 26.60% explored 2–3 products.
- 18.80% explored 4–10 products.
- 4.44% explored 11 or more products.

**Purchase Frequency**

Among 7,099 purchasing customers:

- 4,446 customers belong to the 1 Purchase segment.
- 1,865 customers belong to the 2–3 Purchases segment.
- 640 customers belong to the 4–10 Purchases segment.
- 148 customers belong to the 11+ Purchases segment.

**Customer Activity vs Purchase Participation**

| Activity Segment | Customers | Purchasing Customers | Purchase Participation |
|---|---:|---:|---:|
| Low Activity | 30,626 | 657 | 2.15% |
| Moderate Activity | 15,371 | 1,932 | 12.57% |
| High Activity | 11,902 | 3,032 | 25.47% |
| Very High Activity | 3,040 | 1,478 | 48.62% |

Purchase participation increases across the observed activity segments.

This is a descriptive association, not evidence that increasing activity causes purchases.

### 3. Business Recommendations

**Recommendation 1 — Investigate Low-Activity Customers**

Study why customers with limited activity are less likely to participate in purchases. Examine product discovery, navigation, and engagement barriers.

**Recommendation 2 — Improve Product Discovery**

Investigate whether search, filtering, navigation, and product recommendations can help customers find relevant products more efficiently.

**Recommendation 3 — Study Repeat Purchasing**

Examine customers with multiple purchases to identify potential retention opportunities and purchasing patterns.

**Recommendation 4 — Understand Highly Active Customers**

Investigate the characteristics and behaviors associated with high customer activity and purchase participation.

**Recommendation 5 — Prioritize Controlled Experiments**

Test proposed improvements using controlled experiments and predefined success metrics before claiming conversion improvements.

### 4. Measurement and Validation

Future experiments should distinguish between:

- Customer-level purchase participation.
- Customer-session-product journey-level funnel conversion.
- Product exploration and engagement measures.
- Purchase frequency and retention measures.

The validated journey-level funnel should remain the reference for journey conversion and drop-off analysis.

### 5. Methodology and Limitations

- Findings are based on the analyzed dataset sample.
- Customer activity is measured using event records.
- Purchase participation identifies customers with at least one purchase event.
- Purchase events do not necessarily represent unique orders.
- A customer session can include multiple products.
- Observational associations do not establish causality.
- Customer-level purchase participation must not be interpreted as journey-level conversion.

### 6. Conclusion

The analysis suggests opportunities to investigate low customer activity, product discovery barriers, and repeat purchasing behavior.

The recommended next step is to translate these observations into measurable hypotheses and controlled experiments while maintaining the validated funnel definitions.