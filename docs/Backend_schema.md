# BACKEND SCHEMA

**Generated:** April 17, 2026
**Source:** ARCHITECTURE_BLUEPRINT.md + PROJECT_BRIEF.md
**Status:** AUTHORITATIVE — All downstream systems must obey this schema
**Tech Stack:** Firebase Realtime Database + Firebase Cloud Functions (Node.js 18) + Firebase Cloud Messaging (FCM)

> **Note on PostgreSQL conventions:** This project uses Firebase Realtime Database (NoSQL JSON tree), not PostgreSQL. All schema definitions below follow Firebase node conventions. PostgreSQL-style conventions (snake_case, uuid, timestamptz) are adapted to Firebase equivalents where applicable. RLS is replaced by Firebase Security Rules.

---

## **1. DATABASE SCHEMA**

### **Naming & Type Conventions:**
- All node paths: snake_case (e.g., `gate_status`, `device_tokens`)
- All IDs: Firebase push IDs (auto-generated strings) unless noted
- All timestamps: ISO 8601 string (server timestamp via `ServerValue.TIMESTAMP` — stored as Unix ms integer)
- All state values: uppercase string enum (`"OPEN"` | `"ALERT"` | `"CLOSED"`)
- All boolean flags: native JSON boolean
- Soft-delete not applicable: this system stores no user PII, no historical log, and no multi-record collections requiring archival

---

### **NODE: /gate_status**

**Purpose:** Single source of truth for the current physical state of the Raiwala railway crossing gate.

**Ownership:** System-owned. Written exclusively by the Cloud Function service account. Read by all app clients anonymously.

| Field | Type | Nullable | Default | Description |
|-------|------|----------|---------|-------------|
| status | string (enum) | NOT NULL | `"OPEN"` | Current gate state. One of: `"OPEN"`, `"ALERT"`, `"CLOSED"` |
| updated_at | integer (Unix ms) | NOT NULL | ServerValue.TIMESTAMP | Server-set timestamp of last state transition |
| updated_by | string | NOT NULL | `"gateman"` | Static string. No user identity. Confirms write source. |
| previous_status | string (enum) | NOT NULL | `"OPEN"` | State before current transition. Used by Cloud Function for server-side transition validation. |

**Firebase Path:** `/gate_status`

**Constraints:**
- `status` MUST be one of `"OPEN"`, `"ALERT"`, `"CLOSED"`. Any other value is rejected by Cloud Function validation before write.
- `updated_at` is ALWAYS set by the server via `ServerValue.TIMESTAMP`. Client-supplied timestamps are ignored.
- `previous_status` is written atomically alongside `status` in the same Cloud Function update call.
- This node is a single object, not a collection. No child nodes, no array structure.

**Valid State Transitions (server-enforced):**
- `"OPEN"` → `"ALERT"` ✅
- `"ALERT"` → `"CLOSED"` ✅
- `"CLOSED"` → `"OPEN"` ✅
- Any other transition → rejected with HTTP 400 before database write occurs

---

### **NODE: /device_tokens/{token_id}**

**Purpose:** Stores FCM device tokens for all commuter devices that have granted notification permission. Used as a fallback individual-token registry. Primary notification delivery uses FCM topic subscription (`gate-status-alerts`); this node supports future targeted messaging if needed.

**Ownership:** System-owned. Written by Cloud Function on first app launch notification permission grant. Never written by client directly.

> **V1 Decision:** FCM topic-based delivery (`sendToTopic`) is the primary push mechanism. Individual token storage in this node is maintained for operational visibility and future V2 targeted use. Topic subscription is handled client-side via FCM SDK; token registration to this node is handled via a Cloud Function HTTPS callable.

| Field | Type | Nullable | Default | Description |
|-------|------|----------|---------|-------------|
| token | string | NOT NULL | — | FCM registration token for the device |
| registered_at | integer (Unix ms) | NOT NULL | ServerValue.TIMESTAMP | Timestamp when token was first registered |
| last_seen_at | integer (Unix ms) | NOT NULL | ServerValue.TIMESTAMP | Updated on each app open. Used to prune stale tokens. |
| platform | string | NOT NULL | `"android"` | Always `"android"` in V1. |
| is_active | boolean | NOT NULL | `true` | Set to `false` when FCM returns `messaging/registration-token-not-registered` error. |

