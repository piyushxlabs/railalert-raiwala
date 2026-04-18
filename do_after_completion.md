━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEPS 7, 8, 9 COMPLETION CHECKLIST
# Data Layer & Services
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏰ BEFORE running the next prompt — do these first:

[ ] Add your Server Key (Optional but Required for FCM later)
    Open `lib/config/secrets.dart` and paste your Cloud Messaging API (Legacy) Token where it says `"REPLACE_WITH_REAL_KEY"`. Do this before you push updates, as the file is ignored by Git and protects your key.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⏰ AFTER code was generated — do these now:

[ ] Run pub get
    ```
    flutter pub get
    ```
    Expected: Ensures `rxdart` and `http` resolve properly.

[ ] Run syntax analysis
    ```
    flutter analyze
    ```
    Expected: "No issues found!" confirming your Flutter structure matches the new imports and definitions.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ WHAT GOT BUILT THIS STEP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ ] `lib/models/gate_status.dart` — Schema bindings
[ ] `lib/services/gate_service.dart` — Reads/writes and guards state bounds
[ ] `lib/services/notification_service.dart` — Broadcasts manual FCMS
[ ] `lib/config/secrets.dart` — Protects your server tokens

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧪 TESTING & VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test 1 — Ignore Enforcement:
```
findstr /C:"secrets.dart" .gitignore
```
✅ Expected: `.gitignore` protects `secrets.dart` (Add to `.gitignore` yourself if it returns empty!)

Test 2 — Syntax State:
```
flutter analyze
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 GIT COMMIT
(Run this ONLY after all above checks pass)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```
git add .
git commit -m "Steps 7-9: Finalized Data Layer, RxDart streams, and Spark REST implementation"
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✋ DO NOT proceed to Step 10 until:
[ ] All tests above show ✅
[ ] Git commit is done
[ ] You have read do_after_completion.md fully
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
