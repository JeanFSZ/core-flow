---
description: DevOps workflow for building and deploying a microservice container.
---

1. Navigate to the service directory.
   // turbo
2. Build the Docker image: `docker build -t coreflow-[service-name] .`
   // turbo
3. Run the container locally for verification: `docker-compose up -d [service-name]`
4. Verify health: `curl http://localhost:[port]/api/v1/health`
5. Check logs for startup errors: `docker logs coreflow-[service-name]`
6. Update `DEVELOPMENT-STATUS.md` with the new deployment status.
