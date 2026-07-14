# Build 1.0.014 — Basket Diagnostics

Build 1.0.014 adds one analysis-ready `DIAGNOSTIC` CSV row after every completed simulated basket.

Each row contains a sequential basket ID, direction, entry time/hour, holding duration, maximum position depth, entry ADX, ATR, MarketScore, DangerScore, buy/sell score, confidence, net profit, win/loss outcome and exit reason.

The diagnostic row is emitted after final performance accounting, so `net_profit` includes the configured commission and slippage model. Partial-close profit is included in the completed basket result.

The basket ID resets when the EA is initialized. Appended runs can therefore contain repeated IDs and must be segmented by the startup `VERIFY`/`INIT` records.

## Acceptance test

Run the same continuous test used for Build 1.0.013. Confirm that:

1. The number of `DIAGNOSTIC` rows equals the number of `BASKET_CLOSE` rows.
2. Basket IDs increase from 1 without gaps inside the run.
3. Diagnostic wins and losses match final performance counters.
4. Diagnostic net-profit sum reconciles to final cumulative profit within CSV rounding tolerance.
