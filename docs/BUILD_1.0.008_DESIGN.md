# Build 1.0.008 Integration

The Integration controller is the safety gate between data acquisition and new exposure.

## Readiness checks

- At least 250 XAUUSD M1 history bars
- Valid Bid, Ask and Point
- Valid XM tick size, tick value, minimum lot and lot step
- Valid ATR and market state

When readiness fails, new Signal, initial Trade and Grid actions are paused. Risk Manager, Position Manager, CSV logging and Dashboard remain active so existing exposure can still be protected and diagnosed. State transitions are logged as READY, HISTORY_BLOCK, QUOTE_BLOCK, BROKER_BLOCK or MARKET_BLOCK.
