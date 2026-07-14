# Build 1.0.018 — Post-Loss Re-entry Cooldown

Build 1.0.018 returns to the Build 1.0.015 research baseline: maximum three positions and ATR stop-loss measured from the volume-weighted basket average.

The Build 1.0.017 anchored-stop experiment is removed because it lowered the June win rate and reached the drawdown limit earlier.

After a completed basket has a negative net result, new initial entries are blocked for 30 broker-time minutes. Signal evaluation, CSV logging, risk management and management of any existing basket continue normally. A `LOSS_COOLDOWN` risk event records the basket ID and expiration time.

The cooldown is configurable with `InpLossCooldownMinutes`; zero disables it.

## Acceptance test

Repeat the June 1–29 test and verify:

1. `POSITION_CAP` equals three and `LOSS_COOLDOWN` equals 30.
2. Every losing completed basket writes one `LOSS_COOLDOWN` event.
3. No new `INITIAL` trade occurs before the preceding cooldown expires.
4. Compare trade count, cumulative profit, profit factor and maximum drawdown with Build 1.0.015.
