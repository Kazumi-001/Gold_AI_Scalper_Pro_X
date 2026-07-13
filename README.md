# Gold AI Scalper Pro X

Gold AI Scalper Pro X is a modular Expert Advisor framework for MetaTrader 4.

## Build 1.0.002 (Framework)

- Platform: MetaTrader 4 Build 1400+
- Target: XM XAUUSD/GOLD symbols
- Timeframe: M1
- Default mode: Simulation Mode (no live orders)
- Framework modules: configuration, shared types, CSV logger, and market scoring
- Future Version 1.0 scope: adaptive market judgement, Grid + ATR hybrid execution, risk control, and dashboard

This build intentionally does not place orders. Signal and trade engines are introduced in later builds.

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
- The chart comment displays Build 1.0.002, spread, ATR, MarketScore and DangerScore.
- CSV output is created under `MQL4/Files/Gold_AI_Scalper_Pro_X/` when logging is enabled.

## Roadmap

- Build 1.0.003: Signal Engine
- Build 1.0.004: Trade Engine
- Build 1.0.005: Risk Manager

Trading leveraged products involves substantial risk. Validate every build in Strategy Tester and on a demo account before any live use.
