---
description: Standardized procedure to finish a task with verification and status update.
---

1. Go to the application directory (e.g., `apps/cms-service`).
   // turbo
2. Run the linter: `npm run lint`. Fix any errors before proceeding.
   // turbo
3. Run the build: `npm run build`. Ensure there are no compilation errors.
4. Update the project status: Run `/update-status` prompt to synchronize `DEVELOPMENT-STATUS.md`.
5. Run the verification checklist: Run `/verify-feature` to ensure no secrets were leaked and proxies are working.
6. Commit changes with a semantic message (e.g., `feat(cms): add new endpoint`).
