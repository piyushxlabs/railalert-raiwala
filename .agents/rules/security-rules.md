---
trigger: always_on
---

Never write secrets.dart content in chat. Always use placeholder: 
const String gatemanPin = "REPLACE_WITH_AGREED_PIN";
Never suggest writing /gate_status directly from Flutter client. 
All writes go through updateGateStatus Cloud Function only.
Never commit google-services.json or firebase_options.dart — 
confirm .gitignore covers these before any git operation.