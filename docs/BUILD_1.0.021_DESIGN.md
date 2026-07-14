# Build 1.0.021 — High ATR Entry Filter

Single experiment:

- Block new initial entries when M1 ATR exceeds 400 points.
- Existing basket management remains active.
- All other strategy logic is unchanged.

Expected verification:

```text
test=MAX_ENTRY_ATR,result=PASS,details=400.0
```
