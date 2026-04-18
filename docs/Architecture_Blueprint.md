━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏗️ ARCHITECTURE BLUEPRINT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Project Name:** RailAlert Raiwala
**Build Approach:** Order-driven (not time-constrained)
**Target:** Production-ready V1
**Builder:** Solo full-stack developer

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **1. PROJECT SUMMARY**

RailAlert Raiwala is an Android app that displays the real-time open/closed status of the Raiwala railway crossing gate and pushes advance notifications to commuters — driven entirely by a single gateman pressing one button at a time on his phone.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **2. TARGET USER**

**Primary User:** Daily road commuter (local residents, office-goers, delivery riders) crossing the Raiwala railway gate
**Context:** On the road or about to leave home/work, checking their Android phone for gate status before entering the crossing corridor
**Technical Level:** Non-technical

**Operator (not primary user):** The gateman — a single, non-technical individual who volunteers to press buttons on a hidden screen within the same app

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **3. CORE USER GOAL**

Commuter checks current gate status — or receives a push notification — before reaching the crossing, so they can avoid joining a traffic queue that has no exit.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **4. PLATFORM & DEPLOYMENT STRATEGY**

**Platform:** Android (native, single APK)
**Architecture Pattern:** Serverless — Firebase-only backend, no custom server process
**Deployment Target:** Google Play Store (free tier) as primary distribution. Direct APK sideload as fallback during early launch phase, until Play Store review clears.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **5. API & DATA FLOW ARCHITECTURE**

**API Style:** No custom REST API. All data flow is direct client ↔ Firebase SDK communication — no intermediate server layer required.

**Real-time Needs:** Firebase Realtime Database persistent socket connection. The Android SDK maintains a live listener on the gate status node. Status changes propagate to all connected clients in under 1 second without polling.

**Data Sync:** Client-side real-time listener (Firebase `onValue` listener). The app renders whatever the database currently holds. No server-side rendering. No polling interval.

**Notification Trigger Flow (TEMPORARY Spark plan flow):**
Gateman app → Firebase DB directly
       → Flutter app sends FCM via firebase_messaging package directly (no Cloud Function needed)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **6. USER ENTRY POINT**

**Trigger:** Commuter installs app from Play Store (or sideloads APK) and opens it; or receives a push notification on their lock screen
**First Action:** App requests FCM notification permission on first launch (Android 13+ requires explicit permission)
**Entry Experience:** Immediately after permission prompt, the commuter lands on the single public dashboard screen showing the current gate status as a large, color-coded status card (Green = Open, Orange = Alert, Red = Closed) with the timestamp of the last update

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **7. END-TO-END USER FLOW**

**Commuter Flow:**
1. Commuter installs RailAlert Raiwala app on Android device
2. App shows FCM notification permission prompt on first launch
3. Commuter grants permission → App subscribes device FCM token to topic `gate-status-alerts`
4. Commuter sees public dashboard: large status card (Green/Open), timestamp of last update
5. Firebase Realtime Database listener is active — status updates render instantly without user action
6. Gateman presses "Train Coming (Alert)" button on his hidden screen
7. Database writes `status: "ALERT"` → Flutter app sends FCM push to all subscribers
8. Commuter receives lock-screen notification: "⚠️ Raiwala Gate closing soon — plan your route"
9. Commuter opens app → sees Orange status card with current timestamp
10. Commuter decides to delay trip or take alternate route — avoids the queue

**Gateman Flow:**
1. Gateman opens app on his Android phone
2. Gateman taps the app logo 5 times rapidly → PIN entry screen appears
3. Gateman enters hardcoded 4-digit PIN → admin screen unlocks
4. Admin screen shows ONE large button: **"Train Coming (Alert)"** — full screen, impossible to miss
5. Gateman presses it when train is ~10 minutes away → database updates → notifications fire
6. Button cycles to next state: ONE large button **"Gate Closed"** appears
7. Gateman presses it when gate is physically closed → database updates → notifications fire
8. Button cycles to final state: ONE large button **"Gate Opened"** appears
9. Gateman presses it when gate reopens → database updates → notifications fire
10. Button cycles back to State 1: **"Train Coming (Alert)"** — ready for next cycle

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **8. OFFLINE & STATE MANAGEMENT**

