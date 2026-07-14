# Build 1.0.016 — Two-Position Cap Validation

Build 1.0.016 changes only the default and XM simulation preset maximum basket depth from three positions to two.

The prospective Build 1.0.015 test confirmed that a three-position cap substantially reduced drawdown, but baskets that actually reached the third position remained the dominant loss source. This build tests the next cap prospectively rather than assuming post-hoc exclusion results.

All signal, ATR exit, transaction-cost, diagnostics and virtual-equity risk logic remains unchanged.

## Acceptance test

Repeat the June 1–29 test with Build 1.0.016 and verify:

1. Startup verification reports `POSITION_CAP` details equal to two.
2. No diagnostic row reports `max_positions` above two.
3. Final cumulative profit, profit factor and maximum equity drawdown reconcile.
4. Compare the result directly with Build 1.0.015 using the same spread, history and cost settings.
