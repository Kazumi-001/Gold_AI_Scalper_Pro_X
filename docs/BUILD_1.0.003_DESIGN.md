# Build 1.0.003 Signal Engine

The engine evaluates the last completed XAUUSD M1 candle once per bar.

## Direction score (100 points)

- EMA20/50/200 alignment: 20
- ADX >= 25 with matching DI direction: 20
- ATR within configured range: 10
- EMA20 retest: 20
- Directional candle: 15
- Candle range within configured ATR ratio: 15

A BUY or SELL candidate requires 80 points. Spread, trading session, MarketScore and DangerScore are hard safety gates and do not add points.

Build 1.0.003 never sends, modifies or closes an order. Every completed-bar evaluation is recorded in the CSV log for Strategy Tester and demo validation.
