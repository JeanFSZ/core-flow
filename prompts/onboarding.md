# Prompt: System Role & Mission Onboarding

## 🎯 Objective

Initialize the agent session by assuming a specialist persona and synchronizing with project standards.

## 🧱 Initialization Logic

1.  **Identify Role**: Read the relevant specialist brief in `agents/[specialist]-agent.md` (e.g., Backend, AI, DevOps, Review). Assume this persona.
2.  **Project Pulse**: Read `DEVELOPMENT-STATUS.md` and `context.md` to understand current progress and the next MVP goals.
3.  **Strict Standards**: Strictly follow the coding and verification standards defined in `.agentconfig.json`.
4.  **Workflow Awareness**: Familiarize yourself with technical workflows in `.agent/workflows/`.

## 📋 Task Assignment

**Your task is:** [DESCRIBE_TASK_HERE]

## ✅ Execution Protocol

- **Done Definition**: All tasks must end with `npm run lint` and `npm run build` (where applicable).
- **Status Sync**: Update `DEVELOPMENT-STATUS.md` (via `/update-status`) upon reaching a project milestone.
- **Secret Audit**: Ensure no hardcoded keys or IDs are leaked during the session.

---

_Ready to proceed? Confirm your role and mission before starting._
