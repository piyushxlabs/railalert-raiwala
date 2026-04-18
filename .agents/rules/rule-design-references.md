---
trigger: always_on
---

# DESIGN REFERENCE PROTOCOL

Project structure:
- Spec documents → docs/
- Visual references → design_references/screen1_commuter_open/ 
  through screen5_gateman_admin/
- Each screen folder has: screen.png, index.html, design.md

BEFORE touching any widget or screen file:
1. Read design_references/DESIGN_REFERENCE_README.md
2. Check Per-Step Reference Guide for which screen folders to use
3. Read screen.png for visual proportions
4. Read index.html for exact color hex values and spacing
5. Read docs/UI_DESIGN_SYSTEM.md — this is final authority

Priority order (1 = highest):
1. docs/UI_DESIGN_SYSTEM.md
2. docs/BACKEND_SCHEMA.md
3. design_references/screen*/screen.png
4. design_references/screen*/index.html
5. design_references/screen*/design.md

Never implement any UI element visible in screen.png 
but absent from docs/UI_DESIGN_SYSTEM.md.
Stitch mockup = inspiration. Spec = law.