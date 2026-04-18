# Design References — RailAlert Raiwala

## Source
All screens generated via Google Stitch (stitch.withgoogle.com)
Based on docs/UI_DESIGN_SYSTEM.md specifications.
Each screen folder contains: screen.png + index.html + design.md

## CRITICAL USAGE RULE
These files are VISUAL REFERENCE ONLY.
Authoritative spec = docs/UI_DESIGN_SYSTEM.md

Where mockup conflicts with spec → FOLLOW THE SPEC.
Where mockup shows data not in docs/BACKEND_SCHEMA.md → IGNORE IT.

## Screen Mapping
| Folder | Screen | Use For |
|--------|--------|---------|
| screen1_commuter_open/ | Commuter Dashboard - OPEN | Color, card size, layout |
| screen2_alert_state/ | Commuter Dashboard - ALERT | Warning card styling |
| screen3_closed_offline/ | Commuter Dashboard - CLOSED + Offline | Red card + banner |
| screen4_pin_entry/ | PIN Entry Overlay | Keypad layout, circles |
| screen5_gateman_admin/ | Gateman Admin Screen | Action button, heading |

## Per-Step Reference Guide
| Step | Read These |
|------|-----------|
| Step 10 — GateStatusCard | screen1, screen2, screen3 |
| Step 11 — OfflineBanner | screen3 |
| Step 12 — AppLogo | screen1 |
| Step 13 — AdminActionButton | screen5 |
| Step 14 — Commuter Dashboard | screen1, screen2, screen3 |
| Step 15 — PIN Entry Screen | screen4 |
| Step 16 — Admin Screen | screen5 |

## Priority Order
1. docs/UI_DESIGN_SYSTEM.md — AUTHORITATIVE, always wins
2. docs/BACKEND_SCHEMA.md — data authority
3. screen*/screen.png — visual feel, proportions
4. screen*/index.html — color values, spacing numbers
5. screen*/design.md — design tokens hint only