**Firebase Path:** `/device_tokens/{token_id}`

Where `{token_id}` is a Firebase push ID (generated server-side when token is first registered).

**Indexes:**
- Query by `token` string to detect duplicate registration before insert.
- Query by `is_active` = false for token pruning (operational, not V1 automated).

**Constraints:**
- Duplicate token strings are rejected at Cloud Function layer. If a token already exists in this node, `last_seen_at` is updated instead of creating a new record.
- Tokens flagged `is_active: false` are never included in FCM individual-send operations.

---

### **NODE: /app_config**

**Purpose:** System configuration readable by all clients. Holds values the app needs at runtime without hardcoding. No user data.

**Ownership:** System-owned. Written only by the developer via Firebase console or deploy script. Never written by any app client or Cloud Function.

| Field | Type | Nullable | Default | Description |
|-------|------|----------|---------|-------------|
| current_version | string | NOT NULL | `"1.0.0"` | Current minimum required app version. For future force-upgrade enforcement. |
| gateman_active | boolean | NOT NULL | `true` | Whether the gateman is currently operating. If `false`, commuter UI shows "Service temporarily unavailable." |
| notification_topic | string | NOT NULL | `"gate-status-alerts"` | FCM topic name used for push fan-out. Stored here so it can be changed without app update. |

**Firebase Path:** `/app_config`

---

### **RELATIONSHIP MAP**

```
/gate_status (1)  ──── triggers ────  Cloud Function (onValueWritten)
      │                                        │
      │ read by                                │ sends to
      ▼                                        ▼
Commuter Android App                    FCM Topic: gate-status-alerts
(StreamBuilder listener)                        │
                                               │ delivers to
                                               ▼
                                    All subscribed commuter devices

/device_tokens/{id}  ──── registered via ────  Cloud Function (HTTPS callable)
                                                        ▲
                                                        │ calls on first launch
                                               Commuter Android App

/app_config  ──── read by ────  Commuter Android App (on launch)
```

**Relationship explanations:**
- `/gate_status` is the system's single source of truth. It is read by commuter apps via persistent Firebase SDK listener and written exclusively by the Cloud Function service account.
- The Cloud Function is triggered by every write to `/gate_status` and fans out push notifications to all FCM topic subscribers.
- `/device_tokens` is populated via a separate HTTPS callable Cloud Function invoked once per device on first notification permission grant.
- `/app_config` is a read-only config node; no app client writes to it under any condition.

---

## **2. SECURITY & PERMISSIONS**

### **Firebase Security Rules**

> Firebase Realtime Database Security Rules replace PostgreSQL RLS in this stack.

```json
{
  "rules": {
    "gate_status": {
      ".read": true,
      ".write": true // TEMPORARY — revert to false when Blaze plan is enabled and Cloud Functions are deployed
    },
    "device_tokens": {
      ".read": false,
      ".write": false
    },
    "app_config": {
      ".read": true,
      ".write": false
    }
  }
}
```

**Rule explanations:**

#### **`/gate_status`**
- **READ:** Public. Any anonymous client can read the current gate status. No authentication required.
- **WRITE:** Denied to all clients (`.write: false`). Writes occur exclusively via Cloud Function using the Firebase Admin SDK, which bypasses Security Rules entirely. No Android client — gateman or commuter — can write directly to this node.

#### **`/device_tokens`**
- **READ:** Denied to all clients. Token data is never exposed to any Android app. Readable only via Firebase Admin SDK in Cloud Functions.
- **WRITE:** Denied to all clients. Token registration is handled via HTTPS callable Cloud Function only.

#### **`/app_config`**
- **READ:** Public. Any anonymous client can read app configuration values.
- **WRITE:** Denied to all clients. Developer writes via Firebase console only.

---

### **Gateman Access Control**

Gateman authentication is entirely local, on-device. No Firebase Auth is used.

