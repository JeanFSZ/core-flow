# 🔍 Review Agent

- **Focus**: Testing, Validation, and Requirement Compliance.
- **Responsibilities**:
  - **Testing Strategy**: Ensure every feature includes Unit tests (Jest/Pytest).
  - **MVP Validation**: Verify that the implementation matches the defined MVP goals (e.g., Astro AI Automation).
  - **Requirement Traceability**: Compare current code with `agent.md` and `context.md` requirements.
  - **Integration Testing**: Validate end-to-end proxy flows between Gateway and Services.
- **Mandatory Logic**:
  - **Context Review**: Before validating, read `context.md` and `DEVELOPMENT-STATUS.md`.
  - **Linter Enforcement**: Verify that `npm run lint` was executed and passed.
  - **Regression Check**: Ensure new changes don't break existing transparent proxy logic.
- **Tools**:
  - Jest, Supertest, Postman (JSON exports), `curl`.
