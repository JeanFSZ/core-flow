# 🤖 Agent Brief — Coreflow Root

> **Last Updated:** October 15, 2024  
> **Current Phase:** 1 (Foundation) - 60% Complete  
> **Next Milestone:** Complete CMS Service & API Gateway

## 🧠 Overview

**Coreflow** is a modular, polyglot ecosystem designed to demonstrate modern full-stack architecture, automation, and AI-driven content management.  
It integrates microservices, event-driven communication, DevOps pipelines, AI agents, and blockchain verification — all centered around scalable, clean architecture.

**Goal:**  
Build a living portfolio platform that showcases software craftsmanship — from backend engineering to Web3 integration and AI automation.

---

## ✅ Current Status (What's Built)

| Component | Status | Notes |
|-----------|--------|-------|
| **Frontend (Astro)** | ✅ Complete | Personal portfolio + blog, integrated with Sanity |
| **Sanity Studio** | ✅ Complete | Schemas: post, category, tag. Hosted separately |
| **CMS Service** | ❌ Not Started | Needs NestJS intermediary for Sanity API |
| **API Gateway** | ❌ Not Started | Central orchestrator missing |
| **Kafka Infra** | ❌ Not Started | Event-driven layer not configured |
| **AI Service** | ❌ Not Started | Content generation pending |
| **Blockchain Service** | ❌ Not Started | Hash registry pending |
| **Payments Service** | ❌ Not Started | Phase 2 feature |

### ⚠️ Current Architecture Gap

**Problem:** Frontend is currently calling **Sanity directly**, bypassing the planned microservices architecture.

```
❌ Current:  Astro Frontend → Sanity CMS (direct API calls)
✅ Target:   Astro Frontend → API Gateway → CMS Service → Sanity CMS
```

---

## 🧩 Core Architecture Summary

| Layer | Description | Tech Stack |
|-------|--------------|------------|
| **Frontend Public (Portfolio)** | Static Astro site for blogs, showcase, and landing | Astro + React |
| **Dashboard (Web3/Private)** | Interactive admin panel and blockchain verification interface | React + wagmi + ethers.js |
| **API Gateway** | Central orchestrator handling authentication, routing, and aggregation | NestJS |
| **CMS Service** | Content management microservice, integrates with Sanity | NestJS + Sanity API |
| **Payments Service** | Handles payments and transactions | Spring Boot + Stripe |
| **AI Service** | Manages content generation and NLP processing | FastAPI + OpenAI API |
| **Blockchain Service** | Anchors content and payments in blockchain | NestJS / FastAPI + Web3.js + Solidity |
| **Infra / DevOps** | Local & cloud infrastructure, pipelines, and monitoring | Docker, K8s, Helm, GitHub Actions |

---

## ⚙️ Communication Model

Coreflow follows an **event-driven microservice pattern**:

- **Async layer:** Apache Kafka → used for domain events (`blog.created`, `ai.blog.generated`, `tx.submitted`, etc.)
- **Sync layer:** REST / GraphQL endpoints exposed through the **API Gateway**
- **Shared contracts:** DTOs and message schemas live under `/libs/types/`
- **State:** PostgreSQL (persistent), Redis (cache)

---

## 🧱 Responsibilities

### Root Repository
- Define shared **architecture, documentation, and CI/CD standards**
- Contain all **apps**, **libs**, and **infra** resources
- Provide onboarding context through this `agent.md`

### Each Microservice
- Operates independently
- Has its own `agent.md` for AI agents or collaborators
- Exposes APIs with OpenAPI documentation
- Emits and/or consumes Kafka events

### Frontends
- Consume API Gateway endpoints
- Remain stateless (no direct DB or Kafka access)
- Astro → public content; React → private dashboard/Web3

---

## 🔐 Security and Auth

- OAuth2 / OIDC via Keycloak or Auth0  
- JWT/JWK tokens for API communication  
- Optional Web3 Wallet authentication for dashboard users  
- Sensitive keys stored in `.env` and managed securely in deployment (Vault, KMS, or secrets manager)

---

## 🔗 Blockchain Layer

Purpose: add **traceability and authenticity** to generated or published content.

- Smart contracts deployed on **Polygon (Mumbai)** for testing  
- Register SHA-256 hashes of content or payment receipts  
- Expose verification endpoints `/verify/:tx_hash`

---

## 🧠 AI Integration

- AI Service (FastAPI) handles content generation using LLMs (OpenAI, Claude, etc.)  
- Emits `ai.blog.generated` events to Kafka  
- CMS Service listens and publishes to Sanity automatically  
- Future: multi-agent architecture (LangChain / CrewAI)

---

## 🧰 Development Environment

- **Local setup:** via `infra/docker-compose.yml` (Kafka, Postgres, Redis)  
- **CI/CD:** GitHub Actions (`devops/github-actions/`)  
- **Deployment:** Kubernetes (Helm charts in `/infra/k8s/`)  
- **Monitoring:** Prometheus + Grafana (planned Phase 6)

