# MT4 Backtest Procedure

## Compile

1. Copy the EA and `Include` directory into `MQL4/Experts/Gold_AI_Scalper_Pro_X/`.
2. Open `Gold_AI_Scalper_Pro_X.mq4` in MetaEditor.
3. Compile with MT4 Build 1400 or later.
4. Acceptance: zero errors. Record warnings separately.

## Strategy Tester

- Expert: Gold_AI_Scalper_Pro_X
- Symbol: the XM XAUUSD/GOLD symbol used by the account
- Period: M1
- Model: Every tick
- Spread: Current first, then fixed stress cases
- Date range: at least three months containing different volatility regimes
- Preset: `Presets/XM_XAUUSD_M1_Simulation.set`
- Visual mode: first short validation run only

## Acceptance

- Startup self-test reports zero failures.
- Dashboard reaches `System: READY` after history loads.
- No live orders are created with the simulation preset.
- Exactly one signal record is produced per completed M1 bar.
- Virtual grid never exceeds six positions.
- Risk exits and blocked states appear in CSV without runtime errors.
- EA deinitializes without leaving chart objects or open file handles.

Save HTML reports, tester logs and the used `.set` file in a dated subdirectory under `Backtest/results/`. Do not commit broker credentials or account identifiers.
