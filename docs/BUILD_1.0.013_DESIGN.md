# Build 1.0.013 — Transaction Cost Stress Test

Build 1.0.013 makes simulation results more conservative by deducting configurable commission and adverse slippage from every closed virtual volume.

The default cost model is:

- round-turn commission: 7.00 account-currency units per 1.00 lot
- slippage: 5 points at entry and 5 points at exit
- spread: already represented by ask-side buys, bid-side sells and their opposite exit quotes

For each partial or final close:

`net_realized = gross_realized - commission - round_trip_slippage`

`PERFORMANCE` rows expose gross realized profit, commission, slippage, cumulative costs and net realized profit. Cumulative profit, profit factor, drawdown and recovery factor use the net result.

While a basket is open, the `EQUITY` floating value also deducts the estimated commission and round-trip slippage required to liquidate the remaining volume.

Swap is not estimated because broker swap modes and triple-swap schedules vary. Use broker-specific settings or demo forward testing before live deployment.

## Acceptance test

Run the same GOLD/XAUUSD M1 test used for Build 1.0.012. Confirm that trade counts remain unchanged, cumulative costs are non-decreasing, and final net profit is lower than the equivalent gross profit by the final cumulative-cost value.
