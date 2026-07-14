# Build 1.0.015 — Three-Position Cap and Virtual Risk Limits

Build 1.0.015 applies the only diagnostic finding that reproduced in both the July development sample and the independent June sample: losses concentrate after baskets reach four or more positions.

The default and XM simulation preset now cap a basket at three positions. This is a prospective strategy change; prior post-hoc results are not treated as proof of its final performance.

Simulation Mode now calculates risk equity as:

`account balance + cumulative net realized profit + estimated net liquidation profit`

The daily 5% loss limit compares current virtual equity with the broker-day opening virtual equity. The 10% maximum drawdown limit compares current virtual equity with its highest observed level. A breach closes any active virtual basket, writes a `RISK` event and blocks new entries until the next broker day.

Live mode retains MT4 account equity and balance calculations.

## Acceptance test

Repeat the June 1–29 Build 1.0.014 test with identical settings except Build 1.0.015 defaults. Confirm:

1. No diagnostic row reports `max_positions` above three.
2. Risk events contain virtual-equity details if a limit is reached.
3. New entries remain blocked after a breach until the next broker day.
4. Final diagnostics and performance totals reconcile.
