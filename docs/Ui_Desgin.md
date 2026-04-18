# UI DESIGN SYSTEM

**Generated:** April 18, 2026
**Source:** BACKEND_SCHEMA.md + ARCHITECTURE_BLUEPRINT.md
**Status:** AUTHORITATIVE — All downstream systems must obey this design system
**Tech Stack:** Flutter (Dart) — Android-only, Material Design 3 base, custom token overrides

---

## **1. GLOBAL DESIGN TOKENS**

### **Color System**

> Flutter does not use Tailwind. All tokens below are defined as Flutter `Color` hex values with Tailwind-scale naming for conceptual reference. Implementation maps these directly to `ThemeData` and `ColorScheme`.

**Primary Brand (Saffron-Orange — railway signal, urgency, action):**
- Primary: `#E65100` (orange-800)
- Primary Hover / Ripple: `#BF360C` (deep-orange-900)
- Primary Active: `#BF360C`
- Primary Subtle (backgrounds): `#FBE9E7` (deep-orange-50)

**Neutral & Surface:**
- Page Background: `#F5F5F5` (gray-100)
- Card / Panel Background: `#FFFFFF` (white)
- Border Default: `#E0E0E0` (gray-300)
- Border Focus: `#E65100` (primary)
- Text Primary: `#212121` (gray-900)
- Text Secondary: `#757575` (gray-600)
- Text Disabled: `#BDBDBD` (gray-400)

**Semantic Colors (Gate Status — these are the core semantic system):**
- OPEN / Success: `#2E7D32` (green-800)
- OPEN Subtle (bg): `#E8F5E9` (green-50)
- OPEN Border: `#A5D6A7` (green-200)
- ALERT / Warning: `#E65100` (deep-orange-800)
- ALERT Subtle (bg): `#FFF3E0` (orange-50)
- ALERT Border: `#FFCC80` (orange-200)
- CLOSED / Danger: `#C62828` (red-800)
- CLOSED Subtle (bg): `#FFEBEE` (red-50)
- CLOSED Border: `#EF9A9A` (red-200)
- Info: `#1565C0` (blue-800)
- Info Subtle (bg): `#E3F2FD` (blue-50)

**Offline / Stale State:**
- Offline Banner Background: `#37474F` (blue-gray-800)
- Offline Banner Text: `#FFFFFF`
- Stale Timestamp Text: `#F57C00` (orange-700)

---

### **Typography**

- **Font Family:** Noto Sans (bundled — handles Devanagari and Latin; critical for Raiwala locale)
- **Display:** 48sp, weight 700 — Gate status label text (OPEN / ALERT / CLOSED) on commuter dashboard
- **Heading 1:** 24sp, weight 700 — Screen titles
- **Heading 2:** 20sp, weight 600 — Section headers, admin button label
- **Heading 3:** 16sp, weight 600 — Card titles, modal headings
- **Body Large:** 16sp, weight 400 — Primary body text, descriptions
- **Body Default:** 14sp, weight 400 — Secondary body, list items, metadata
- **Body Small:** 12sp, weight 400 — Captions, helper text, labels
- **Timestamp:** 12sp, weight 400, color Text Secondary — Last-updated display
- **PIN Input:** 32sp, weight 700, monospace (Noto Sans Mono) — PIN digit display

---

### **Spacing & Radius**

- **Base Unit:** 8px — all spacing is multiples of 8
- **Spacing Scale:** 4, 8, 12, 16, 24, 32, 48px
- **Border Radius Default:** 12px (`rounded-xl` equivalent) — cards, status card
- **Border Radius Small:** 8px (`rounded-lg`) — badges, chips, buttons
- **Border Radius Large:** 16px (`rounded-2xl`) — bottom sheets, modals
- **Border Radius Full:** 9999px — pill badges, FAB
- **Shadow Default:** `elevation: 2` (Flutter Material — subtle card lift)
- **Shadow Elevated:** `elevation: 6` (bottom sheets, modals)
- **Minimum Touch Target:** 48×48px on all interactive elements — no exceptions

---

## **2. CORE COMPONENTS**

### **GATE STATUS CARD**

This is the primary UI component of the entire app. It occupies the full width and center of the commuter dashboard.

