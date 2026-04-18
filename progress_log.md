# Progress Log

---
## Step 1 — Firebase Project Setup (Manual + CLI)
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Created `database.rules.json` containing the secure lock-down rules derived from the backend schema
- Created `firebase.json` configuring the project structure for Realtime Database

**Files Created:**
- `database.rules.json` — Enforces read-only public access and denies all client writes
- `firebase.json` — Points the Firebase deploy to the rules file

**Files Modified:**
- None

**Packages Installed:**
- None

**Verification Result:**
- Manual action required in Firebase Console prior to CLI deployment.
- Rules formulated according to schema and ready to be deployed.
---

## Architecture Change — Spark Plan Adjustment
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Updated architecture documents to accommodate Firebase Spark (free tier) constraints
- Cloud Functions deferred, gate status direct writes enabled with client-side validation

**Files Modified:**
- `docs/Backend_schema.md` — Updated security rules
- `docs/Architecture_Blueprint.md` — Updated flow
- `docs/Implmentation_planner.md` — Modified steps 4-6, added 3B
- `database.rules.json` — Relaxed write access

**Packages Installed:**
- None

**Verification Result:**
- All document updates successfully mapped to the new Spark architecture.
---

## Step 2 — Flutter Project Initialization
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Initialized Flutter Android project via CLI
- Added core Firebase dependencies to pubspec.yaml
- Modified android/app/build.gradle.kts to set minSdk = 21
- Hard-reset lib/main.dart with Firebase and Crashlytics initialization boilerplate

**Files Created:**
- Entire Flutter boilerplate tree
- `lib/main.dart` (overwritten)

**Files Modified:**
- `pubspec.yaml` — added firebase_core, firebase_database, firebase_messaging, firebase_crashlytics
- `android/app/build.gradle.kts` — modified minSdkVersion

**Packages Installed:**
- `firebase_core` — Core init requirement
- `firebase_database` — Realtime Database interaction
- `firebase_messaging` — Push notification handling
- `firebase_crashlytics` — Error reporting

**Verification Result:**
- Flutter tree instantiated.
- `flutter pub get` completed successfully.
- Manual execution of `flutterfire configure` requires user action to complete the loop.
---

## Step 3 — App Theme & Constants
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Defined exact color tokens mapped from UI_DESIGN_SYSTEM (Primary, Secondary, Node Status Colors)
- Implemented Noto Sans typography using google_fonts package
- Created centralized UI spacing and border radius constants
- Created AppConstants separating backend logic from secrets

**Files Created:**
- `lib/theme/app_theme.dart` — All thematic styles and ThemeData generator
- `lib/config/app_constants.dart` — Firebase topic/DB names and tap config

**Files Modified:**
- `pubspec.yaml` — Added `google_fonts`

**Packages Installed:**
- `google_fonts`

**Verification Result:**
- Theme structure is completely established. All required variables match design documentation.
---

## Step 3B — Direct Firebase Write Setup (Spark plan temporary)
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Configured Realtime Database to be writeable from the client side temporarily (Spark tier).
- Registered FirebaseDatabase `setPersistenceEnabled(true)` in `main.dart` before establishing connections, ensuring localized caching of offline writes.

**Files Created:**
- None

**Files Modified:**
- `lib/main.dart` — Appended `firebase_database` setup block.

**Packages Installed:**
- None

**Verification Result:**
- Static compilation passes. The application operates with caching initialized.
---

## Steps 7, 8 & 9 (Combined) — Data Layer Services
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Defined `GateStatusModel` and related status Enum.
- Integrated `GateService` to merge Realtime DB and App Config data into a synchronized reactive stream via RxDart.
- Added strict transition validity rules (OPEN->ALERT->CLOSED->OPEN) directly into client side (Spark temporary workaround).
- Constructed `NotificationService` configured with an HTTP wrapper querying the FCM Legacy/v1 API to dispatch notifications securely bypassing Cloud Functions.

**Files Created:**
- `lib/models/gate_status.dart` 
- `lib/services/gate_service.dart`
- `lib/services/notification_service.dart`
- `lib/config/secrets.dart`

**Files Modified:**
- `pubspec.yaml` (Added `http` & `rxdart`)

**Packages Installed:**
- `http`, `rxdart`

**Verification Result:**
- Models structurally sound. Code static analysis clean. Data architecture ready to plug into UI.
---

## Step 9B — Disclaimer & Terms Legal Screen
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Constructed `DisclaimerScreen` enforcing bilingual legal agreements covering lack of App liability and Railway disassociation.
- Wired asynchronous `SharedPreferences` lookup prior to `runApp` initialization to act as a routing gatekeeper.
- Configured single-run agreement caching to skip screen on subsequent app closures.

**Files Created:**
- `lib/screens/disclaimer_screen.dart`

