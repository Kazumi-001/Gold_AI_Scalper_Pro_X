# Changelog

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
