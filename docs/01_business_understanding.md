# Business Understanding — Product Funnel and Conversion Drop-off Analysis

## 1. Project Background

An e-commerce platform generates customer interaction events as users browse products, add items to their shopping carts, and complete purchases.

However, not every customer completes the purchasing journey. Understanding where customers abandon this process can help businesses identify opportunities to improve the customer experience and conversion performance.

## 2. Business Problem

The business needs better visibility into customer movement through the purchasing funnel.

Without a structured funnel analysis, stakeholders may struggle to determine:

- Where the largest customer drop-offs occur.
- How conversion rates differ across funnel stages.
- Which customer or product segments demonstrate different purchasing behaviors.
- Which areas deserve further investigation or experimentation.

## 3. Primary Business Objective

Analyze customer behavior across the e-commerce purchase journey, quantify conversion and drop-off rates, identify meaningful behavioral patterns, and develop evidence-based recommendations for improving the shopping experience and conversion performance.

## 4. Business Stakeholders

- Product Managers
- Marketing Teams
- UX and Customer Experience Teams
- Revenue and Business Operations Teams
- Business Leadership

## 5. Key Business Questions

1. How many unique customers enter each funnel stage?
2. What percentage of customers progress from one stage to the next?
3. At which stage is the largest absolute and relative drop-off?
4. How do conversion patterns vary across available customer and product dimensions?
5. What purchasing and revenue patterns can be measured reliably?
6. Which findings suggest opportunities for further investigation or controlled experiments?

## 6. Proposed Customer Journey

The initial candidate funnel is:

Product View → Add to Cart → Purchase

This funnel is provisional and must be validated against the selected dataset's actual events, identifiers, timestamps, and available attributes.

## 7. Proposed KPIs

- Unique customers at each funnel stage
- Stage-to-stage conversion rate
- Stage-to-stage drop-off rate
- Overall purchase conversion rate
- Purchase revenue, if supported
- Average order value, if reliable order-level information is available
- Segment-level conversion metrics, where supported

Final KPI definitions will specify the counting unit, event sequence, attribution window, and denominator.

## 8. Analytical Principles

- Use only verified dataset fields and event types.
- Distinguish event counts from unique-customer counts.
- Validate event ordering and customer identifiers.
- Avoid interpreting observed drop-offs as proven causes.
- Do not invent business findings or revenue improvements.
- Document data quality issues and methodological limitations.
- Provide reproducible SQL and Python analysis.

## 9. Expected Deliverables

- Validated dataset and data dictionary
- Documented funnel and KPI definitions
- PostgreSQL analytical queries
- Python exploratory and statistical analysis
- Tableau dashboards
- Evidence-based business recommendations
- Reproducible GitHub portfolio repository

## 10. Current Status

Phase 0: Completed and verified.

Phase 1, Mission 01: Business problem understanding and initial documentation in progress.

Dataset selection, final funnel definitions, and KPI feasibility remain pending validation.