---

## 🧪 Testing & Quality

- Unit tests per service (Jest for NestJS, Pytest for FastAPI, JUnit for Spring)
- Integration tests with mocked Kafka topics
- CI pipeline runs build → test → lint → containerize
- Use Prettier + ESLint + SonarLint for code quality

---

## 📦 Repository Structure

coreflow/
├── apps/
│ ├── api-gateway/
│ ├── cms-service/
│ ├── payments-service/
│ ├── ai-service/
│ ├── blockchain-service/
│ ├── coreflow-astro/
│ └── coreflow-dashboard/
│
├── infra/
├── devops/
├── libs/
├── docs/
├── .env.example
└── agent.md <-- this file

---


---

## 🧠 Collaboration Rules

1. **Never modify other services’ internal logic** without updating their `agent.md`
2. **Always update documentation** when adding or changing endpoints or events
3. **Keep secrets out of code** — only in `.env` or vaults
4. **Follow Clean Architecture**: controllers → services → repositories → external clients
5. **Use semantic commits**:
   - `feat:` new feature  
   - `fix:` bug fix  
   - `docs:` documentation  
   - `refactor:` structure change

---

## 🚀 Roadmap Summary

| Phase | Focus | Status | Key Result |
|-------|--------|--------|------------|
| 🌱 1 | Foundation (CMS + Gateway + Astro) | **60% Complete** | Base monorepo & infra running |
| ⚙️ 2 | Business Logic (Payments + Auth) | Not Started | OAuth2 + Payment flow |
| 🧠 3 | AI Content | Not Started | FastAPI LLM integration |
| 🔗 4 | Blockchain | Not Started | Hash registry & on-chain proof |
| 💻 5 | Dual Frontends | Not Started | Astro + Web3 Dashboard |
| 🧬 6 | Observability & DevSecOps | Not Started | Full CI/CD and metrics |
| 🚀 7 | Future (LLM Agents, SSI, NFT Badges) | Not Started | Expansion & autonomy |

### Phase 1 Progress Breakdown:
- ✅ **Astro Frontend:** 100% - Personal portfolio + blog with Sanity integration
- ✅ **Sanity Studio:** 100% - Schemas deployed (post, category, tag)
- ✅ **Frontend Infrastructure:** Git flow, production TODOs, documentation
- ❌ **CMS Service (NestJS):** 0% - Documentation only, no code
- ❌ **API Gateway:** 0% - Not started
- ❌ **Local Kafka Infrastructure:** 0% - Docker compose not configured

---

## 📋 Next Steps (Priority Order)

### 🎯 Immediate (Sprint 1 - Complete Phase 1)

#### **Step 1: Setup Local Infrastructure** (2-3 hours)
```bash
infra/docker-compose.yml
```
- [ ] Kafka + Zookeeper containers
- [ ] PostgreSQL container (for future services)
- [ ] Redis container (cache layer)
- [ ] pgAdmin (optional, for DB management)
- [ ] Kafka UI (optional, for event monitoring)

**Why First:** All microservices depend on this infrastructure.

---

#### **Step 2: Build CMS Service** (6-8 hours)
```
apps/cms-service/ (NestJS)
```

**Repository:** https://github.com/JeanFSZ/core-flow-ws-cms-service.git

**Features to Implement:**
- [ ] Initialize NestJS project with TypeScript
- [ ] Create `PostsModule`, `CategoriesModule`, `TagsModule`
- [ ] Integrate Sanity Client (`@sanity/client`)
- [ ] Implement REST endpoints:
  ```
  GET    /posts              → List all posts (with pagination)
  GET    /posts/:slug        → Get single post by slug
  GET    /categories         → List all categories
  GET    /tags               → List all tags
  POST   /posts              → Create new post in Sanity
  PUT    /posts/:id          → Update post in Sanity
  DELETE /posts/:id          → Delete post in Sanity
  ```
- [ ] Add DTOs with `class-validator`
- [ ] Implement Kafka producer to emit `blog.post.created` events
- [ ] Add environment variables (`.env.example`):
  ```
  SANITY_PROJECT_ID=2mf3fi4m
  SANITY_DATASET=dev
  SANITY_TOKEN=<write-token>
  KAFKA_BROKERS=localhost:9092
  ```
- [ ] Write unit tests (Jest)
- [ ] Create Dockerfile
- [ ] Document in `README.md` and `agent.md`

**Output:** Fully functional CMS microservice that wraps Sanity API.

---

#### **Step 3: Build API Gateway** (4-6 hours)
```
apps/api-gateway/ (NestJS)
```

**Features to Implement:**
- [ ] Initialize NestJS project
- [ ] Setup routing and proxy to CMS Service:
  ```
  GET /api/cms/posts        → Forward to cms-service:3001/posts
  GET /api/cms/posts/:slug  → Forward to cms-service:3001/posts/:slug
  GET /api/cms/categories   → Forward to cms-service:3001/categories
  GET /api/cms/tags         → Forward to cms-service:3001/tags
  ```
