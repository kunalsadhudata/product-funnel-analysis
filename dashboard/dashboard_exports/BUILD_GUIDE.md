# Tableau build guide: Product Funnel and Conversion Drop-off (Phase 08)

Everything here uses only verified results from the Dashboard Handoff Pack. Missing items stay marked MISSING. Tableau Public Desktop, about 40 minutes.

## 0. Rules baked into the design
- Three different grains, never joined: JOURNEY (customer + session + product), CUSTOMER, PURCHASE EVENT (not unique orders).
- Currency is UNVERIFIED. Purchase-event value is a revenue proxy.
- Scenarios are HYPOTHETICAL: amber only. Historical results: blue/navy only.
- Missing, do not fill: device, traffic source, new vs returning, median stage times, stage-level revenue, Phase 06 statistics (p-values, CI, MDE), date range, source URL.

## 1. Load data
Data > New Data Source > Text file, once per CSV (6 data sources). Do NOT join or relate them. Keep your existing raw-event source untouched; it is not used for the final sheets.
Check: core_funnel journeys = 552,900 / 12,725 / 6,300. activity_segments customers sum to 60,939, purchasing_customers to 7,099.

## 2. Theme
Navy #0B1F3A (header band, titles) | Blue #1D4ED8 (main bars) | Sky #93C5FD (secondary) | Orange #F97316 (drop-off) | Amber #D97706 on #FEF3C7 (HYPOTHETICAL only) | Slate #64748B (labels) | Page background #F1F5F9 | Cards white, border #E2E8F0.
Font: Segoe UI. Page title 22 bold, card title 14 bold, KPI number 30 bold navy, labels 10 slate.
Every sheet: Format > Borders none, Lines > Grid/Zero lines none, Shading white, Fit Entire View, hide field labels you do not need.

## 3. Calculated fields
### In core_funnel
Conversion Transition (string):
  IF [stage_order]=2 THEN "View → Cart" ELSEIF [stage_order]=3 THEN "Cart → Purchase" END
Drop-off Transition (string):
  IF [stage_order]=1 THEN "View → Cart" ELSEIF [stage_order]=2 THEN "Cart → Purchase" END
Step Conversion:  [step_conversion_pct]/100        (format 0.00%)
Overall Completion: [overall_conversion_pct]/100   (format 0.00%)
Drop-off Rate: [drop_off_pct]/100                   (format 0.00%)
Median Time Label:
  IF ISNULL(ATTR([median_time_to_next_stage])) THEN "Missing" ELSE STR(ATTR([median_time_to_next_stage])) END
Parameter: Improvement in percentage points (Float, range 0 to 10, step 0.5, current 1.0). Show Parameter control, slider.
Current Rate:    SUM([step_conversion_pct])/100
Projected Rate:  MIN(1, SUM([step_conversion_pct])/100 + [Improvement in percentage points]/100)
Percentage-point Gain: ([Projected Rate] - [Current Rate])*100   (format 0.00" pp")
Relative Gain:   [Projected Rate]/[Current Rate] - 1            (format +0.0%)
Extra revenue is NOT calculated: no validated attribution model. Show a text box: "Extra revenue: Missing, attribution not validated."
### In activity_segments
Participation:  [purchase_participation_pct]/100  (0.00%)
Value Share:    [value_share_pct]/100             (0.00%)
### In financial_scenarios
Relative Gain Label: "+" + STR([relative_gain_pct]) + "% participation"
Projected Participation: [projected_participation_pct]/100 (0.00%)
### In kpi_baseline
No calculations. One sheet per KPI card: filter [kpi], Text = SUM([value]).