- **Mechanism:** 5 rapid taps on app logo within 2 seconds → 4-digit PIN entry screen
- **PIN storage:** Hardcoded string constant in `lib/config/secrets.dart`. File is excluded from version control via `.gitignore`.
- **PIN validation:** On-device string comparison only. No network call. No Firebase involvement.
- **Session:** No persistent session token. Admin screen access is granted for the duration of the app session only. Backgrounding the app resets access to public dashboard.
- **Wrong PIN behavior:** Error message displayed. Input cleared. Retry permitted immediately. No lockout in V1.
- **Security boundary:** The gateman admin screen produces HTTPS callable invocations to Cloud Functions. The Cloud Functions validate state transitions server-side. Even if the admin screen were accessed by an unauthorized user, they cannot produce an invalid state transition — the server rejects it.

---

## **3. SERVER-SIDE LOGIC**

### **Cloud Function 1: `onGateStatusWrite`**

**Trigger:** Firebase Realtime Database `onValueWritten` on path `/gate_status`
**Runtime:** Node.js 18
**Purpose:** Fan out FCM push notifications to all topic subscribers when gate status changes.

**Execution logic:**
1. Read `data.after.val()` to get new status object.
2. Read `data.before.val()` to get previous status.
3. If `data.after.val()` is null (deletion): abort silently. Gate status node must never be deleted.
4. If `newStatus.status === previousStatus.status`: abort. No state change occurred (e.g., only `updated_at` was refreshed). Do not send notification.
5. Select FCM notification payload based on `newStatus.status`:
   - `"ALERT"` → title: `"⚠️ Raiwala Gate — Train Coming"`, body: `"Gate closing soon. Plan your route now."`
   - `"CLOSED"` → title: `"🔴 Raiwala Gate Closed"`, body: `"Gate is closed. Expect delays."`
   - `"OPEN"` → title: `"🟢 Raiwala Gate Open"`, body: `"Gate is open. You can proceed."`
6. Call FCM `sendToTopic("gate-status-alerts", payload)`.
7. Log FCM message ID on success. Log error on failure (notification loss is acceptable in V1; no retry).

**Failure behavior:** If FCM call fails, the database write already succeeded. Status is correct in app. Notification is lost for that event. No retry in V1. Error is logged to Firebase Function logs.

---

### **Cloud Function 2: `updateGateStatus` (HTTPS Callable)**

**Trigger:** HTTPS callable invoked by gateman Android app on admin button press
**Runtime:** Node.js 18
**Auth Required:** None (Firebase Auth not used). Caller identity is not verified at auth layer.
**Security:** Enforced by server-side state transition validation (see below). Without a valid current state, no write proceeds.

**Request payload (from Flutter app):**
```json
{
  "requested_status": "ALERT"
}
```

**Execution logic:**
1. Validate `requested_status` is one of `["OPEN", "ALERT", "CLOSED"]`. If not → return HTTP 400: `"Invalid status value"`.
2. Read current `/gate_status` node from database using Admin SDK.
3. Validate transition is legal:
   - Current `"OPEN"` + requested `"ALERT"` → allowed
   - Current `"ALERT"` + requested `"CLOSED"` → allowed
   - Current `"CLOSED"` + requested `"OPEN"` → allowed
   - Any other combination → return HTTP 400: `"Invalid state transition. Expected [X], got [Y]."`
4. Write to `/gate_status`:
   ```json
   {
     "status": "<requested_status>",
     "updated_at": "<ServerValue.TIMESTAMP>",
     "updated_by": "gateman",
     "previous_status": "<current_status>"
   }
   ```
5. Return HTTP 200: `{ "success": true, "new_status": "<requested_status>" }`.

**Error states:**
- `400` — Invalid status value or illegal state transition
- `500` — Firebase Admin SDK read/write failure

**Rate limit:** None in V1. Firebase free tier callable invocations are far beyond V1 traffic at this crossing frequency.

---

### **Cloud Function 3: `registerDeviceToken` (HTTPS Callable)**

**Trigger:** HTTPS callable invoked by commuter Android app on first launch after notification permission is granted
**Runtime:** Node.js 18
**Auth Required:** None.

**Request payload:**
```json
{
  "fcm_token": "<device_fcm_token_string>"
}
```

**Execution logic:**
1. Validate `fcm_token` is a non-empty string. If not → return HTTP 400.
2. Query `/device_tokens` where `token == fcm_token`.
3. If token exists: update `last_seen_at` to `ServerValue.TIMESTAMP`. Return HTTP 200: `{ "status": "updated" }`.
4. If token does not exist: create new node at `/device_tokens/{push_id}`:
   ```json
   {
     "token": "<fcm_token>",
     "registered_at": "<ServerValue.TIMESTAMP>",
     "last_seen_at": "<ServerValue.TIMESTAMP>",
     "platform": "android",
     "is_active": true
   }
   ```
