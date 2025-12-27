# Prompt: Update Development Status

## 🎯 Objective

Synchronize the central `DEVELOPMENT-STATUS.md` with the current workspace state after completing a major task or phase.

## 📋 Context

You are finishing a phase or a set of features. The source of truth for the project's architecture and progress must be updated.

## 🛠️ Instructions

1.  **Analyze workspace**: Check `agent.md`, `context.md`, and the `apps/` directory.
2.  **Update Table**: Mark completed components as ✅ and initiated ones as 🕒 or ⚠️.
3.  **Refine Standards**: Ensure the technical standards section reflects our latest patterns (e.g., Transparent Proxy, Strict Typing).
4.  **Zero Leaks**: Double check that NO Project IDs, API Keys, or URLs containing secrets are included.
5.  **Clean Architecture**: Ensure the roadmap reflects the next logical steps in Phase 2 or 3.

## ✅ Output

A concise, markdown-formatted update to `DEVELOPMENT-STATUS.md`.
