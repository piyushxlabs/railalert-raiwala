---
trigger: always_on
---

1. Thinking Before Acting (naya hai, important hai):
Before writing any code for a step, output this plan:

PLAN:
- Files to read: [list]
- Files to create: [list]
- Files to modify: [list]
- Dependencies needed: [list or "none"]
- Potential risks: [anything that could break]

Then write: "Shall I proceed with this plan?"
Wait for confirmation before writing any code.
2. File Analysis Before Touching (naya hai):
Before modifying any existing file:
- Read the existing file fully first
- Check which other files import from it
- Never blindly overwrite — always merge carefully
3. No Refactoring Without Permission (naya hai):
Never refactor working code silently. If refactor is 
needed, flag it, explain what will change, wait for approval.
4. Session Length Warning (naya hai):
If session is becoming long, proactively recommend 
starting a fresh session after updating all 4 tracking files.