# Changelog

## [1.0.018] - 2026-07-14

### Changed

- Reverted the rejected initial-entry anchored stop experiment.
- Restored Build 1.0.015 three-position, volume-weighted-average ATR stop behavior.

### Added

- Configurable post-loss entry cooldown, defaulting to 30 minutes.
- All new initial entries are blocked during the cooldown; open-basket management remains active.
- `LOSS_COOLDOWN` risk events include basket ID and cooldown expiration time.
- Startup verification of the cooldown range.

### Purpose

- Reduce repeated entries during the same adverse market regime without changing the underlying signal scores or successful basket management.

## [1.0.017] - 2026-07-14

### Changed

- Maximum-position default and XM preset restored to three, the best prospective cap tested.
- Simulation basket stop is anchored to the initial entry price and entry-time ATR.
- Risk processing now runs before grid expansion on each processing interval.

### Risk behavior

- Grid averaging can no longer move the basket stop farther away from the initial trade thesis.
- The anchored stop uses the existing `InpStopLossAtrMultiplier` default of 2.0.
- Take-profit and partial-profit management remain based on the current volume-weighted basket average.
- Anchored exits are logged as `INITIAL_ANCHORED_STOP`.

### Evidence

- A prospective two-position cap worsened June performance to -998.85 with a 0.800 profit factor.
- Simple depth reduction is therefore rejected in favor of a fixed initial-risk boundary.

## [1.0.016] - 2026-07-14

### Changed

- Default and XM simulation preset maximum positions reduced from three to two.

### Evidence

- Prospective Build 1.0.015 testing reduced June drawdown from 20.768% to 9.042%, but remained unprofitable at -703.28.
- In that run, one-position baskets earned 2,098.99 and two-position baskets earned 1,575.41.
- Baskets that reached the third position lost 4,378.61 with a 0.406 profit factor.

### Scope

- Signal, exit, transaction-cost, diagnostic and virtual-risk logic are unchanged so the effect of the two-position cap can be measured independently.

## [1.0.015] - 2026-07-14

### Changed

- Default and XM simulation preset maximum positions reduced from six to three.
- Simulation Mode daily-loss calculations now use virtual equity.
- Simulation Mode maximum-drawdown calculations now use peak virtual equity.
- Basket percentage exits use estimated net liquidation profit after transaction costs.

### Added

- Risk-limit CSV events include virtual equity, daily loss percentage and drawdown percentage.
- Daily virtual-equity baseline resets at the start of each broker day.

### Evidence

- Four-or-more-position baskets lost 566.78 in the July diagnostic sample.
- Four-or-more-position baskets lost 4,760.07 in the independent June sample.
- The former Simulation Mode risk check referenced unchanged MT4 account equity and therefore did not enforce the configured virtual limits.

## [1.0.014] - 2026-07-14

### Added

- Unique sequential basket identifiers for each simulation run.
- Entry-time ADX, ATR, MarketScore, DangerScore, directional scores and hour.
- Maximum grid/position depth and basket holding duration.
- Completed-basket net result, outcome and exit reason in one `DIAGNOSTIC` row.
- Entry-regime values in regular `SIGNAL` CSV rows.

### Purpose

- Identify market regimes associated with weak or losing baskets before changing strategy rules.
- Enable grouped analysis by ADX, ATR, hour, direction and grid depth without reconstructing basket state.

## [1.0.013] - 2026-07-14

### Added

- Configurable Simulation Mode round-turn commission per lot.
- Configurable adverse slippage points on both entry and exit.
- Gross realized profit, commission, slippage and cumulative transaction costs in `PERFORMANCE` rows.
- Net performance metrics after simulated transaction costs.
- Startup verification of non-negative transaction-cost settings.

### Defaults

- Commission: 7.00 account-currency units per closed lot, round turn.
- Slippage: 5 points per side, applied as a two-sided cost when volume closes.
- Bid/ask spread remains included through the existing simulated entry and exit prices.

## [1.0.012] - 2026-07-14

### Added

- Simulation equity curve combining cumulative realized and current floating profit.
- Peak-equity tracking and current equity drawdown.
- Maximum equity drawdown in account currency and percentage of account balance.
- Recovery factor calculated as cumulative realized profit divided by maximum equity drawdown.
- `EQUITY` CSV events at every simulation processing interval.

### Clarified

- Build 1.0.011 maximum drawdown remains the completed-realization drawdown.
- Build 1.0.012 equity drawdown additionally captures adverse movement while baskets are open.

## [1.0.011] - 2026-07-14

### Added

- Realized profit recording for simulated partial and basket closes.
- Cumulative simulated profit across completed baskets.
- Basket-level gross profit, gross loss, wins and losses.
- Profit factor and maximum cumulative-profit drawdown.
- `PERFORMANCE` CSV events with auditable accounting fields.

### Accounting

- Partial-close profit is included in the final basket result without double counting.
- Profit factor is calculated from completed basket results.
- Maximum drawdown is measured in account currency from the cumulative-profit peak.

## [1.0.010] - 2026-07-14

### Fixed

- Spread now uses the broker's integer `MODE_SPREAD` value.
- Spread equal to the configured maximum is consistently allowed.
- Floating-point quote noise no longer marks 30-point spread as dangerous.
- Initial flat Position Manager state no longer emits a false count-increase event.

### Backtest evidence

- Build 1.0.009 processed 23,641 completed-bar signals without runtime errors.
- 23,633 signals were incorrectly blocked at the exact 30-point spread boundary.
- Six recorded entries represent two appended runs; each run produced three virtual baskets.
- Every virtual basket reached partial profit and ATR take-profit in the supplied log.

## [1.0.009] - 2026-07-14

### Added

- Startup verification module with CSV PASS/FAIL results.
- Simulation preset for XM XAUUSD M1.
- Repository static-check script and GitHub Actions workflow.
- MT4 compilation, Strategy Tester and acceptance checklist.
- Backtest result directory guidance.

## [1.0.008] - 2026-07-14

### Added

- Integration controller and runtime system state.
- Minimum M1 history validation before indicator execution.
- Quote, XM contract specification and market-data health checks.
- New Signal/Trade/Grid pipeline block when dependencies are not ready.
- Risk and position management remain active during integration blocks.
- Integration transition CSV logging and Dashboard status.

## [1.0.007] - 2026-07-14

### Added

- Dedicated Dashboard module.
- Unified market, signal, basket and risk sections.
- Simulation/live mode, spread, ATR, MarketScore and DangerScore display.
- Buy/Sell scores, confidence and rejection reason display.
- Position count, lots, average price and floating P/L display.
- Configurable dashboard visibility and clean shutdown.

## [1.0.006] - 2026-07-14

### Added

- Unified Position Manager for simulation and live baskets.
- Position count, direction, total lots and volume-weighted average price.
- Floating P/L including swap and commission for live orders.
- XM tick-size/tick-value virtual P/L calculation.
- Position-count transition logging and on-chart basket status.

## [1.0.005] - 2026-07-14

### Added

- ATR 2.0 stop-loss and ATR 1.5 take-profit.
- Break-even at 1.0 ATR with 10-point offset.
- 1.0 ATR trailing stop and 50% partial close at 1.0 ATR.
- Daily loss limit 5% and maximum equity drawdown 10%.
- Basket profit exit 2% and basket loss exit 5%.
- Emergency basket close and trading block.
- Simulation-mode virtual P/L, partial and exit events.
- Live `OrderModify`/`OrderClose` management with CSV risk logging.

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
