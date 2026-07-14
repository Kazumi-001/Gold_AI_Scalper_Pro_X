# Gold AI Scalper Pro X

Gold AI Scalper Pro X is a modular Expert Advisor framework for MetaTrader 4.

## Build 1.0.019 (Adaptive Entry Score)

- Platform: MetaTrader 4 Build 1400+
- Target: XM XAUUSD/GOLD symbols
- Timeframe: M1
- Default mode: Simulation Mode (no live orders)
- Framework modules: configuration, shared types, CSV logger, and market scoring
- Signal modules: EMA trend, ADX, ATR, spread, session, retest, candle and score engines
- Trade modules: guarded market execution and Grid + ATR hybrid scaling
- Risk module: ATR exits, break-even, trailing, partial close, basket and account limits
- Position module: unified basket count, lots, average price and floating P/L
- Dashboard module: market, signal, basket and risk status in one panel
- Integration module: dependency health checks and safe execution sequencing
- Verification module: startup self-tests, static checks and MT4 test procedure
- Performance accounting: realized/cumulative P&L, profit factor and maximum drawdown
- Equity accounting: floating P&L, equity curve, maximum equity DD and recovery factor
- Transaction-cost accounting: configurable commission and adverse round-trip slippage
- Basket diagnostics: entry regime, holding duration, grid depth, outcome and exit reason
- Consecutive-loss adaptive entry threshold and simulation equity-based daily/drawdown limits
- Post-loss time cooldown disabled by default to preserve the Build 1.0.015 baseline
- Future Version 1.0 scope: adaptive market judgement, Grid + ATR hybrid execution, risk control, and dashboard

This build simulates trades by default. Live orders require two explicit safety inputs to be changed.

## Installation

1. Copy `Gold_AI_Scalper_Pro_X.mq4` into `MQL4/Experts/`.
2. Copy the `Include` directory into the EA directory so the relative include paths remain valid.
3. Compile the EA in MetaEditor.
4. Attach it to an XAUUSD/GOLD M1 chart.
5. Keep `InpSimulationMode=true` for framework testing.

## Test checklist

- Compilation completes with zero errors.
- EA rejects non-M1 charts.
- EA rejects symbols that do not contain `XAU` or `GOLD`.
- The chart comment displays market, signal, basket and risk status.
- One signal evaluation is written for each completed M1 bar.
- CSV output is created under `MQL4/Files/Gold_AI_Scalper_Pro_X/` when logging is enabled.
- Simulation partial and basket closes write `PERFORMANCE` rows to the CSV.
- Every simulation processing interval writes an `EQUITY` row to the CSV.

Trading leveraged products involves substantial risk. Validate every build in Strategy Tester and on a demo account before any live use.
