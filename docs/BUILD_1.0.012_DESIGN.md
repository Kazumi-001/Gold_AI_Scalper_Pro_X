# Build 1.0.012 — Equity Curve and Drawdown

Build 1.0.012 extends simulation accounting from realized results to mark-to-market equity.

At every processing interval, the EA calculates:

`equity_profit = cumulative_realized_profit + current_floating_profit`

The highest observed equity profit becomes the peak. Drawdown is the distance between that peak and current equity profit. Maximum drawdown retains the largest observed distance for the run.

`EQUITY` CSV rows contain cumulative profit, floating profit, equity profit, peak equity profit, current drawdown, maximum drawdown, maximum drawdown percentage and recovery factor.

Maximum drawdown percentage uses the current account balance as its denominator. Recovery factor is cumulative realized profit divided by maximum equity drawdown. Metrics reset when the EA initializes and do not reconstruct earlier appended CSV runs.

## Acceptance test

Run GOLD/XAUUSD M1 in Simulation Mode with spread 30. Confirm:

1. Startup verification passes.
2. `EQUITY` rows appear throughout the run.
3. `equity_profit` equals `cumulative + floating` within CSV rounding tolerance.
4. Maximum drawdown never decreases.
5. The final row has floating profit near zero when no basket remains open.
