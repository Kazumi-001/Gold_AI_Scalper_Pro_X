# Build 1.0.007 Dashboard

The dashboard is a read-only presentation layer. It receives snapshots from existing modules and does not alter signal, trade, position or risk decisions.

## Sections

- Build and execution mode
- Market state, spread, ATR, MarketScore and DangerScore
- Signal direction, confidence, BuyScore, SellScore and reason
- Basket direction, position count, lots, average entry and floating P/L
- Risk active/blocked state and configured daily/DD limits

`InpShowDashboard` can disable the panel without affecting CSV logging or EA execution.