#### **Status: OPEN**
- Background: `#E8F5E9` (OPEN Subtle)
- Border: 2px solid `#A5D6A7` (OPEN Border)
- Border Radius: 16px
- Status Icon: Filled checkmark circle, 48×48px, color `#2E7D32`
- Status Label: "GATE OPEN" — Display (48sp, weight 700), color `#2E7D32`
- Subtitle: "Road is clear — proceed normally" — Body Default, color Text Secondary
- Timestamp: "Updated [relative time]" — Timestamp style, color Text Secondary
- Padding: 32px all sides
- Shadow: elevation 2

#### **Status: ALERT**
- Background: `#FFF3E0` (ALERT Subtle)
- Border: 2px solid `#FFCC80` (ALERT Border)
- Status Icon: Filled warning triangle, 48×48px, color `#E65100`
- Status Label: "⚠ TRAIN COMING" — Display (48sp, weight 700), color `#E65100`
- Subtitle: "Gate closing soon — plan your route" — Body Default, color Text Secondary
- Timestamp: Timestamp style
- Animation: Subtle pulse animation on the status icon — 1.5s loop, scale 1.0→1.08→1.0, only while ALERT is active

#### **Status: CLOSED**
- Background: `#FFEBEE` (CLOSED Subtle)
- Border: 2px solid `#EF9A9A` (CLOSED Border)
- Status Icon: Filled X circle, 48×48px, color `#C62828`
- Status Label: "GATE CLOSED" — Display (48sp, weight 700), color `#C62828`
- Subtitle: "Wait or take an alternate route" — Body Default, color Text Secondary
- Timestamp: Timestamp style

---

### **ADMIN ACTION BUTTON**

The single full-screen button on the gateman admin screen. One button is visible at a time.

#### **Button: Train Coming (Alert)**
- Background: `#E65100` (Primary)
- Text: "TRAIN COMING" — Heading 1 (24sp, weight 700), color `#FFFFFF`
- Sub-label: "Tap when train is ~10 min away" — Body Small, color `rgba(255,255,255,0.75)`
- Icon: Warning triangle icon, 48×48px, color `#FFFFFF`, centered above text
- Width: Full screen width minus 32px horizontal padding
- Height: 160px minimum
- Border Radius: 16px
- Ripple color: `#BF360C`
- Haptic: Heavy impact on press

#### **Button: Gate Closed**
- Background: `#C62828`
- Text: "GATE CLOSED" — same spec as above
- Sub-label: "Tap when gate is physically closed"
- Icon: Lock icon, 48×48px, color `#FFFFFF`
- Haptic: Heavy impact on press

#### **Button: Gate Opened**
- Background: `#2E7D32`
- Text: "GATE OPENED" — same spec as above
- Sub-label: "Tap when gate is open again"
- Icon: Checkmark circle icon, 48×48px, color `#FFFFFF`
- Haptic: Heavy impact on press

**Loading state (after press, awaiting Cloud Function response):**
- Button opacity: 0.6
- Spinner: 24px white CircularProgressIndicator centered on button
- Button disabled: true — no second press accepted during network call

**Error state (after Cloud Function returns error):**
- Button returns to full opacity and enabled state
- Error snackbar appears (see Snackbar component)

---

### **OFFLINE BANNER**

Appears at the top of the commuter dashboard when Firebase SDK reports no connectivity.

- Background: `#37474F`
- Text: "Offline — showing last known status" — Body Small, color `#FFFFFF`
- Icon: WiFi-off icon, 16px, color `#FFFFFF`, left of text
- Height: 36px
- Width: Full screen width
- Position: Below the device status bar (respects top safe area)
- Animation: Slides down from top when connectivity is lost, slides back up when restored

---

### **PIN ENTRY SCREEN**

Shown after the 5-tap tap sequence on the app logo. Full-screen modal sliding up from bottom.

**Layout (top to bottom):**
1. "Gateman Access" — Heading 2, centered, top padding 48px
2. "Enter PIN" — Body Default, color Text Secondary, centered
3. PIN display row: 4 circles, 20×20px each, spaced 16px apart
   - Empty: border 2px `#E0E0E0`, fill transparent
   - Filled: fill `#212121`, no border
   - Centered horizontally, top margin 32px
