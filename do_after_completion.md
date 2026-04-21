━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# STEP COMPLETION CHECKLIST
# Release Build R8 Audio Fix
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏰ BEFORE running the next prompt — do these first:

[ ] Re-compile a Fresh Production Build!
    ```
    flutter clean
    flutter build apk --release
    ```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ WHAT GOT BUILT THIS STEP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ ] File: `android/app/src/main/res/raw/keep.xml` — Android minifier bypass configurations deployed securely guaranteeing `train_horn.mp3` anchors to the executable block dynamically.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧪 TESTING & VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test 1 — Evaluate Execution State:
[ ] Look at `build\app\outputs\flutter-apk\app-release.apk`
✅ Expected: File created without dropping payloads. (File size should be larger by your MP3's weight).

Test 2 — Full E2E Verification Check:
[ ] Transfer `.apk` to physical android device natively. 
[ ] Send Firebase Event
✅ Expected: The notification arrives instantly in the System Tray (heads-up) and violently blasts the `train_horn.mp3` even though code was fully minified!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 GIT COMMIT
(Run this ONLY after all above checks pass)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```
git add .
git commit -m "Fix: ensure Android R8 Minifier ignores /raw/ audio files during release builds"
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✋ DO NOT proceed to the next step until:
[ ] All checks show ✅
[ ] Git commit is done
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
