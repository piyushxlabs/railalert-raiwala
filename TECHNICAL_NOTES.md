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

Steps 7, 8, 9 — Adopted the `http` package and implemented a manual POST operation against the FCM REST endpoint from within the `NotificationService`. This is a hard Spark Plan workaround because the standard `firebase_messaging` Flutter client SDK cannot send messages. `secrets.dart` added locally to isolate the API key. Also utilized `rxdart` to combine `gate_status` and `app_config` into a single reactive pipeline.

Step 9B — Evaluated `SharedPreferences` locally before initializing `runApp()` to guarantee zero flickering or artifacting on app boot. Routing is strictly conditional to either the Dashboard or the Disclaimer.

Step 10 — Built the core UI `GateStatusCard` utilizing the `shimmer` library to provide modern loading skeletons. Since the 'ALERT' mode dictates a looped scaling effect, utilizing an `AnimationController` required standard explicit state management mapping tied directly to object properties (`oldWidget` vs `newWidget` evaluation) to prevent memory leaks when navigating or re-rendering states via the active stream. Used `FittedBox` on the explicitly huge Header-sized labels to avoid rendering overflows on narrow mobile displays.

Step 11 — Wrapped the interior components of `OfflineBanner` within a fixed-height box inside a `SingleChildScrollView(physics: NeverScrollableScrollPhysics())` child wrapper. This protects against the infamous bottom overflow rendering error that `AnimatedContainer` causes globally when collapsing to height 0.0 with explicitly sized children.

Step 12 — To isolate UI mechanics, `AppLogo` relies on stateful background clock mathematics checking time gaps between internal UI inputs (`DateTime.now().difference()`). Instead of rendering a larger button directly to fulfill the 88x88 touch area requirement, a standard 12px `Padding` coupled with `HitTestBehavior.opaque` forces touch detection beyond the visible border while anchoring the icon inside its true 64px radius.

Step 13 — Chose to use `Material` enclosing an `InkWell` layout for `AdminActionButton` instead of standard `ElevatedButton`. ElevatedButtons override internal padding sizes unpredictably, making strict `minHeight: 160px` alignment difficult. The `InkWell` allowed precise reproduction of `#E65100` hover ripples and custom shadow elevation.

Step 14 — Leveraged dual `StreamBuilder` widgets inside `CommuterDashboardScreen` to isolate independent UI reactions. `connectionStream` strictly binds to `.info/connected` preventing any false-offline triggers when the main state merely rests empty. Used `initialData: true` inside the connection builder to prevent the red Offline Banner from graphically flickering down and up during the initial 50ms Firebase bootstrapping sequence.

Step 15/16 — Navigating directly out of a bottom sheet presents architectural challenges. Calling `Navigator.pushReplacement` directly over the modal context often leaves the hidden sheet blocking `pop` scopes below the new screen. To sidestep memory accumulation, evaluated `Navigator.of(context).pop()` right before pushing the new `PageRouteBuilder(AdminScreen)` providing a crisp replacement behavior retaining the root Dashboard directly underneath. Wrapped `HapticFeedback` dynamically directly into the action inputs. For state-safety post network resolves (`await`), wrapped UI mutations tightly inside `if(mounted)` bounds mapping natively avoiding memory leaks.

Step 18 — Audited Crashlytics integrations natively located inside `main.dart`. Returning `true` inside `PlatformDispatcher.instance.onError` prevents application termination by notifying the Flutter engine the asynchronous error was successfully tracked.

Step 19/20 — Manifest injection relies directly on raw `/android/app/src/main/AndroidManifest.xml` modifications bypassing flutter abstractions. This is the only guaranteed vector to ensure the compiled OS `.apk` maps the correct display label independently of the internal Dart `MaterialApp` context strings.

Bonus Step — The status-reverts-to-OPEN bug was caused by two independent `GateService()` instances inside `AdminScreen` each attaching their own Firebase listener. When offline persistence is enabled, the local cache can briefly re-emit the previous value before the server confirms the write. Fix: single shared `GateService` instance + `_optimisticStatus` local state variable that immediately reflects the expected next state during the in-flight write window, then releases after Firebase confirms.

Bug Fix Step — The dashboard grey box was caused by `Rx.combineLatest2` blocking permanently because `/app_config` doesn't exist in Firebase (Spark plan, no initial seed). `combineLatest2` requires ALL source streams to emit at least once before firing. Since `configStream` attaches a listener to a non-existent node, it silently returns nothing. Fix: `.startWith(null)` on `configStream` forces an immediate synthetic emission of `null`, which satisfies `combineLatest2` and allows the status stream to flow through. This is the correct pattern for optional Firebase nodes.

Session Persistence Step — Created `SessionManager` as a single-source-of-truth for all `SharedPreferences` keys. This prevents key-string typos across multiple screens (e.g., `'has_agreed_to_disclaimer'` referenced in 3 files previously). Admin logout uses `Navigator.pushAndRemoveUntil` with `(route) => false` to fully clear the navigation stack — this ensures the Back button cannot return to AdminScreen after logout.

