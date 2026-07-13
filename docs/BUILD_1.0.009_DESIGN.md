# Build 1.0.009 Backtest & Verification

This build adds verification assets without changing the trading strategy.

The runtime self-test validates symbol, timeframe, point size, lot sequence, position cap, signal threshold, risk-limit ordering and execution mode. Repository checks enforce strict mode, matching build numbers, safe default inputs and isolation of order-changing functions.

MT4 remains the authoritative compiler and Strategy Tester. The included simulation preset and acceptance checklist make those results reproducible.
