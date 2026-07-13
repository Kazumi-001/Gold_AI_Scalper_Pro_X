# Build 1.0.010 Test Analysis

Source: `GASPX_1_0_009_GOLD#_20260701.xlsx`, covering 2026-07-01 through 2026-07-13. The file contains two appended Strategy Tester runs.

## Observed

- 139,964 market snapshots
- 23,641 completed-bar signal evaluations
- 23,633 `SPREAD_BLOCK` results
- 139,922 snapshots classified `DANGEROUS`
- Six initial virtual entries across two runs (three unique baskets per run)
- Each basket recorded a 50% partial close followed by ATR take-profit
- Startup verification passed and no runtime errors were reported

The tester spread was exactly 30 points, equal to `InpMaxSpreadPoints`. Quote-derived floating-point spread occasionally evaluated slightly above 30 before being displayed as 30.0. Build 1.0.010 uses the broker's integer `MODE_SPREAD` value and a small comparison tolerance, restoring the intended inclusive boundary.

## Retest acceptance

- `SPREAD_BLOCK` must not occur when tester spread equals 30.
- Most normal-volatility snapshots should no longer be classified dangerous solely due to spread.
- Signal and virtual-trade counts should increase while the six-position and risk limits remain enforced.
