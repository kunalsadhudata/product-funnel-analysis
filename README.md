
# Product Funnel & Conversion Drop-off Analysis

An end-to-end e-commerce data analytics portfolio project using PostgreSQL, Python, statistical analysis, and Tableau Public to investigate customer journeys, conversion drop-offs, customer behavior, and potential business impact.

## Business Problem

E-commerce businesses need to understand how customers progress from viewing products to adding them to carts and completing purchases.

This project investigates where customers drop off in the product funnel, how purchasing behavior differs across customer segments, and which areas may offer opportunities for conversion improvement.

## Technology Stack

- **Database:** PostgreSQL 18, pgAdmin 4
- **Analysis:** Python 3.13, pandas, Jupyter Notebook
- **SQL:** Funnel analysis, validation, segmentation, and revenue analysis
- **Statistics:** Statistical analysis and experiment design
- **Visualization:** Tableau Public using prepared CSV exports
- **Version Control:** Git and GitHub

**Data architecture:** PostgreSQL supports SQL-based analysis, while Tableau visualizations use prepared CSV exports. The dashboards are not live-connected to PostgreSQL.
  


  
## Key Performance Indicators

| Metric | Observed Result |
|---|---:|
| Unique customers | 60,939 |
| Purchasing customers | 7,099 |
| Customer purchase participation | 11.65% |
| View journeys | 552,900 |
| View-to-cart conversion | 2.30% |
| Cart-to-purchase conversion | 49.51% |
| View-to-purchase conversion | 1.14% |
| Purchase events in analyzed scope | 15,435 |
| Recorded purchase-event value | 4,979,242.62 |
| Average purchase-event value | 322.59 |
| Top 10% of purchasing customers' share of recorded value | 60.20% |

These results describe the analyzed dataset scope and should not be interpreted as population-wide estimates. Recorded purchase-event value is a historical event-level measure, not necessarily net revenue.

## Funnel Methodology

The primary funnel follows chronological customer-session-product journeys:

1. Product View
2. Add to Cart
3. Purchase

A qualifying cart event must occur after a product view within the same customer-session-product journey. A qualifying purchase must occur after the cart event.

| Funnel Stage | Qualifying Journeys |
|---|---:|
| View | 552,900 |
| View → Cart | 12,725 |
| View → Cart → Purchase | 6,300 |

**View-to-cart conversion:** 12,725 / 552,900 = 2.30%.

**Cart-to-purchase conversion:** 6,300 / 12,725 = 49.51%.

**View-to-purchase conversion:** 6,300 / 552,900 = 1.14%.

### Key Finding

The largest observed funnel drop-off occurs between product viewing and cart activity: 540,175 view journeys (97.70%) do not progress to a qualifying cart event.

This finding identifies an area for further investigation, not proof of a specific cause. Customer-level and cross-session analyses provide supporting perspectives. See [Funnel Definitions](docs/03_funnel_definition.md) for methodology and limitations.
  


  
## Interactive Tableau Dashboards

Explore the published Tableau workbook and its interactive visualizations:

- **Tableau Public Portfolio:** [View Tableau Profile](https://public.tableau.com/app/profile/kunalsadhu.data/vizzes)
- **Financial Impact & Scenario Analysis:** [Open Dashboard](https://public.tableau.com/app/profile/kunalsadhu.data/viz/product_funnel_dashboard/FinancialImpactScenarioAnalysis)

The Tableau workbook contains three dashboards:

1. **Executive Overview** — Funnel KPIs, conversion rates, and drop-off analysis.
2. **Customer Behavior & Segmentation** — Customer purchasing behavior and segmentation.
3. **Financial Impact & Scenario Analysis** — Historical recorded purchase-event value and modeled improvement scenarios.

**Note:** Tableau uses prepared CSV exports from the analysis workflow rather than a live PostgreSQL connection. Modeled incremental purchase-event value represents hypothetical scenarios, not guaranteed future revenue.
  



  
## Project Structure

```text
product-funnel-analysis/
├── data/                         # Dataset profile; raw and cleaned data excluded
├── docs/                         # Business definitions, assumptions, and recommendations
├── notebooks/                    # Python exploration, cleaning, EDA, statistics, revenue modeling
├── sql/                          # PostgreSQL schema, validation, funnel and revenue analysis
├── dashboard/
│   ├── dashboard_exports/        # Prepared CSV files for Tableau
│   └── product_funnel_dashboard.twbx
├── .env.example                  # Environment variable template
├── .gitignore                    # Excludes local and sensitive files
├── requirements.txt              # Python dependencies
├── test_connection.py            # PostgreSQL connection test
└── README.md
```

## Reproducibility

This repository contains the SQL scripts, Python notebooks, documentation, and prepared Tableau dashboard exports used in the project.

### Environment Setup

1. Install Python 3.13 and PostgreSQL 18.
2. Clone the repository and open it in VS Code.
3. Create a Python virtual environment: `python -m venv .venv`.
4. Activate it in PowerShell: `.\.venv\Scripts\Activate.ps1`.
5. Install dependencies: `python -m pip install -r requirements.txt`.
6. Use `.env.example` as a reference to configure your local `.env` file with your own PostgreSQL connection details. Never commit credentials.
7. Review the SQL scripts and notebooks alongside the documentation before running the analysis.

**Data availability:** The full raw and cleaned datasets are intentionally excluded from Git. Reproducing the complete pipeline requires obtaining the appropriate source data and following the documented preparation steps. Prepared Tableau CSV exports are included for reviewing the published visualizations.

## Limitations

- Findings describe the analyzed dataset and its defined customer journeys.
- Observational funnel patterns do not establish causation.
- Purchase-event value is not necessarily equivalent to net business revenue.
- Financial improvement scenarios are modeled estimates, not guaranteed outcomes.
- Tableau uses prepared CSV exports, not a live PostgreSQL connection.

## Business Recommendations

Prioritize investigation of the View → Cart drop-off, examine differences across customer segments, and validate proposed product experience improvements through controlled experiments before making causal claims.

See [Business Recommendations](docs/business_recommendations.md), [Experiment Design](docs/experiment_design.md), and [Assumptions](docs/assumptions.md) for additional details.
  