**Local State:** Flutter's built-in `setState` / `StreamBuilder` — no external state library needed. The Firebase Realtime Database stream is the single source of truth; local state only tracks: (a) whether gateman PIN screen is unlocked, (b) current step in the 3-button cycle.

**Server State Caching:** Firebase Realtime Database SDK caches the last known value on-device automatically. If connectivity is lost, the app displays the last known status with a visible "Last updated: [timestamp]" indicator — no additional caching library required.

**Offline Capability:** Firebase Realtime Database disk persistence is enabled (`FirebaseDatabase.instance.setPersistenceEnabled(true)`). Commuter sees last known status when offline. Gateman writes are queued locally and sync when connection restores. A visible connectivity banner ("You are offline — showing last known status") prevents user confusion.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **9. MONETIZATION & BUSINESS LOGIC**

**Revenue Model:** Free — no monetization in V1
**Payment Tech:** None
**Core Business Rules:**
The only business logic in this system is the state machine governing the gate cycle. The database enforces a single valid state at any time: `OPEN`, `ALERT`, or `CLOSED`. The gateman's admin screen reads the current state from the database and renders only the next valid button — preventing out-of-sequence presses at the UI layer. No payment logic, no user tiers, no access gating.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **10. AI & EXTERNAL INTEGRATIONS**

**AI Capabilities:** None required. This system is entirely deterministic — a human operator triggers state changes, a rules-based state machine sequences them, and Firebase delivers them. AI introduces unnecessary cost and complexity for a problem fully solved by simple logic.

**Critical APIs:**
- Firebase Realtime Database — gate state storage and real-time sync
- Firebase Cloud Messaging (FCM) — push notification delivery to Android devices
- Firebase Cloud Functions (Node.js, free tier) — serverless trigger to fan out FCM messages on database write events

**Webhooks:** Firebase Cloud Function acts as the internal webhook: database write event → Cloud Function → FCM fan-out. No external webhook endpoints required.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **11. NON-AI COMPONENTS**

**Authentication:**
- Commuter: No authentication. App is fully public. No account creation, no login.
- Gateman: Local-only access control. Secret tap sequence (5 rapid taps on app logo) → hardcoded 4-digit PIN stored in app constants. PIN check happens entirely on-device. No Firebase Auth, no server session, no token.

**Data Storage:**
Firebase Realtime Database (Spark free tier) stores exactly one document node:
```
/gate_status
  status: "OPEN" | "ALERT" | "CLOSED"
  updated_at: ISO timestamp (server timestamp)
  updated_by: "gateman" (static string, no user identity)
```
FCM device tokens are managed by Firebase automatically via topic subscription — no token storage required in the app's database.

**Business Logic:**
State machine with 3 valid states and 3 valid transitions: OPEN → ALERT → CLOSED → OPEN. Enforced at UI layer (admin screen shows only the next valid button). Cloud Function reads the new state on write and selects the appropriate FCM notification payload to send.

**External Services:**
Firebase suite only (Realtime Database + Cloud Messaging + Cloud Functions). All under one Firebase project on the Spark free plan.

**Infrastructure:**
Firebase project (Spark plan, no credit card required for Realtime Database + FCM). Cloud Functions requires Blaze plan (pay-as-you-go) — but at Raiwala's traffic volume, cost will remain within the free monthly quota (first 2M invocations/month free). Founder must upgrade project to Blaze to enable Cloud Functions; actual charges will be $0 at this scale.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **12. DATA INPUTS**

**Primary Inputs:**
- Gateman button press → one of three state values (`ALERT`, `CLOSED`, `OPEN`) written to Firebase Realtime Database

**Secondary Inputs:**
- Android device FCM token (auto-generated by Firebase SDK on app install, auto-subscribed to topic)
- Notification permission grant/deny (Android OS permission dialog on first launch)

**Input Methods:**
- Gateman: Single large touchscreen button tap on admin screen
- Commuter: No manual input required — passive receiver only