4. Numeric keypad: 3×4 grid (1–9, *, 0, backspace)
   - Each key: 72×72px, border radius 36px (circle), Body Large (16sp, weight 500)
   - Default background: `#F5F5F5`
   - Pressed background: `#E0E0E0`
   - Backspace key: backspace icon, same sizing
   - Grid spacing: 16px horizontal, 12px vertical
5. Error message row: "Incorrect PIN. Try again." — Body Small, color `#C62828`, centered, height 24px (invisible when no error, visible on wrong PIN)
6. "Cancel" text button — Body Default, color Text Secondary, centered, bottom 32px

**Behavior:**
- PIN auto-submits on 4th digit entry — no submit button
- On wrong PIN: error message appears, all 4 circles clear, haptic error feedback (notification vibration pattern)
- On correct PIN: screen dismisses, admin screen shown, haptic success feedback (light impact)

---

### **SNACKBAR (Error / Success Feedback)**

- Position: Bottom of screen, above bottom safe area inset, 16px horizontal margin
- Border Radius: 8px
- Duration: 4 seconds, then auto-dismiss
- Shadow: elevation 4
- Max width: full width minus 32px

**Success variant:**
- Background: `#2E7D32`
- Text: Body Default, color `#FFFFFF`
- Icon: Checkmark, 16px, `#FFFFFF`

**Error variant:**
- Background: `#C62828`
- Text: Body Default, color `#FFFFFF`
- Icon: Warning, 16px, `#FFFFFF`

**Offline variant:**
- Background: `#37474F`
- Text: Body Default, color `#FFFFFF`

---

### **APP LOGO (Tap Target for Admin Entry)**

- Position: Centered at top of commuter dashboard, top padding 24px
- Size: 64×64px visible, 88×88px touch target (extended tap area using GestureDetector padding)
- Design: Orange locomotive icon on white circular background, 2px border `#E65100`
- Tap counter: invisible — counts rapid taps in background, no visual indication until PIN screen appears
- Tap window: 5 taps within 2000ms triggers PIN screen

---

## **3. LAYOUT & APP SHELL**

### **App Shell Structure — Android Mobile**

- **Navigation:** No bottom tab bar. Single-screen app for commuters. Admin screen is a full-screen overlay. No persistent navigation elements.
- **Top Bar:** Custom app bar — NOT standard Material AppBar
  - Height: 56px + top safe area inset
  - Background: `#FFFFFF`
  - Bottom border: 1px `#E0E0E0`
  - Left: App logo (64×64px, tap target for admin access)
  - Center: "Raiwala Crossing" — Heading 3, color Text Primary
  - Right: Notification bell icon, 24×24px, color Text Secondary (decorative in V1 — no action)
- **Transitions:**
  - PIN screen: slides up from bottom (Material bottom sheet animation, 300ms ease-out)
  - Admin screen: replaces PIN screen in place (fade transition, 200ms)
  - Return to dashboard: admin screen slides down, dashboard revealed (300ms ease-in)
- **Safe Area:** All content respects Android system insets (status bar top, navigation bar bottom)

### **Main Content Area — Commuter Dashboard**

- Padding: 16px horizontal, 16px top (below app bar), 24px bottom (above nav bar inset)
- Background: `#F5F5F5`
- Scroll: SingleChildScrollView — content rarely exceeds screen height, but must not clip on small devices

### **Admin Screen Overlay**

- Background: `#FFFFFF` full screen
- No app bar — admin screen occupies entire screen
- Top content: "Gateman Control" label — Heading 2, color Text Primary, top padding = status bar height + 24px, left padding 24px
- Current status row (read-only): small status badge showing current gate state, Body Default, top margin 8px, left padding 24px
- Action button: centered vertically in remaining screen space, 32px horizontal padding
- Bottom: "Exit Admin" text button — Body Default, color Text Secondary, bottom padding = nav bar inset + 16px, centered

---

## **4. KEY SCREENS & PAGE LAYOUTS**

### **Screen 1: Commuter Dashboard (Public)**

**Route:** App launch → immediate landing screen (no navigation required)

