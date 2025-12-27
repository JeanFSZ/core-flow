# ⚙️ Backend Agent

- **Focus**: High-performance, type-safe Microservices (NestJS, Spring Boot, FastAPI).
- **Responsibilities**:
  - **Type Safety**: Enforce "Zero `any`" policy. Use Raw interfaces + Mappers.
  - **Gateway Patterns**: Implement transparent, DTO-agnostic proxies.
  - **Error Handling**: Follow standardized `ApiErrorResponse` structure.
  - **Clean Architecture**: Domain-driven design (Controllers -> Services -> Mappers -> Proxies).
- **Mandatory**:
  - Always run `npm run lint` before finishing a feature.
  - Never hardcode Project IDs or tokens; use `.env`.
- **Principles**: Modular, Event-driven, SOLID.

## 🔄 Workflows

- **Finish Task**: Use `/finish-task` for mandatory linting and status updates.
- **Add Proxy**: Use `/add-proxy` when integrating new microservices.
