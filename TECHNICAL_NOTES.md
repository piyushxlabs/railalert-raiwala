# Technical Notes

Step 1 — No deviations from spec.

---
## Architecture Decision — Spark Plan Restructuring
**Decision:** Spark plan temporary architecture adopted. Cloud Functions deferred. Direct DB write used temporarily. Security rules relaxed temporarily. Full Cloud Function architecture to be restored on Blaze plan upgrade.
**Reason:** Firebase Cloud Functions are unavailable on the free Spark plan. Wait for Blaze upgrade.
**Impact:** Client app must now send FCM messages manually and enforce state transition validations (OPEN->ALERT, etc) locally until server validation is available.
---

Step 2 — No deviations from spec.

Step 3 — Adopted `google_fonts` package for the bundled Noto Sans instead of loading manual TTF files into assets. This is the recommended Flutter way and caching works efficiently offline after the first boot.

Step 3B — Configured `FirebaseDatabase.instance.setPersistenceEnabled(true)` early in the `runApp` initialization to bypass lack of robust back-end connection logic per Spark plan restrictions. This will ensure UI state changes even if network oscillates.