**Purpose:** Display real-time gate status so commuter can decide whether to proceed, wait, or reroute.

**Access:** All users, no authentication, no gating.

**Layout (top to bottom):**
```
┌─────────────────────────────────────┐
│  [LOGO]   Raiwala Crossing    [🔔]  │  ← App Bar (56px)
├─────────────────────────────────────┤
│  [OFFLINE BANNER — conditional]     │  ← 36px, only when offline
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │      [STATUS ICON 48px]       │  │
│  │                               │  │
│  │      GATE OPEN                │  │  ← Gate Status Card
│  │    Road is clear              │  │    (full width, center)
│  │    Updated 2 min ago          │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  ℹ Tap the logo 5× for       │  │  ← Info Card (gateman hint)
│  │    gateman access             │  │    hidden in production build
│  └───────────────────────────────┘  │
│                                     │
│  [Page background fills remainder]  │
└─────────────────────────────────────┘
```

**Components Used:**
- App Bar: top navigation and logo tap target
- Offline Banner: conditional, above all content
- Gate Status Card: primary display, full-width, color-coded by `/gate_status.status`
- Snackbar: shown on FCM notification received while app is open (foreground notification replacement)

**Data Source:**
- Node: `/gate_status`
- Fields displayed: `status` (drives card color and label), `updated_at` (formatted as relative time: "Updated X min ago"), `gateman_active` from `/app_config` (if `false`, card shows "Service temporarily unavailable" in neutral gray instead of status)

**Relative time formatting:**
- < 60 seconds: "Updated just now"
- 1–59 minutes: "Updated X min ago"
- ≥ 60 minutes: "Updated [HH:MM]" (24h format, IST)

**Actions Available:**
- None. Commuter screen is read-only. All updates arrive via Firebase stream or FCM push.

**Empty State:** Not applicable — `/gate_status` always has a value (seeded at setup).

**Loading State:**
- Gate Status Card shows skeleton placeholder: gray rounded rect 180px height, animated shimmer (left-to-right gradient sweep, 1.2s loop)
- Skeleton shown for maximum 3 seconds; if stream delivers data sooner, skeleton dismisses immediately

**Offline State:**
- Offline banner visible
- Gate Status Card shows last cached value with stale timestamp text color `#F57C00`
- "Updated [HH:MM] — last known" replaces standard relative time

---

### **Screen 2: PIN Entry (Gateman Access Gate)**

**Route:** Triggered by 5-tap sequence on app logo — overlays dashboard

**Purpose:** Authenticate gateman via local PIN before revealing admin controls.

**Access:** Any physical user of the device (security by obscurity + PIN).

**Layout:** Described fully in PIN Entry Screen component above.

**Data Source:** No data source. Local only. Compares entered digits against constant in `secrets.dart`.

**Actions Available:**
- Enter digit (1–9, 0): adds digit to PIN display
- Backspace: removes last digit
- Cancel: dismisses PIN screen, returns to dashboard
- Auto-submit on 4th digit

**Empty State:** Not applicable.

**Loading State:** Not applicable (no network call at this stage).

**Error State:** "Incorrect PIN. Try again." — red text below PIN circles, circles cleared.

---

### **Screen 3: Gateman Admin Screen**

**Route:** Shown after correct PIN entry — replaces PIN screen overlay

**Purpose:** Allow gateman to advance gate state by one step in the fixed cycle.

**Access:** PIN-authenticated session only.

**Layout (top to bottom):**
```
┌─────────────────────────────────────┐
│  Gateman Control              [top] │  ← Heading 2, left-aligned
│  Current: ● GATE OPEN         [st] │  ← Current status badge, read-only
├─────────────────────────────────────┤
│                                     │
│                                     │
│  ┌───────────────────────────────┐  │
│  │  [WARNING ICON 48px]          │  │
│  │                               │  │
│  │      TRAIN COMING             │  │  ← Admin Action Button
│  │  Tap when train is ~10 min   │  │    (next valid action only)
│  │       away                    │  │
│  └───────────────────────────────┘  │
│                                     │
│                                     │
│           [Exit Admin]              │  ← Text button, bottom
└─────────────────────────────────────┘
```

