---
description: Backend workflow for integrating a new microservice proxy into the API Gateway.
---

1. Create a new module in `apps/api-gateway/src/[service]/`.
2. Define the service extending `AbstractProxyService`.
3. Create the controller with `@All('*')` route.
4. Add service configuration in `src/config/services.config.ts`.
5. Register the new module in `AppModule`.
6. Run `/finish-task` workflow to verify integration.
