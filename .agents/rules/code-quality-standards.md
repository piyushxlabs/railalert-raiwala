---
trigger: always_on
---

Every file you write must follow these standards:
- Dart: follow official Dart style guide, use const constructors 
  wherever possible, no magic numbers (use AppConstants or 
  AppTheme values), all widgets stateless unless state is required
- No commented-out code in final files
- No TODO comments left unresolved
- All colors from AppTheme only — never hardcode hex values 
  directly in widgets
- All strings from AppConstants — never hardcode Firebase paths, 
  FCM topic names, or tap counts inline