## 4. Sheets (name them exactly)
KPI cards (source kpi_baseline; filter kpi = name; Text mark; format below; title is a small text box):
 K1 Unique customers (#,##0) | K2 Purchasing customers (#,##0) | K3 Customer purchase participation pct (0.00"%")
 K4 View journeys (#,##0) | K5 View to Cart pct | K6 Cart to Purchase pct | K7 View to Purchase pct (all 0.00"%")
 K8 Purchase events (#,##0) | K9 Recorded purchase-event value (#,##0.00) | K10 Average purchase-event value (#,##0.00)
 K11 Average value per purchasing customer | K12 Median value per purchasing customer | K13 Top 10 pct share (0.00"%")
 K14 Smartphone share (0.00"%")
S1 Funnel (core_funnel): Rows [stage] sorted by [stage_order] ascending; Columns SUM([journeys]); label SUM(journeys); color Blue. Bars are proportional on purpose; do not stretch them.
S2 Step conversion: Rows [Conversion Transition]; Columns SUM([Step Conversion]); filter stage_order is 2 and 3; label; Blue.
S3 Drop-off counts: Rows [Drop-off Transition]; Columns SUM([drop_off_count]); filter stage_order is 1 and 2; Orange; sort descending.
S4 Drop-off table: Rows [Drop-off Transition]; Text: SUM(drop_off_count), SUM([Drop-off Rate]), [Median Time Label]; filter stage_order is 1 and 2.
S5 Scenario table: Rows [Conversion Transition]; Measure Names/Values: Current Rate, Projected Rate, Percentage-point Gain, Relative Gain; filter stage_order is 2 and 3.
S6 Participation by segment (activity_segments): Rows [activity_segment] sorted by [segment_order]; Columns [Participation]; Blue.
S7 Value by segment: same rows; Columns SUM([purchase_event_value]); Navy; label #,##0.
S8 Customers vs purchasing (optional): Rows segment; Columns SUM(customers) and SUM(purchasing_customers) dual bars (Sky, Blue).
S9 Activity table: segment, customers, purchasing_customers, Participation, purchase_event_value, Value Share.
S10 Purchase frequency (purchase_frequency_segments): Rows [purchase_frequency_segment] by [segment_order]; Columns SUM([customers]); Blue.
S11 Participation scenarios (financial_scenarios): Columns [Relative Gain Label]; Rows SUM([incremental_purchase_event_value]); color Amber; label; add additional_purchasers and Projected Participation to the tooltip.
S12 Sensitivity (sensitivity_scenarios): Columns [scenario] sorted manually Low, Medium, High; Rows SUM([incremental_purchase_event_value]); Amber.

## 5. Dashboards (Dashboard > Size: Fixed 1366 x 800 for each)
Common frame: horizontal container: top header band (Text, navy background, white 22 pt title, page subtitle in sky) height 70; Navigation buttons row (Dashboard > Objects > Navigation, one per page, navy text, active page blue); body; footer text (slate 9 pt): "Journeys = customer + session + product. Customers, journeys and events are different units. Purchase events are not unique orders. Currency unverified. Historical sample: Oct 2019."
Put every sheet in a white vertical container, outer padding 8, inner padding 10, border #E2E8F0.

1 Executive Overview: Row A: K1 K2 K3 | K4 K5 K6 K7 (add small group headers "Customer level" and "Journey level"). Row B: K8 K9. Row C: S1 (left, 60%) and a Text box with the 5 findings (right).
2 Conversion Funnel: S1 large (left 60%), S2 (right top), overall completion text "Overall completion 1.14%: 6,300 of 552,900 view journeys", footnote "6,300 journeys is not 7,099 purchasing customers."
3 Drop-off Analysis: S3 (left), S4 (right). Below, amber-bordered container with banner "HYPOTHETICAL SCENARIO" containing the parameter slider, S5, and the text "Extra revenue: Missing, attribution not validated." Under it: A/B test text from the pack (randomize by customer, primary metric strict View to Cart journey conversion, baseline 2.30%, MDE and duration MISSING).
4 Customer Segmentation: Activity filter (single value list, buttons style) on top; S6 and S7 side by side; S9 below; S10 at the bottom with note "Counts recorded purchase events, not unique orders. Not affected by the activity filter (separate dataset)." Do NOT show new vs returning, device or traffic source.
5 Revenue and Business Insights: left column HISTORICAL (blue border): K9, K10, K11, K12, K13, K14. Middle column HYPOTHETICAL (amber border, banner): S11 and S12 plus note "Modeled, not observed. No costs, margins, seasonality or causal effects. Not forecasts, profit or ROI." Right column: recommendations text.
Recommendations (proposed priorities, impact magnitudes MISSING):
 P1 Improve product discovery and add-to-cart (View to Cart 2.30%) | P1 Investigate checkout abandonment (Cart to Purchase 49.51%) | P1 Investigate low-activity friction (30,626 customers, 2.15% participation)
 P2 Improve repeat purchase (4,446 customers with one recorded purchase event) | P2 Study high-value customers (top 10% hold 60.20% of value) | P2 Improve category discovery (Smartphone 70.03% of value)
Limitations text (small): sampled data, unverified currency, events are not orders, observational segments, no statistical significance claimed (Phase 06 outputs not recovered), hypothetical scenarios.

## 6. Interactivity
- Activity filter: right-click activity_segment pill on S6 > Show Filter; on the dashboard use "Apply to worksheets > Selected" for S6, S7, S8, S9 only.
- Dashboard > Actions > Add Action > Highlight: S6 to S7 (Select, segment field).
- "Use as Filter" on S6 so bar clicks filter S7 and S9.
- Parameter slider on page 3 drives S5 only.
- Tooltips (Sheet > Tooltip), examples:
  S1: <stage>: <SUM(journeys)> journeys (customer + session + product)
  S3: <Drop-off Transition>: <SUM(drop_off_count)> journeys did not progress (<Drop-off Rate>)
  S6: <activity_segment>: <Participation> of customers purchased. Association, not causation.
  S11: Hypothetical: +<relative_gain_pct>% participation = <additional_purchasers> modeled extra purchasers, <SUM(incremental...)> value (currency unverified).
- Device: set Dashboard > Device Preview to Desktop only.

## 7. Verification before publishing
Funnel 552,900 / 12,725 / 6,300 and 2.30% / 49.51% / 1.14%. Customers 60,939; purchasers 7,099; value 4,979,242.62. Activity value shares sum to about 100% (99.99 due to rounding). Scenario 10% row: 12.81%, 710 purchasers, 497,924.26. Save locally first (update to Tableau Public 2026.3.0), then publish.
