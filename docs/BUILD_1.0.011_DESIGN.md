# Build 1.0.011 — Simulation Performance Accounting

Build 1.0.011 adds account-currency performance measurements to Simulation Mode.

Each virtual partial close records its realized profit immediately. The remaining volume is valued only when the basket closes, preventing double counting. A completed basket combines all of its partial and final realized amounts before it is classified as a win or loss.

`PERFORMANCE` CSV events contain:

- `realized`: profit realized by the current close action
- `basket_profit`: realized profit accumulated for the active basket
- `cumulative`: realized profit across the test run
- `gross_profit`: sum of profitable completed baskets
- `gross_loss`: absolute sum of losing completed baskets
- `profit_factor`: gross profit divided by gross loss (`INF` until the first loss)
- `max_drawdown`: largest decline from peak cumulative profit, in account currency
- `wins` and `losses`: completed-basket counts

The metrics reset whenever the EA is initialized. They do not reconstruct earlier events from an existing appended CSV file.

## Acceptance test

Run XM GOLD/XAUUSD M1 in Simulation Mode with spread 30. Confirm that startup verification passes and that every `BASKET_CLOSE` trade event is followed by a `PERFORMANCE` event. The final performance row supplies the run totals used for profitability review.
