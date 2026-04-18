━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 PROJECT BRIEF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Generated:** April 17, 2026
**Status:** COMPLETE — Ready for Architecture Review

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **1. PROBLEM (In Founder's Words)**

At the Raiwala railway crossing, commuters only discover the gate is closed when they physically reach it, by which point they are already trapped in a queue with no exit. This information asymmetry — knowing the gate's status too late to act — causes 15–30 minute forced waits, fuel waste, and noise pollution from sustained honking. No advance signal exists for commuters to make a different decision before entering the bottleneck.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **2. TARGET USER (Primary)**

**User Type:** Daily road commuter crossing the Raiwala railway crossing — including local residents, office-goers, and last-mile delivery riders (Zomato/Swiggy)
**Context:** On the road, approaching or planning to approach the Raiwala crossing, using an Android smartphone
**User Count:** Broader local audience in the Raiwala area

V1 focuses exclusively on this commuter as the consuming user. The gateman is an operator, not a target user.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **3. CORE PAIN OR DESIRE**

Commuters want to know the gate's status before they reach it — so they can choose to delay, reroute, or wait somewhere comfortable instead of being stuck in an inescapable queue.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **4. FOUNDER'S INTENT**

**Why Founder Wants This Built:**
The founder identified a specific, recurring, hyper-local problem at the Raiwala crossing that causes daily frustration for a known community of commuters. The solution requires no complex infrastructure — only a cooperative gateman and a simple app — making it immediately buildable. The founder wants to eliminate a concrete, unnecessary daily inconvenience for real people in a specific location.

**Founder's Relationship to Problem:**
Founder is building for others — local commuters at a specific crossing. Founder is not stated to be a daily user of this crossing themselves.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **5. DESIRED OUTCOME**

User can check the app or receive a push notification approximately 10 minutes before the gate closes, giving them enough time to take an alternate route, delay departure, or wait at a nearby location instead of joining the traffic queue.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **6. MUST-HAVE CAPABILITIES (Not Features)**

The system must be able to:

1. Display the current gate status (Open / Alert: Closing Soon / Closed) in real time to any user who opens the app, without requiring a manual refresh
2. Record and show the timestamp of the last status update
3. Send an automated push notification to all subscribed users when the gateman triggers the "Train Coming (Alert)" state
4. Send an automated push notification to all subscribed users when the gateman triggers the "Gate Closed" state
5. Send an automated push notification to all subscribed users when the gateman triggers the "Gate Opened" state
6. Allow the gateman to update the gate's state through a linear 3-step button sequence — one large button visible at a time — following the fixed cycle: Alert → Closed → Opened → Alert
7. Restrict access to the gateman's state-control interface via a secret tap sequence on the app logo followed by a hardcoded 4-digit PIN

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **7. EXPLICIT CONSTRAINTS**

**Time Constraint:** V1 must be built and launched within a few days

**Budget Constraint:** 100% free-tier services only. No paid infrastructure for V1.

**Skill Constraint:** Solo full-stack developer. No additional team members.

**Tool Constraint:** Firebase Realtime Database for live state sync; Firebase Cloud Messaging (FCM) for push notifications. Both are locked in.

**Platform Constraint:** Android mobile app only. No web version, no iOS, no PWA for V1.

**Deployment Preference:** Android APK distribution (Play Store free tier or direct APK install — not specified, documented as UNKNOWN below)

**Other Constraints:** Gateman is a volunteer. Any interface complexity risks losing his cooperation entirely. The operator experience is as critical a constraint as the technical build.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **8. KNOWN ASSUMPTIONS**

- ASSUMPTION: The gateman has an Android smartphone capable of running the app
- ASSUMPTION: The gateman has a stable enough mobile data connection at the crossing to submit state updates to Firebase in real time
- ASSUMPTION: The gateman will reliably press the buttons at the correct moments — the system has no fallback or verification mechanism if he forgets or presses out of sequence
- ASSUMPTION: FCM push notifications will be delivered with sufficient speed for the 10-minute advance alert to be actionable
- ASSUMPTION: The 3-step linear button cycle (Alert → Closed → Opened) covers all real-world gate scenarios without edge cases (e.g., a train cancellation mid-cycle)
- ASSUMPTION: A hardcoded 4-digit PIN is sufficient security for the gateman interface; no cloud-based auth is required
- ASSUMPTION: Users will trust and act on an app maintained by a single volunteer operator (the gateman) with no institutional backing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **9. UNKNOWNS / OPEN QUESTIONS**

- UNKNOWN: How the Android APK will be distributed — Google Play Store (free tier, but requires review time) or direct APK sideload
- UNKNOWN: What happens if the gateman presses the wrong button or misses a step — there is no stated correction or override mechanism for V1
- UNKNOWN: Whether the gateman's phone will have consistent internet connectivity at the physical crossing location
- UNKNOWN: Whether Firebase free tier (Spark plan) FCM and Realtime Database quotas are sufficient for the expected user volume at launch

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **10. DEFINITION OF SUCCESS (V1)**

V1 is successful when a commuter receives a push notification on their Android phone at least 10 minutes before the Raiwala gate closes — triggered solely by the gateman pressing a single button — and the app's live status screen reflects the correct gate state within seconds of that button press.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **11. BUSINESS MODEL**

**Monetization:** Not monetized for V1

**Paying Entity:** No one — fully free for all users

**Price Sensitivity:** Not applicable for V1. Founder has noted hyper-local advertising as a future consideration; it is explicitly out of V1 scope.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

### **12. INTEGRATION REQUIREMENTS**

**External Tools:**
- Firebase Realtime Database — live gate status sync across all user devices
- Firebase Cloud Messaging (FCM) — push notification delivery to all subscribed Android users
- Both are locked in. Both must operate within Firebase Spark (free) plan limits.

**Data Sensitivity:**
- No PII collected
- No payment data
- No health data
- App handles only gate status state (Open/Alert/Closed) and push notification tokens. Data sensitivity is minimal.

**Auth Preference:**
- End users: No authentication required. App is fully public and open.
- Gateman: Local device-side access control only — secret tap sequence on app logo (5 rapid taps) followed by hardcoded 4-digit PIN. No cloud-based authentication of any kind.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━