# Build 1.0.017 — Initial-Entry Anchored Basket Stop

Build 1.0.017 restores the three-position cap and changes the simulation stop-loss reference.

Previously, the ATR stop used the volume-weighted average entry price. Every adverse grid addition moved that average toward the market and therefore moved the effective stop farther from the original entry. This allowed the initial trade risk to expand as the basket grew.

The new stop is fixed when the initial position opens:

`stop distance = entry-time ATR × InpStopLossAtrMultiplier`

The stop compares current bid/ask with the initial entry price and never changes when grid positions are added. Risk management is processed before grid expansion, so a price already beyond the anchored boundary is closed instead of receiving another grid position.

Take-profit and partial-close triggers remain based on the volume-weighted average entry. Transaction-cost, diagnostics and virtual-equity account protections remain unchanged.

## Acceptance test

Repeat the June 1–29 test and confirm:

1. `POSITION_CAP` equals three.
2. Anchored stop exits appear as `INITIAL_ANCHORED_STOP`.
3. No grid addition occurs after the anchored boundary is breached.
4. Compare cumulative profit, profit factor and maximum equity drawdown with Builds 1.0.015 and 1.0.016.
