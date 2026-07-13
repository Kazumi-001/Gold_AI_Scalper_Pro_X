# Changelog

## [1.0.004] - 2026-07-14

### Added

- Initial market-order execution from qualified Signal Engine output.
- Grid + ATR hybrid adverse-distance scaling.
- Six-level lot progression: 0.01, 0.02, 0.03, 0.05, 0.08, 0.13.
- Six-position cap, cooldown, symbol/magic filtering and duplicate-direction guard.
- XM lot-step normalization and execution error logging.
- Virtual trade state and CSV events in Simulation Mode.

### Safety

- Live execution requires both `InpSimulationMode=false` and `InpEnableLiveTrading=true`.
- SL/TP and portfolio risk management remain assigned to Build 1.0.005.

## [1.0.003] - 2026-07-14

### Added

- EMA20/50/200 trend alignment filter.
- ADX strength and directional filter.
- ATR, spread, trading-session and candle-volatility filters.
- EMA20 retest and directional candle scoring.
- Buy/Sell score, confidence and 80-point signal threshold.
- MarketScore/DangerScore safety gate.
- Closed-M1-bar signal evaluation and CSV simulation logging.

### Safety

- Signal Engine is observation-only; no order functions are enabled.

## [1.0.002] - 2026-07-13

### Added

- Compile-ready MT4 EA framework.
- Centralized Build 1.0 configuration.
- Shared market-state and score types.
- CSV event and market snapshot logger.
- ATR, spread, MarketScore and DangerScore calculation.
- XAUUSD/GOLD and M1 startup guards.
- Simulation Mode as the safe default.

### Not yet enabled

- Signal generation.
- Order placement and grid expansion.
- Position and risk management.
- Full dashboard controls.
