# Build 1.0.004 Trade Engine

## Entry

An initial BUY or SELL is accepted only from the completed-bar Signal Engine result. Existing EA orders on the symbol block a new initial basket.

## Grid + ATR hybrid

Additional positions are opened only when price moves adversely from the latest entry by the larger of:

- 300 points; or
- ATR(14) multiplied by the configured grid multiplier.

The fixed Version 1.0 lot sequence is 0.01, 0.02, 0.03, 0.05, 0.08 and 0.13, capped at six positions.

## Safety

Simulation Mode keeps a virtual basket and writes the same initial/grid decisions to CSV without calling `OrderSend`. Live execution requires `InpSimulationMode=false` and `InpEnableLiveTrading=true`. Exit and account-risk logic is introduced by Build 1.0.005.