**Components Used:**
- Heading 2 label: "Gateman Control"
- Status badge (read-only, Body Small): current `/gate_status.status` shown as color-coded pill
- Admin Action Button: full-width, 160px height, color and label determined by next valid state in cycle
- Exit Admin text button

**Data Source:**
- Node: `/gate_status`
- Fields read: `status` — determines which button is rendered
  - Current `"OPEN"` → renders "TRAIN COMING" button (orange)
  - Current `"ALERT"` → renders "GATE CLOSED" button (red)
  - Current `"CLOSED"` → renders "GATE OPENED" button (green)

**Actions Available:**
- Press Admin Action Button:
  1. Button enters loading state (disabled, spinner, 0.6 opacity)
  2. Flutter app calls `updateGateStatus` HTTPS callable with `requested_status`
  3. On success (HTTP 200): button loading clears, button cycles to next state, success snackbar: "Status updated to [NEW STATE]"
  4. On error (HTTP 400 or 500): button loading clears, button stays on same state, error snackbar: "Update failed — tap again to retry"
- Exit Admin: dismisses admin overlay, returns to commuter dashboard

**Empty State:** Not applicable.

**Loading State:** Button loading state as described in Admin Action Button component.

**Error State:** Snackbar error, button re-enabled for retry. No state change occurs on server error (idempotent retry is safe).

---

### **SCREEN NAVIGATION MAP**

```
[App Launch]
     │
     ▼
[Commuter Dashboard] ◄────────────────────────────────┐
     │                                                 │
     │  5 rapid taps on logo                           │
     ▼                                                 │
[PIN Entry Screen]                                     │
     │                                                 │
     ├── Wrong PIN → error, stay on PIN screen         │
     │                                                 │
     └── Correct PIN                                   │
           │                                           │
           ▼                                           │
     [Gateman Admin Screen]                            │
           │                                           │
           ├── Press action button → Cloud Function    │
           │     → Database write → stream updates     │
           │     dashboard in real time                │
           │                                           │
           └── "Exit Admin" ──────────────────────────┘
```

**Navigation rules:**
- Commuter dashboard is the permanent base. No other screens replace it entirely for commuters.
- PIN screen and Admin screen are overlays that appear above the dashboard.
- Dismissing admin screen at any point returns to the live dashboard — the Firebase stream listener is maintained throughout all overlay states.
- FCM push notifications received while the app is foregrounded display as in-app snackbars (not system notifications) showing the new gate status text.

---

## **5. UX INTERACTIONS & STATES**

### **Loading States**

- **App Cold Start (data not yet cached):** Gate Status Card shows shimmer skeleton — gray rounded rect, 180px height, shimmer animation (1.2s left-to-right sweep)
- **App Cold Start (cached data available):** Firebase disk persistence serves cached value instantly — skeleton not shown; live update replaces cached value within ~1 second when connection establishes
- **Admin Button Press:** Button disabled, 0.6 opacity, 24px white CircularProgressIndicator centered on button, 300ms timeout minimum display (prevents flash)
- **PIN auto-submit:** No loading state — comparison is instantaneous on-device

### **Empty States**

Not applicable in V1. The single `/gate_status` node always contains data (seeded at setup). No list views, no collections, no empty collections.

### **Error States**

#### **Inline Errors (PIN Screen)**
- Position: Below PIN circles, above keypad
- Color: `#C62828`
- Text: "Incorrect PIN. Try again."
- Display: Appears on wrong PIN entry, cleared on first new digit press

#### **Snackbar Notifications**
- Position: Bottom of screen, 16px from bottom safe area edge, 16px horizontal margins
- Duration: 4 seconds auto-dismiss
- Success: green background `#2E7D32`, white text
- Error: red background `#C62828`, white text
- Stacking: Maximum 1 visible at a time — new snackbar replaces current if one is already showing

#### **Cloud Function Error (Admin Button)**
- Snackbar: "Update failed — tap again to retry"
- Button re-enabled immediately after error snackbar appears
- No state change written to database (Cloud Function rejected before write)

#### **Page-Level Error (Stream connection failure beyond cached state):**
- Gate Status Card text replaced with: "Unable to reach server"
- Subtitle: "Check your connection"
- Status icon: gray cloud-off icon
- Offline banner shown simultaneously if connectivity is confirmed absent

