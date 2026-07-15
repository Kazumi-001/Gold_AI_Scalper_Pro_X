# Build 1.0.023A — Minimum Entry ADX

Single experiment:

- Block new initial entries when ADX is below 20.
- Retain the Build 1.0.021 maximum entry ATR of 400.
- Existing basket management remains active.

Expected startup verification:

```text
test=MIN_ENTRY_ADX,result=PASS,details=20.0
```
