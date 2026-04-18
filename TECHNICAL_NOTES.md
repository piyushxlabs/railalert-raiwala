# Technical Notes

Step 1 — No deviations from spec.

---
## Architecture Decision — Spark Plan Restructuring
**Decision:** Spark plan temporary architecture adopted. Cloud Functions deferred. Direct DB write used temporarily. Security rules relaxed temporarily. Full Cloud Function architecture to be restored on Blaze plan upgrade.
**Reason:** Firebase Cloud Functions are unavailable on the free Spark plan. Wait for Blaze upgrade.
**Impact:** Client app must now send FCM messages manually and enforce state transition validations (OPEN->ALERT, etc) locally until server validation is available.
---
