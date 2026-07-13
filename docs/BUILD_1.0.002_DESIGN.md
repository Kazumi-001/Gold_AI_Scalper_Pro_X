# Build 1.0.002 Design

## Responsibility

Build 1.0.002 establishes stable interfaces for later Version 1.0 modules. It observes the market and records diagnostics but never sends, modifies, or closes an order.

## Runtime flow

1. `OnInit` validates the symbol, M1 timeframe, and inputs.
2. Logger initializes a build-specific CSV file.
3. `OnTick` captures one market snapshot per configured interval.
4. The market module calculates ATR, spread, MarketScore and DangerScore.
5. The EA writes the snapshot and updates its chart status.

## Scores

- `MarketScore` (0-100): rewards tradable volatility and low relative spread.
- `DangerScore` (0-100): increases with excessive spread, abnormal volatility, or missing data.

These are deterministic framework scores. Adaptive weighting is added in later builds without changing the public score range.

## Safety boundary

`InpSimulationMode` defaults to `true`. Build 1.0.002 contains no `OrderSend`, `OrderModify`, or `OrderClose` call, so disabling the option cannot place a trade in this build.