**Validation:**
- State transitions are constrained by UI — gateman cannot write an invalid state because only the next valid button is rendered
- PIN input: 4 digits only, no submission until 4 digits entered, wrong PIN shows error and resets
- Firebase Security Rules: Database write access locked to server-side only via Cloud Function service account. The Android app itself cannot write directly to the database — all writes route through the Cloud Function. This prevents any commuter from spoofing a status update.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **13. DATA OUTPUTS**

**Primary Output:**
Real-time gate status rendered on commuter's public dashboard screen — large color-coded status card with timestamp

**Secondary Outputs:**
- Android push notification (lock screen + notification tray) on each of the 3 state transitions
- Gateman admin screen reflects confirmed current state after each write (visual confirmation of successful button press)

**Format:**
- UI: Flutter widget rendering status string + timestamp from Firebase stream
- Notification: FCM notification payload with title + body text, no image, no action buttons

**Delivery:**
- Status: Rendered in-app within <1 second of gateman button press via Firebase real-time listener
- Notifications: Delivered via FCM to all topic subscribers; target delivery under 10 seconds of gateman press

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **14. ERROR & FAILURE HANDLING**

**Gateman Connectivity Failure:**
- Scenario: Gateman presses button but has no mobile data
- Detection: Firebase SDK write returns error callback
- Handling: Firebase queues the write locally; syncs when connectivity restores. Admin screen shows a persistent "Offline — update will sync when connected" banner.
- User sees: Status does not update until gateman's write syncs. Commuter sees last known status with stale timestamp — offline banner visible.

**Cloud Function Failure (FCM not triggered):**
- Scenario: Cloud Function errors out after database write succeeds
- Detection: Cloud Function logs in Firebase console; no notification delivered
- Handling: Status update in app is unaffected (database write already succeeded). Notification is lost for that event — no retry in V1.
- User sees: Status updates correctly in-app; push notification may not arrive for that event.

**Wrong PIN Entry:**
- Scenario: Gateman or unauthorized user enters wrong PIN
- Detection: On-device comparison of entered digits against hardcoded constant
- Handling: Error message displayed ("Incorrect PIN"), input cleared, gateman can retry immediately. No lockout in V1.
- User sees: "Incorrect PIN. Try again." message on admin screen.

**Commuter Offline:**
- Scenario: Commuter opens app with no internet
- Detection: Firebase SDK connectivity state listener
- Handling: Firebase SDK serves last cached status from disk persistence. Connectivity banner shown.
- User sees: Last known gate status with timestamp and "Offline — showing last known status" banner.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **15. GUARDRAILS & CONSTRAINTS**

**AI Constraints:**
- Not applicable — no AI in this system

**Data Constraints:**
- Database stores exactly one gate status node at all times — no historical log in V1
- No PII stored anywhere in the system — FCM topic subscription is anonymous
- Firebase Spark/Blaze free tier limits: Realtime Database 1GB storage, 10GB/month transfer — far exceeds V1 needs at one node
- FCM: No hard limit on topic subscribers on free tier

**Usage Constraints:**
- Gate status can only be updated by the gateman's device (app enforces sequential button flow; Firebase Security Rules enforce write-only via Cloud Function service account)
- Admin screen inaccessible without 5-tap sequence + correct PIN — no brute-force protection in V1 (acceptable given low-stakes data)
- No rate limiting on commuter app opens or status reads in V1

**Security:**
- Firebase Security Rules set to: public read on `/gate_status`, write only by Cloud Function service account (denies all direct client writes)
- PIN is hardcoded in app constants — security by obscurity only; acceptable for V1 given data sensitivity is minimal (gate open/closed is public information)
- No HTTPS configuration needed — Firebase SDK handles all transport security natively

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **16. MINIMAL FEATURE SET (V1)**