**Files Modified:**
- `pubspec.yaml` (Added `shared_preferences`)
- `lib/main.dart` (Injected async routing)

**Packages Installed:**
- `shared_preferences`

**Verification Result:**
- SharedPreferences loads securely before initial material mounting.
---

## Step 10 — GateStatusCard Widget
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Constructed `GateStatusCard` as a `StatefulWidget` to map `GateStatusModel` into visual layers matching `Ui_Design.md` exactly.
- Built a looped 1.5s visual scaling pulse for the 'ALERT' status icon using `SingleTickerProviderStateMixin` and `AnimationController`.
- Established discrete active states (OPEN, ALERT, CLOSED), a 'Paused' fallback, and a `shimmer` placeholder layout for null states securely handling null safety.
- Handled UI overflowing text sizes safely by wrapping `displayLarge` labels inside `FittedBox`.

**Files Created:**
- `lib/widgets/gate_status_card.dart`

**Files Modified:**
- `pubspec.yaml` (Added `shimmer`)

**Packages Installed:**
- `shimmer`

**Verification Result:**
- Compiled flawlessly. Animations and widget structures are bound to `AppTheme` references safely.
---

## Step 11 — OfflineBanner Widget
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Created the top-level `OfflineBanner` UI component strictly matching the #37474F design specs.
- Linked UI size adjustments into a 300ms `AnimatedContainer` responding to the `isOffline` boolean property.

**Files Created:**
- `lib/widgets/offline_banner.dart`

**Files Modified:**
- None.

**Packages Installed:**
- None

**Verification Result:**
- Widget logic encapsulates gracefully shrinking height to zero without overflow layout exceptions.
---

## Step 12 — AppLogo Widget
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Defined the interactive `AppLogo` visual component.
- Implemented the invisible continuous rapid tap counter triggering `onAdminTrigger()` using constraints imported directly from `AppConstants`.
- Manipulated GestureDetector hit boxes to establish an artificially enlarged touch window without breaking 64x64px visual layout sizes.

**Files Created:**
- `lib/widgets/app_logo.dart`

**Files Modified:**
- None.

**Packages Installed:**
- None

**Verification Result:**
- Widget compiles and correctly logs taps without memory leakage.
---

## Step 13 — AdminAction Button Widget
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Crafted the `AdminActionButton` component which dynamically binds to the `GateStatus` enum to render corresponding action UI colors and labels.
- Mapped logic to obscure interactivity when `isLoading == true` while surfacing a scaled `CircularProgressIndicator`.
- Preserved precise dimensions (minimum 160px height) and integrated the exact Ripple feedback styles spec.

**Files Created:**
- `lib/widgets/admin_action_button.dart`

**Files Modified:**
- None.

**Packages Installed:**
- None

**Verification Result:**
- Widget enforces dynamic color mapping and disabled logic strictly.
---

## Step 14 — CommuterDashboardScreen
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Integrated `OfflineBanner`, `AppLogo`, and `GateStatusCard` into a singular top-level `CommuterDashboardScreen`.
- Surfaced Firebase's `.info/connected` leaf passively inside `GateService` to map immediately to the `OfflineBanner` without triggering excess manual connection loops.
- Replaced the main app launch placeholder route with the finalized Dashboard.

**Files Created:**
- `lib/screens/commuter_dashboard_screen.dart`

**Files Modified:**
- `lib/services/gate_service.dart` (Exposed `connectionStream`)
- `lib/screens/disclaimer_screen.dart` (Updated replacement router)
- `lib/main.dart` (Updated root initial route)

**Packages Installed:**
- None

**Verification Result:**
- Dashboard renders full structure with realtime reaction to the mock `statusStream` and `connectionStream`.
---

## Steps 15 & 16 — PIN Entry and Gateman Admin Screen
**Date:** 2026-04-18
**Status:** Complete

**What was implemented:**
- Orchestrated the secure `PinEntryScreen` utilizing stateful array boundaries mirroring physical hardware keypads.
- Wired internal bypass mechanics strictly limiting `secrets.dart` leakage.
- Created `AdminScreen` leveraging the pre-built `AdminActionButton` configured dynamically through `GateService.updateStatus` state.
- Crafted `StatusSnackbar` resolving localized feedback without persistent memory.
- Hooked the `.pushReplacement` pipeline across the bottom sheet context boundaries cleanly safely transitioning into the isolated Admin environment.

**Files Created:**
- `lib/screens/pin_entry_screen.dart`
- `lib/screens/admin_screen.dart`
- `lib/widgets/status_snackbar.dart`

**Files Modified:**
- `lib/config/secrets.dart` (Redacted static PIN)
- `lib/screens/commuter_dashboard_screen.dart` (Wired sheet invoker)

**Packages Installed:**
- None

**Verification Result:**
- Components linked smoothly avoiding unmounted Context exception chains on async network completion.
---