5. Return HTTP 200: `{ "status": "registered" }`.

**Error states:**
- `400` — Missing or empty token string
- `500` — Firebase Admin SDK failure

---

### **State Machine — Server-Enforced Transitions**

The gate state machine has exactly 3 states and 3 transitions. All transition validation occurs in `updateGateStatus` Cloud Function. The client never enforces transitions as a security measure — client UI is a convenience layer only.

```
        ┌─────────────────────────────────┐
        │                                 │
        ▼                                 │
     [OPEN] ──── gateman presses ────► [ALERT]
                  "Train Coming"              │
                                             │ gateman presses
                                             │ "Gate Closed"
                                             ▼
                                         [CLOSED]
                                             │
                                             │ gateman presses
                                             │ "Gate Opened"
                                             │
                                        back to [OPEN]
```

**Initial state:** `/gate_status.status` is seeded as `"OPEN"` at project setup. This seed write is performed once via Firebase console by the developer.

**Out-of-sequence press behavior:** If gateman's app somehow sends a non-sequential state (e.g., network desync causes stale UI state), the Cloud Function reads the authoritative current state from the database, detects the illegal transition, and returns HTTP 400. The app displays an error and re-reads the current state from the database to resync the button UI.

---

## **4. AUTH & ONBOARDING FLOW**

### **Commuter Onboarding (First Launch)**

1. App launches → Firebase SDK initializes → `/gate_status` listener attaches → current status rendered immediately.
2. App checks Android notification permission status.
3. If permission not yet requested: show FCM permission prompt (Android 13+ `POST_NOTIFICATIONS`).
4. On permission granted:
   a. FCM SDK generates device token.
   b. App subscribes device to topic `gate-status-alerts` via FCM SDK (`subscribeToTopic`).
   c. App calls `registerDeviceToken` Cloud Function with the FCM token.
5. On permission denied: app continues functioning as status-only viewer. No notification subscription. No token registration. No error shown to user.

### **Gateman Access (Each Session)**

1. Gateman opens app → lands on public commuter dashboard (same as all users).
2. Gateman taps app logo 5 times rapidly within 2 seconds → PIN screen appears.
3. Gateman enters 4-digit PIN → on-device comparison against constant in `secrets.dart`.
4. On correct PIN: admin screen shown. Firebase Realtime Database listener remains active.
5. Admin screen reads `/gate_status.status` and renders the single next-valid-action button.
6. On button press: `updateGateStatus` HTTPS callable is invoked.
7. On successful response: button cycles to next state. On error response: error message shown, current state re-read from database.

### **Default Values at System Initialization**

| Entity | Field | Default Value | Reason |
|--------|-------|---------------|--------|
| /gate_status | status | `"OPEN"` | Physical gate is open by default between trains |
| /gate_status | updated_by | `"gateman"` | Static — no user identity system exists |
| /gate_status | previous_status | `"OPEN"` | Seeded to match initial status |
| /device_tokens/{id} | platform | `"android"` | V1 is Android-only |
| /device_tokens/{id} | is_active | `true` | All freshly registered tokens are active |
| /app_config | gateman_active | `true` | Service is active at launch |

### **System-Initiated Actions**

- On every write to `/gate_status`: `onGateStatusWrite` Cloud Function fires automatically and sends FCM push notification to all topic subscribers.
- On commuter first launch with permission granted: `registerDeviceToken` Cloud Function records the device token.
- No scheduled cron jobs in V1. No time-based automation exists.

---

## **5. SEED / EXAMPLE DATA**

### **NODE: /gate_status (Seed — written once at project setup)**

```json
{
  "status": "OPEN",
  "updated_at": 1713340800000,
  "updated_by": "gateman",
  "previous_status": "OPEN"
}
```

*This is the single record that exists at all times. It is never deleted, only updated in place.*

---

### **NODE: /device_tokens (Example records after 3 commuter installs)**