1. **Public status dashboard** — Core value delivery; commuter's reason to install the app
2. **Real-time status sync without refresh** — Essential for trust; stale data is worse than no data
3. **Last-updated timestamp display** — Commuter must know if gateman is active; timestamp is the trust signal
4. **FCM push notification: Alert (closing soon)** — The highest-value notification; gives commuter decision time
5. **FCM push notification: Gate Closed** — Confirms gate state for commuters already en route
6. **FCM push notification: Gate Opened** — Tells waiting commuters they can now proceed
7. **Gateman admin screen with sequential single-button UI** — The entire system depends on gateman compliance; friction kills compliance
8. **Secret tap + PIN access to admin screen** — Prevents accidental or malicious status spoofing by commuters

**TOTAL:** 8 features

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **17. EXPLICIT NON-FEATURES**

❌ **NOT building:** User accounts or login for commuters
Reason: No personalization or history exists in V1; accounts add friction and drive-away installs

❌ **NOT building:** Gate status history or event log
Reason: Commuters only need the current state; historical data has no V1 use case and complicates database structure

❌ **NOT building:** Predicted wait time or ETA calculation
Reason: Timing is fully manual and irregular; any estimate would be unreliable and erode trust

❌ **NOT building:** Alternate route suggestions or map integration
Reason: Out of scope; Google Maps handles routing; this app's job is status, not navigation

❌ **NOT building:** Hyper-local advertising
Reason: Explicitly deferred to post-V1 by founder

❌ **NOT building:** iOS version
Reason: Platform constraint is Android only for V1

❌ **NOT building:** Web dashboard or PWA
Reason: Platform constraint is Android app only for V1; no web alternative

❌ **NOT building:** Multiple gate support or location selection
Reason: V1 is for one specific crossing — Raiwala; generalization is a V2 concern

❌ **NOT building:** Gateman identity verification or cloud authentication
Reason: Local PIN is sufficient for V1; cloud auth adds setup complexity and a potential point of failure for the gateman

❌ **NOT building:** Admin panel for the founder to manage the system remotely
Reason: Firebase console provides full visibility; a custom admin panel is unnecessary complexity for V1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **18. TECH STACK DECISIONS**

**Frontend / Mobile Framework:** Flutter (Dart) — single codebase, excellent Android performance, rich widget library for building the large-button admin UI, strong Firebase SDK support via `firebase_core`, `firebase_database`, `firebase_messaging` packages

**Backend:** Firebase Cloud Functions (Node.js 18 runtime) — serverless, zero infrastructure management, triggered directly by Realtime Database writes, handles FCM fan-out

**Database:** Firebase Realtime Database — locked in per Project Brief; handles real-time sync via persistent WebSocket; single node storage is trivially within free tier

**File Storage:** None — no media assets stored

**API Layer:** None — no custom REST API. Flutter app communicates directly with Firebase SDK. Cloud Function is triggered by database events, not HTTP calls.

**State Management:** Flutter `StreamBuilder` widget consuming Firebase Realtime Database stream directly — no external state management library (Riverpod, Bloc, Provider) needed for this minimal data model

**Authentication:**
- Commuter: None
- Gateman: Hardcoded PIN stored in `lib/config/secrets.dart` (not committed to public repo); checked on-device only

**Payments:** None

**Push Notifications:** Firebase Cloud Messaging (FCM) via `firebase_messaging` Flutter package. Topic-based subscription (`gate-status-alerts`) — no individual token management required.

**Hosting / Distribution:** Google Play Store (free developer account — one-time $25 registration fee). APK sideload for early testers before Play Store review completes.

**Monitoring:** Firebase Crashlytics (free) for crash reporting on both commuter and gateman devices. Firebase console for Cloud Function logs and database state inspection. No additional monitoring tooling in V1.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **19. BUILD ORDER**

**PHASE 1: Firebase Project Foundation**
- Create Firebase project, enable Realtime Database, enable FCM, upgrade to Blaze plan (required for Cloud Functions)
- Set initial database node: `{ status: "OPEN", updated_at: <server timestamp> }`
- Write and deploy Firebase Security Rules (public read, deny all direct client writes)
- Verify database is live and readable via Firebase console

**PHASE 2: Flutter Project Setup**
- Initialize Flutter project targeting Android (minSdkVersion 21)
- Add Firebase dependencies: `firebase_core`, `firebase_database`, `firebase_messaging`, `firebase_crashlytics`
- Run `flutterfire configure` to connect Flutter project to Firebase project
- Confirm Firebase initializes cleanly on Android emulator

