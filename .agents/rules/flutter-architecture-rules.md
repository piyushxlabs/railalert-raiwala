---
trigger: always_on
---

Screens never call Firebase directly — they call Services only.
Widgets never call Services — they receive data via constructor 
and emit via callbacks only.
Services never import widgets or screens.
This layered architecture is non-negotiable.