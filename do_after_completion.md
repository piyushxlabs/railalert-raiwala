━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# FIREBASE ANALYTICS COMPLETION CHECKLIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏰ BEFORE running the next prompt — do these first:

[ ] Verify firebase_analytics is in pubspec.yaml:
    Expected: firebase_analytics: ^12.3.0 listed under dependencies

[ ] Verify main.dart now has both imports:
    Expected:
      import 'package:firebase_analytics/firebase_analytics.dart';
      import 'package:firebase_crashlytics/firebase_crashlytics.dart';

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧪 TESTING & VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test 1 — Static Analysis:
```
flutter analyze
```
✅ Expected: No issues found.
❌ If errors: Check firebase_analytics version compatibility with firebase_core.

Test 2 — Release Build Compiles:
```
flutter build apk --release
```
✅ Expected: BUILD SUCCESSFUL, APK at build/app/outputs/flutter-apk/app-release.apk
❌ If D8/Gradle errors: Run flutter clean then retry.

Test 3 — DebugConsole Analytics Events:
Install debug APK on device. Open Firebase Console > Analytics > DebugView.
Launch the app.
✅ Expected: first_open and session_start events appear within 60 seconds.
❌ If no events: Ensure google-services.json is the correct production file.

Test 4 — Crashlytics Integration Check:
In Firebase Console > Crashlytics > your app.
✅ Expected: App appears as "SDK detected" if at least one build was run.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 GIT COMMIT
(Run ONLY after all above checks pass)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```
git add .
git commit -m "Step: Firebase Analytics integration — firebase_analytics 12.3.0 initialized in main()"
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✋ DO NOT proceed to build release until:
[ ] flutter analyze passes
[ ] firebase_analytics visible in pubspec.lock
[ ] Git commit is done
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
