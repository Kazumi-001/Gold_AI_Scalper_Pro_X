# Build 1.0.006 Position Manager

The Position Manager provides one normalized basket view to later dashboard and integration builds.

## Summary fields

- Direction: BUY, SELL or flat/mixed
- Active position count
- Total lots
- Volume-weighted average entry price
- Current executable price
- Floating profit/loss
- Simulation or live mode

Live summaries include profit, swap and commission from orders matching both symbol and Magic Number. Simulation summaries use XM tick size and tick value with the virtual basket maintained by the Trade Engine. Position-count changes are written to CSV.