```
/device_tokens/
  ├── -NxA1bcd2ef3gh4ij5kl/
  │     token: "dGhpcyBpcyBhIGZha2UgdG9rZW4x..."
  │     registered_at: 1713340900000
  │     last_seen_at: 1713427300000
  │     platform: "android"
  │     is_active: true
  │
  ├── -NxA6mno7pq8rs9tu0vw/
  │     token: "dGhpcyBpcyBhIGZha2UgdG9rZW4y..."
  │     registered_at: 1713341200000
  │     last_seen_at: 1713341200000
  │     platform: "android"
  │     is_active: true
  │
  └── -NxA2xyz3abc4def5ghi/
        token: "dGhpcyBpcyBhIGZha2UgdG9rZW4z..."
        registered_at: 1713255600000
        last_seen_at: 1713255600000
        platform: "android"
        is_active: false
```

*Third record shows a deactivated token (device uninstalled app or FCM returned registration error). `is_active: false` prevents this token from being used in any future individual-send operations.*

---

### **NODE: /app_config (Seed — written once at project setup)**

```json
{
  "current_version": "1.0.0",
  "gateman_active": true,
  "notification_topic": "gate-status-alerts"
}
```

---

## **6. API ENDPOINT CONTRACTS**

> Firebase auto-generated CRUD is not applicable here — all reads use the Firebase Realtime Database SDK listener directly. Only custom Cloud Function callables are defined below.

---

### **POST `updateGateStatus` (HTTPS Callable)**

- **Purpose:** Advances gate state by one step in the fixed cycle (OPEN → ALERT → CLOSED → OPEN). Writes new state to `/gate_status`. Triggers `onGateStatusWrite` automatically.
- **Auth Required:** No Firebase Auth. Caller identity not verified. Security enforced via server-side state transition validation.
- **Request Payload:**
  ```json
  {
    "requested_status": "ALERT"
  }
  ```
- **Response Payload (Success):**
  ```json
  {
    "success": true,
    "new_status": "ALERT"
  }
  ```
- **Error States:**
  - `400` — `requested_status` not in `["OPEN", "ALERT", "CLOSED"]`
  - `400` — Transition is illegal given current database state (e.g., OPEN → CLOSED attempted)
  - `500` — Firebase Admin SDK read or write failure
- **Rate Limit / Caching:** No rate limit in V1. No caching. Each call reads live database state.

---

### **POST `registerDeviceToken` (HTTPS Callable)**

- **Purpose:** Registers or refreshes a commuter device FCM token in `/device_tokens`. Called once per device on first notification permission grant and on subsequent app launches to keep `last_seen_at` current.
- **Auth Required:** No.
- **Request Payload:**
  ```json
  {
    "fcm_token": "eHh4eHh4eHh4eHh4eHh4eHh4..."
  }
  ```
- **Response Payload (Success):**
  ```json
  {
    "status": "registered"
  }
  ```
  or
  ```json
  {
    "status": "updated"
  }
  ```
- **Error States:**
  - `400` — `fcm_token` is missing, null, or empty string
  - `500` — Firebase Admin SDK failure
- **Rate Limit / Caching:** No rate limit in V1. Called at most once per app session per device.

---

### **Firebase Realtime Database Listener (SDK — not HTTP)**

- **Path:** `/gate_status`
- **Purpose:** Real-time gate status delivery to commuter dashboard. Persistent WebSocket connection maintained by Firebase SDK.
- **Auth Required:** No. Public read.
- **Behavior:** `onValue` listener fires immediately on attach (serves cached or live value) and on every subsequent write to `/gate_status`. No polling. No HTTP call.
- **Offline behavior:** Firebase SDK serves last cached value from disk persistence (`setPersistenceEnabled(true)`). Commuter sees last known status with stale timestamp and connectivity banner until connection restores.

---

## **SCHEMA INTEGRITY DECLARATION**

This schema is AUTHORITATIVE.

All downstream systems must:
- Use these exact node paths and field definitions
- Implement Firebase Security Rules exactly as specified above
- Never bypass Security Rules by writing to `/gate_status` or `/device_tokens` from any Android client
- Never execute state transition validation on the client — all transition logic runs in `updateGateStatus` Cloud Function
- Never store data not defined in this schema without explicit schema revision
- Keep `secrets.dart` (containing hardcoded PIN) permanently excluded from version control

---