- [ ] Add rate limiting (throttler)
- [ ] Add CORS configuration
- [ ] Add health check endpoint: `GET /health`
- [ ] Add OpenAPI/Swagger documentation
- [ ] Implement request/response logging
- [ ] Add environment variables
- [ ] Create Dockerfile
- [ ] Document endpoints

**Output:** Central API orchestrator ready for future services.

---

#### **Step 4: Refactor Astro Frontend** (2-3 hours)
```
apps/coreflow-astro/src/lib/
```

**Changes:**
- [ ] Replace direct Sanity calls with API Gateway calls:
  ```typescript
  // Before: Direct Sanity
  import { sanityClient } from '~/lib/sanity/client';
  
  // After: Through API Gateway
  const API_URL = import.meta.env.PUBLIC_API_GATEWAY_URL || 'http://localhost:3000/api';
  
  async function fetchPosts() {
    const response = await fetch(`${API_URL}/cms/posts`);
    return response.json();
  }
  ```
- [ ] Update environment variables:
  ```
  PUBLIC_API_GATEWAY_URL=http://localhost:3000/api
  ```
- [ ] Keep Sanity as fallback for development
- [ ] Update documentation

**Output:** Frontend now follows proper microservices architecture.

---

### 🔄 Medium Priority (Sprint 2 - Kafka Integration)

#### **Step 5: Kafka Event Integration** (4-5 hours)
- [ ] Configure Kafka topics in `infra/kafka/topics.json`:
  ```json
  {
    "topics": [
      "blog.post.created",
      "blog.post.updated",
      "ai.blog.generated",
      "tx.submitted"
    ]
  }
  ```
- [ ] Update CMS Service to emit events when posts are created/updated
- [ ] Create shared DTOs library: `libs/types/` with event schemas
- [ ] Test Kafka event flow with Kafka UI

---

### 🧠 Future Priority (Sprint 3 - AI Integration)

#### **Step 6: AI Service** (8-10 hours)
```
apps/ai-service/ (FastAPI + Python)
```

**Features:**
- [ ] Initialize FastAPI project
- [ ] Integrate OpenAI API or Claude API
- [ ] Create prompt templates for blog generation
- [ ] Implement endpoints:
  ```
  POST /generate/blog    → Generate blog post from prompt
  POST /enhance/content  → Improve existing content
  ```
- [ ] Consume Kafka event: `ai.blog.requested`
- [ ] Produce Kafka event: `ai.blog.generated`
- [ ] Listen to `ai.blog.generated` in CMS Service → auto-publish to Sanity

**Output:** AI-powered content generation pipeline.

---

## 📊 Development Timeline (Estimate)

| Sprint | Duration | Deliverable |
|--------|----------|-------------|
| **Sprint 1** | 1-2 weeks | Infrastructure + CMS Service + Gateway |
| **Sprint 2** | 1 week | Kafka integration + Event flow |
| **Sprint 3** | 1-2 weeks | AI Service + Auto-generation |
| **Sprint 4** | 2 weeks | Blockchain Service (optional) |
| **Sprint 5** | 1 week | Dashboard + Web3 integration |

**Total Phase 1:** ~3-4 weeks of focused development

---

## 🛠️ Tech Stack Decision Matrix

| Service | Language | Framework | Why? |
|---------|----------|-----------|------|
| CMS Service | TypeScript | NestJS | Modular, great Kafka support, type-safe |
| API Gateway | TypeScript | NestJS | Consistent with CMS, excellent routing |
| AI Service | Python | FastAPI | Best for ML/AI libraries, async support |
| Blockchain | TypeScript/Python | NestJS or FastAPI | Web3.js/ethers.js compatibility |
| Payments | Java | Spring Boot | Enterprise-grade, strong transaction support |

---

## 🧩 Agent Behavior Guidelines

If you (the AI agent) are asked to:

- **Add or modify code** → work only inside the relevant service folder  
- **Change architecture or dependencies** → update `/docs/architecture.md` and this file  
- **Introduce new functionality** → document in the relevant `agent.md` + emit new Kafka events if needed  
- **Refactor** → ensure tests pass and interfaces remain stable

All generated code must:

- Respect modular boundaries  
- Include type definitions and docstrings  
- Be deployable within Docker

---

## 🧭 Vision

> Coreflow is a *developer showcase ecosystem* —  
> demonstrating how a single engineer can design, build, and scale a distributed, intelligent, verifiable platform.

Future goals:
- AI agents autonomously manage content & DevOps tasks  
- Decentralized identity (SSI) integration  
- Blockchain-verified creative & professional output  

---

**End of root agent brief.**  
All sub-agents (`apps/*/agent.md`) inherit these principles and must align with this architecture.
