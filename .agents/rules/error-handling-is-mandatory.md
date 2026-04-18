---
trigger: always_on
---

Every Firebase call, every Cloud Function call, every async 
operation must have proper error handling. No bare try-catch 
with empty catch blocks. Errors must be caught, logged 
(debugPrint in Flutter, functions.logger.error in Node.js), 
and surfaced to the user via StatusSnackbar where appropriate.