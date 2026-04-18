━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP 2 COMPLETION CHECKLIST
# Flutter Project Initialization
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏰ BEFORE running the next prompt — do these first:

[ ] Run FlutterFire Configure
    The code we just wrote expects `firebase_options.dart` to exist in `lib/config/`. We must have the CLI generate it.
    Run this command in the project root:
    ```
    flutterfire configure -o lib/config/firebase_options.dart
    ```
    Expected: CLI authenticates, prompts you to select the "RailAlert" project, registers Android app, and downloads `google-services.json` / `firebase_options.dart`.

[ ] Start an Android Emulator or attach an Android Device
    Expected: Device appears in `flutter devices`

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⏰ AFTER code was generated — do these now:

[ ] Run and Verify the App
    ```
    flutter run
    ```
    Expected: The app boots on the emulator/device, initializes Firebase without crashing, and shows a white screen with "RailAlert Raiwala Initialized" text.
    If wrong: Check if `minSdk 21` is accurately applied, or try running `flutter clean` then `flutter pub get`.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ WHAT GOT BUILT THIS STEP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ ] Flutter project boilerplate
[ ] Firebase dependencies defined in `pubspec.yaml`
[ ] `lib/main.dart` initialized with Crashlytics bindings
[ ] `minSdk` configured to 21

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧪 TESTING & VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test 1 — Files Exist:
```
dir lib\config\firebase_options.dart
```
✅ Expected: File created successfully by `flutterfire configure`
❌ If missing: Rerun the flutterfire command above

Test 2 — Environment / Dependencies:
```
flutter pub deps | findstr firebase
```
✅ Expected: Core, database, messaging, and crashlytics packages appear
❌ If errors: run `flutter pub get`

Test 3 — Process Start:
```
flutter run
```
✅ Expected: App launches successfully
❌ If errors: Look at the console output. Missing `google-services.json` means step 1 failed during `flutterfire configure`.

Test 5 — Security Check:
[ ] Verify `.gitignore` ignores Firebase secrets
    ```
    findstr /C:"google-services.json" .gitignore
    findstr /C:"firebase_options.dart" .gitignore
    ```
    ✅ Expected: They should ideally appear! If not, manually add them to `.gitignore`!
    ❌ If missing: Add `android/app/google-services.json` and `lib/config/firebase_options.dart` to `.gitignore` immediately.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 GIT COMMIT
(Run this ONLY after all above checks pass)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```
git add .
git commit -m "Step 2: Flutter Project Initialization — dependencies and Firebase core init"
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✋ DO NOT proceed to Step 3 until:
[ ] All tests above show ✅
[ ] Git commit is done
[ ] You have read do_after_completion.md fully
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