### **Success Feedback**

- **Admin button press (any state transition):** Snackbar: "Gate status updated to [ALERT / CLOSED / OPEN]" — green background, 4 seconds
- **No navigation after success** — admin remains on screen, button cycles to next state, ready for next press

### **Confirmation Patterns**

- **No destructive actions exist in V1** — no delete, no reset, no irreversible UI action requiring modal confirmation
- **Exit Admin:** No confirmation required — tapping "Exit Admin" immediately dismisses the admin screen. Status is already committed to server on button press; there is nothing unsaved to warn about.
- **Navigation away with unsaved changes:** Not applicable — no forms, no draft states

### **Hover & Focus States**

- **Touch ripple:** All buttons and interactive elements use Material InkWell ripple — color matches button's pressed/active variant
- **Focus (accessibility):** Flutter's default focus indicator preserved — visible blue focus border on all interactive elements for accessibility navigation
- **Tap feedback:** All buttons shrink to 0.97 scale on press (AnimatedScale, 80ms) — subtle physical press feel

### **Haptic Feedback**

- **Admin Action Button press (success):** `HapticFeedback.heavyImpact()` — strong confirmation of gate status change
- **Wrong PIN:** `HapticFeedback.vibrate()` — error pattern (two short pulses)
- **Correct PIN:** `HapticFeedback.lightImpact()` — light confirmation
- **Logo 5th tap (PIN screen trigger):** `HapticFeedback.mediumImpact()` — signals secret was recognized

### **Skeleton Loaders**

- **Gate Status Card skeleton:** Single rounded rect placeholder, same dimensions as the real card, background `#E0E0E0`, shimmer overlay animates left-to-right with 60% opacity white gradient, 1.2s linear infinite loop
- **No other skeleton states** exist in V1 — only one data-loading surface

### **Push Notification Handling — UX Behavior**

**App in background or terminated (device locked or minimized):**
- System notification appears in Android notification tray
- Notification title and body as defined in Cloud Function payloads
- Tapping notification: opens app, commuter lands on dashboard showing updated status

**App in foreground (commuter viewing dashboard):**
- System notification suppressed
- In-app snackbar shown instead: "[STATUS ICON] Gate status: [OPEN / TRAIN COMING / CLOSED]"
- Gate Status Card already updated via stream — snackbar is supplementary confirmation only

**App in foreground (gateman on admin screen):**
- System notification suppressed
- No snackbar shown (gateman triggered the event — redundant notification)
- Admin button has already cycled — no additional UI action needed

### **`/app_config.gateman_active` = false — UX Behavior**

When the developer sets `gateman_active` to `false` in Firebase console (e.g., gateman is unavailable):
- Gate Status Card content replaced with gray neutral card:
  - Icon: person-off icon, `#757575`
  - Label: "Service Paused" — Heading 2, color Text Secondary
  - Subtitle: "Gate status updates are temporarily unavailable"
  - Timestamp row hidden
- No push notifications expected during this state
- Offline banner NOT shown (connectivity is fine; service is intentionally paused)

### **Monetization & Paywall UX**

Not applicable in V1. No gated features, no paywall, no locked content.

---

## **DESIGN SYSTEM INTEGRITY DECLARATION**

This design system is AUTHORITATIVE.

All downstream systems must:
- Use these exact color tokens for all gate status representations — green for OPEN, orange for ALERT, red for CLOSED — with no deviation
- Implement the Gate Status Card exactly as specified including animation behavior on ALERT state
- Implement the Admin Action Button at minimum 160px height with 48×48px minimum touch target
- Implement the PIN entry screen with auto-submit on 4th digit — no submit button
- Implement all haptic feedback patterns as specified
- Maintain the 5-tap / 2000ms window for admin access exactly — no deviation in timing
- Display `/app_config.gateman_active = false` state exactly as specified
- Handle all three FCM notification receipt contexts (background, foreground-commuter, foreground-admin) as specified
- Use Noto Sans throughout — no other typeface
- Respect all Android safe area insets for status bar and navigation bar
- Never invent UI patterns not defined in this document
- Never defer visual decisions to implementation time

---