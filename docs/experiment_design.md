
# A/B Experiment Design

## Project
Product Funnel and Conversion Drop-off Analysis

## Phase 06 — Statistical Analysis & Experiment Design

### 1. Experiment Overview

- Experiment ID: EXP_H1_001
- Experiment name: Simplified Add-to-Cart Experience
- Linked hypothesis: H1
- Status: Proposed — Not Conducted

**Objective:** Evaluate whether simplifying the add-to-cart experience increases customer purchase conversion.

### 2. Business Hypothesis

Customers using a simplified add-to-cart interface may achieve higher purchase conversion than customers using the existing interface.

- H0: Treatment and control purchase conversion rates are equal.
- H1: Treatment and control purchase conversion rates differ.

This experiment is designed to test causality through randomized assignment. Historical observational analysis does not establish causation.

### 3. Experimental Groups

**Control group:** Existing add-to-cart interface.

**Treatment group:** Simplified add-to-cart interface.

- Randomization unit: Unique customer
- Allocation: 50% control / 50% treatment
- Eligible population: Customers eligible for the add-to-cart interface, defined before randomization

Customer assignment must remain consistent throughout the experiment.

### 4. Primary and Guardrail Metrics

**Primary metric: Purchase conversion rate**

Number of randomized eligible customers with at least one purchase within a predefined attribution window divided by the number of randomized eligible customers.

**Secondary metric:**
- Add-to-cart rate

**Guardrail metrics:**
- Cart-to-purchase conversion
- Revenue per eligible customer
- Technical error rate

Guardrail thresholds must be approved before experiment launch.

### 5. Statistical Design

- Significance level: 0.05
- Target statistical power: 80%
- Hypothesis test: Two-sided
- Allocation ratio: 50/50
- Confidence level: 95%

Statistical significance alone is insufficient for a rollout decision.

### 6. Baseline and Minimum Detectable Effect

Historical customer purchase participation:

- Total customers: 60,939
- Purchasing customers: 7,099
- Observed participation rate: 11.65%
- 95% Wilson confidence interval: 11.40%–11.91%

**Illustrative planning assumptions:**

- Baseline conversion: 11.65%
- Relative MDE: 10%
- Target treatment conversion: Approximately 12.81%
- Absolute MDE: Approximately 1.16 percentage points

The historical participation rate is a proxy, not a verified experiment-eligible baseline.

### 7. Sample Size Planning

Calculated illustrative sample size:

- Control customers: 12,412
- Treatment customers: 12,412
- Total customers: 24,824

Sample size depends on the assumed baseline, MDE, power, significance level, and allocation.

These assumptions require validation before implementation.

### 8. Runtime and Feasibility

| Daily eligible customers | Estimated recruitment days |
|---|---:|
| 100 | 249 |
| 250 | 100 |
| 500 | 50 |
| 1,000 | 25 |
| 2,000 | 13 |

Additional planning requirements:

| Recruitment window | Minimum daily eligible customers |
|---|---:|
| 14 days | 1,774 |
| 28 days | 887 |
| 56 days | 444 |

All traffic scenarios are hypothetical. Recruitment estimates exclude outcome follow-up and analysis time.

### 9. Experiment Decision Framework

Evaluate the following before any rollout:

1. Data quality and event tracking
2. Required sample size attainment
3. Statistical significance
4. Practical significance and business impact
5. Guardrail metric performance
6. Randomization and experiment integrity

A statistically significant result does not automatically justify deployment.

### 10. Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Sample ratio mismatch | Monitor allocation counts and investigate mismatches |
| Tracking failures | Validate conversion event instrumentation |
| Premature stopping | Establish stopping rules before launch |
| Customer contamination | Maintain persistent customer-level assignment |
| Seasonality | Run variants concurrently across representative periods |
| Guardrail deterioration | Monitor guardrails against approved thresholds |

### 11. Implementation Requirements

Before launching a real experiment:

- Confirm the eligible customer population.
- Validate baseline conversion using eligible customers.
- Finalize purchase attribution windows.
- Validate randomization and assignment tracking.
- Define guardrail thresholds.
- Approve the MDE and sample size.
- Confirm available traffic and runtime.
- Establish monitoring and stopping procedures.

### 12. Limitations

This is an experiment design based on historical observational analysis.

No randomized experiment has been conducted.

No treatment effect, causal lift, or experiment outcome has been measured.

All sample size and runtime estimates are illustrative and require operational validation.

### 13. Conclusion

The simplified add-to-cart experience is a proposed intervention intended to address purchase conversion opportunities.

The experiment design provides a framework for future randomized testing, statistical evaluation, and evidence-based rollout decisions.

**Experiment status: Proposed — Not Conducted**