Final UI Fix Step — The Admin tracking UI was looping and reverting back to open due to Optimistic State tracking conflicting with network delays. The entire optimistic tracking feature was scrubbed giving full UI driver-control exclusively to `StreamBuilder`. The splash screen clipping occurred because `Column` widgets shrink-wrap horizontally if they lack full constraints like `SizedBox(width: double.infinity)`.

State Liberty Patch — Removed hardcoded state-transition sequences from `GateService` to permit completely unconstrained UI updates. `admin_screen.dart` was remapped from a monolithic cycle button to an explicit 3-element vertically scrolled view (`ListView`). `admin_action_button.dart` height was reduced from 160 to 100 dynamically and enabled nullable `onPressed` callbacks to allow visually disabling the active status directly from the builder map without routing collisions.

Window OS Boot Injection — The 1 to 2 second delay of "Pitch Black" or "Bright White" booting the executable originates entirely outside of dart layers — Flutter’s Android embedding V2 spins an unpainted Android UI `Activity` framework while the `isolate` attaches payload threads. Redesigning Android's `.xml` files globally overwrites this brief OS shadow frame with the application `AppTheme.primary` exact hexadecimal (#E65100).

V21 Native Override — Android devices API 21+ heavily prioritize `drawable-v21/launch_background.xml`. Even if basic `/drawable` handles the background, `v21` forcing `?android:colorBackground` caused sudden blanking. Bridged this behavior to exclusively point to our static `colors.xml` `@color/splash_background`.

External Intents via URL Launcher — Used `LaunchMode.externalApplication` to force links out of the internal Webview and straight into native OS apps (like Instagram or LinkedIn native installed apps). An async `try/catch` and `.mounted` Snackbar handles gracefully routing failures if the OS blocks the intent path.

Asset Loading Resiliency — Implemented container-bound `DecorationImage` over standard `AssetImage` wrappers. The latter can cause jagged rendering loops if the asset is missing, but with `assets/images/` bridged through `pubspec.yaml`, the UI smoothly maps to the physical payload. Used hardcoded pixel coordinates for padding edges within newly constructed components to sidestep strict dependency on global theme constants lacking edge-case metrics.

Gradient Depth Handling — Flutter's `Card` widget natively struggles to accept gradient backgrounds without clipping the underlying `Material` touch-ripples. Deployed a hybrid `Card > Container(gradient) > InkWell` architecture mapped with `Clip.antiAlias` to ensure both the high-fidelity render of the Saffron-to-Deep-Saffron interpolation and the reactive fluid touch-feedback remain perfectly synchronized.

UI Chip Construction — Utilized raw `Container` bounds inside horizontal `Row` elements instead of standard Material `Chip` to ensure perfect padding control over grey badges, eliminating the inherent margin bloat from default Flutter material widgets.

Physics Animation Architecture — Tactile press feedback on social buttons implemented via private `StatefulWidget` + `SingleTickerProviderStateMixin` pattern rather than `GestureDetector > ScaleTransition` global wrappers. This scopes each button’s animation lifecycle independently, preventing shared-controller teardown bugs. `_scaleController.reverse()` on `onTapDown` and `.forward()` on `onTapUp`/`onTapCancel` gives reliable spring-back on both tap completion and mid-tap cancellation.

Breathing Animation — Used Tween(1.0 → 1.02) at 2000ms with `repeat(reverse: true)` and `Curves.easeInOut` to produce a completely invisible-at-rest but noticeably alive pulse. Scale of 2% was deliberately chosen to remain subconscious (not distracting) while still drawing peripheral attention.

ScaleTransition vs AnimatedBuilder — Switched dashboard breathing wrapper from `AnimatedBuilder+Transform.scale` to the lighter `ScaleTransition(scale: _breathAnim)` widget. `ScaleTransition` is Flutter’s built-in optimised animation for scale only — fewer rebuild nodes vs `AnimatedBuilder`’s custom builder pattern. Corrected tween to 1.025 per spec.

AnimatedScale for Tactile Buttons — Replaced the two-state `AnimationController.reverse/forward` pattern with Flutter’s built-in `AnimatedScale` widget. `setState(() => _scale = 0.95/1.0)` drives it; duration adapts (100ms down, 200ms up) through a ternary on the current scale value — simpler and eliminates the need for `dispose()` in `_AnimatedSocialButtonState`.

Admin Usability Layout — Transitioned from standard un-bounded `ListView` (which anchors to top constraints by default) to an embedded `Center > SingleChildScrollView > Column(mainAxisAlignment: MainAxisAlignment.center)` pattern. This leverages Flutter's auto-spacing algorithms to float the dense interaction layer optimally within any aspect ratio dynamically ensuring Gatemen don't strain fingers reaching to high bounding boxes on tall industrial phones.

Firebase Analytics Pre-audit — Before running `flutter pub add`, all four integration touchpoints were audited: `settings.gradle.kts` (plugin declaration), `app/build.gradle.kts` (plugin apply), `lib/main.dart` (SDK init), and `pubspec.yaml` (dependency). Crashlytics Gradle setup was already 100% present from a prior FlutterFire configuration run. Only the Dart SDK package (`firebase_analytics`) and its `FirebaseAnalytics.instance` initialization line were missing. No Gradle files were modified.
