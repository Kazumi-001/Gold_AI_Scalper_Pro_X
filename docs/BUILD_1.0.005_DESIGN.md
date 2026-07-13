# Build 1.0.005 Risk Manager

## Default controls

- Stop loss: 2.0 ATR
- Take profit: 1.5 ATR
- Break-even: 1.0 ATR, 10-point offset
- Trailing distance: 1.0 ATR
- Partial close: 50% at 1.0 ATR
- Daily loss limit: 5% of start-of-day balance
- Maximum equity drawdown: 10%
- Basket exit: +2% profit or -5% loss relative to balance

Risk-limit activation closes the active EA basket and blocks further entries until the next broker day. Simulation Mode applies equivalent virtual exits and CSV events without trading.
