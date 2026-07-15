# Build 1.0.023B — Entry Hour Exclusion

Single experiment:

- Block new initial entries during broker hours 16 and 19.
- Existing basket management remains active.
- All other Build 1.0.021 logic is unchanged.

Expected startup verification:

```text
test=ENTRY_HOUR_EXCLUSION,result=PASS,details=16/19
```
