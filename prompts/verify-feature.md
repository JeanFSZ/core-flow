# Prompt: Feature Verification Checklist

## 🎯 Objective

Perform a mandatory verification of a newly implemented feature or fix before closing a task.

## 🛠️ Instructions

1.  **Lint Check**: Run `npm run lint` in the relevant app directory. Fix all errors.
2.  **Build Check**: Run `npm run build` to ensure no TypeScript compilation issues.
3.  **Secrets Audit**: Verify that no hardcoded keys or IDs were introduced.
4.  **Connectivity (Proxy)**: If the change affects a gateway or service, perform a `curl` test to verify the end-to-end flow.
5.  **Documentation**: Ensure `DEVELOPMENT-STATUS.md` and `context.md` are ready for an update.

## ✅ Goal

"Done" means Lint-Clean, Build-Validated, and Secret-Free.