**PHASE 3: Public Dashboard Screen**
- Build single-screen commuter UI: large status card (color-coded: Green/Orange/Red), status label text, last-updated timestamp
- Wire `StreamBuilder` to Firebase Realtime Database `/gate_status` node
- Confirm live status renders and updates in real time when database is manually edited in Firebase console
- Add offline connectivity banner (Firebase SDK connectivity state listener)

**PHASE 4: Push Notification Infrastructure**
- Implement FCM initialization and notification permission request on app first launch (Android 13+ `POST_NOTIFICATIONS` permission)
- Subscribe all users to FCM topic `gate-status-alerts` on permission grant
- Handle foreground, background, and terminated app notification receipt
- Confirm a test FCM message sent from Firebase console appears on device

**PHASE 5: Cloud Function — Notification Trigger**
- Write Cloud Function (`functions/index.js`): triggered on `onValueWritten` to `/gate_status`
- Function reads new status value, selects notification payload (3 payloads: one per state), calls FCM `sendToTopic`
- Deploy Cloud Function
- End-to-end test: manually write status to database → confirm FCM notification fires on test device

**PHASE 6: Gateman Admin Screen**
- Build hidden admin entry point: tap-counter on app logo (5 taps within 2 seconds triggers PIN screen)
- Build PIN entry screen: 4-digit numeric input, submit on 4th digit, error state on wrong PIN, success navigates to admin screen
- Build admin screen: single full-screen button, reads current state from database, renders correct next-action button label and color
- On button press: call Cloud Function via HTTPS callable (or write directly via admin SDK — use HTTPS callable to avoid exposing write rules); update database with new state and server timestamp
- Cycle logic: OPEN → ALERT → CLOSED → OPEN, enforced in button rendering logic
- Test full 3-step cycle on physical Android device

**PHASE 7: End-to-End Integration Test**
- Install app on two physical Android devices (one = gateman, one = commuter)
- Run full cycle: gateman presses Alert → commuter receives notification + sees Orange card → gateman presses Closed → commuter receives notification + sees Red card → gateman presses Opened → commuter receives notification + sees Green card
- Test offline behavior: disable commuter's internet, confirm last-known status displays with banner
- Test wrong PIN entry, confirm error and retry behavior
- Fix all issues found

**PHASE 8: Production Readiness**
- Enable Firebase Crashlytics on both screens
- Set gateman PIN to agreed value in `secrets.dart`, confirm file is in `.gitignore`
- Build release APK / App Bundle (signed)
- Sideload APK on gateman's physical device, confirm full cycle works on his actual phone
- Submit to Google Play Store

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **20. DEFINITION OF DONE**

**Functional:**
✅ Gateman presses "Train Coming (Alert)" button → all subscribed commuter devices receive push notification within 15 seconds
✅ Gateman completes full 3-button cycle (Alert → Closed → Opened) → commuter dashboard reflects correct status at each stage without a manual refresh
✅ Wrong PIN entered on admin screen → error message shown, access denied, no state change occurs
✅ Gateman's device loses internet mid-cycle → write queues locally and syncs correctly when connectivity restores

**Performance:**
✅ Status update is visible on commuter screen within 2 seconds of gateman button press (on active internet connection)
✅ App cold-launch to status visible in under 3 seconds on a mid-range Android device

**User Experience:**
✅ Gateman can complete a full Alert → Closed → Opened cycle without any written instructions — UI is self-evident
✅ Commuter opening the app with no internet connection sees a clear "offline" indicator alongside the last known status — no blank screen, no crash

**Technical Quality:**
✅ Firebase Security Rules prevent any direct client write to `/gate_status` — verified by attempting a write from the app without going through Cloud Function
✅ `secrets.dart` containing hardcoded PIN is confirmed absent from any public version control commit

**Production Readiness:**
✅ Signed release APK installs and runs correctly on gateman's physical Android device
✅ Firebase Crashlytics initialized — a test crash is manually triggered and confirmed visible in Firebase console

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━