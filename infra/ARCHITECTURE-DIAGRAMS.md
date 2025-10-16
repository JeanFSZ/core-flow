# 🏗️ CoreFlow Architecture Diagrams

This document contains Mermaid diagrams showing the CoreFlow system architecture from different perspectives.

## 📊 Diagram 1: Overall System Architecture

```mermaid
graph TB
    subgraph "Frontend Layer"
        A[Astro Frontend<br/>Portfolio & Blog<br/>localhost:4321]
        D[React Dashboard<br/>Web3 Interface<br/>localhost:3000]
    end
    
    subgraph "API Layer"
        G[API Gateway<br/>NestJS<br/>localhost:3000]
    end
    
    subgraph "Microservices Layer"
        C[CMS Service<br/>NestJS<br/>localhost:3001]
        AI[AI Service<br/>FastAPI<br/>localhost:8000]
        B[Blockchain Service<br/>NestJS<br/>localhost:3002]
        P[Payments Service<br/>Spring Boot<br/>localhost:8080]
    end
    
    subgraph "External Services"
        S[Sanity CMS<br/>Content Management<br/>sanity.io]
    end
    
    subgraph "Infrastructure Layer"
        K[Kafka<br/>Event Streaming<br/>localhost:9092]
        R[Redis<br/>Cache Layer<br/>localhost:6379]
        PG[PostgreSQL<br/>Database<br/>localhost:5432]
    end
    
    subgraph "Management UIs"
        PA[pgAdmin<br/>DB Management<br/>localhost:5050]
        KU[Kafka UI<br/>Event Monitoring<br/>localhost:8080]
        SR[Schema Registry<br/>Message Schemas<br/>localhost:8081]
    end
    
    %% Frontend to API Gateway
    A -->|HTTP/REST| G
    D -->|HTTP/REST| G
    
    %% API Gateway to Microservices
    G -->|Proxy| C
    G -->|Proxy| AI
    G -->|Proxy| B
    G -->|Proxy| P
    
    %% Microservices to External Services
    C -->|GROQ API| S
    
    %% Microservices to Infrastructure
    C -->|SQL| PG
    C -->|Cache| R
    C -->|Events| K
    
    AI -->|SQL| PG
    AI -->|Cache| R
    AI -->|Events| K
    
    B -->|SQL| PG
    B -->|Cache| R
    B -->|Events| K
    
    P -->|SQL| PG
    P -->|Cache| R
    P -->|Events| K
    
    %% Management UIs
    PA -->|Admin| PG
    KU -->|Monitor| K
    SR -->|Manage| K
    
    %% Styling
    classDef frontend fill:#e1f5fe
    classDef api fill:#f3e5f5
    classDef microservice fill:#e8f5e8
    classDef external fill:#fff3e0
    classDef infrastructure fill:#fce4ec
    classDef management fill:#f1f8e9
    
    class A,D frontend
    class G api
    class C,AI,B,P microservice
    class S external
    class K,R,PG infrastructure
    class PA,KU,SR management
```

## 🔄 Diagram 2: Event-Driven Flow

```mermaid
sequenceDiagram
    participant U as User
    participant A as Astro Frontend
    participant G as API Gateway
    participant C as CMS Service
    participant S as Sanity CMS
    participant K as Kafka
    participant AI as AI Service
    
    Note over U,AI: Blog Post Creation Flow
    
    U->>A: Create new blog post
    A->>G: POST /api/cms/posts
    G->>C: Forward request
    C->>S: Create post in Sanity
    S-->>C: Post created
    C->>K: Emit blog.post.created
    C-->>G: Success response
    G-->>A: Success response
    A-->>U: Post created successfully
    
    Note over K,AI: AI Content Generation (Async)
    
    K->>AI: Consume blog.post.created
    AI->>AI: Generate related content
    AI->>K: Emit ai.blog.generated
    K->>C: Consume ai.blog.generated
    C->>S: Auto-publish AI content
```

## 🏗️ Diagram 3: Infrastructure Components

```mermaid
graph TB
    subgraph "Docker Compose Stack"
        subgraph "Database Layer"
            PG[(PostgreSQL<br/>Port: 5432<br/>Database: coreflow)]
            R[(Redis<br/>Port: 6379<br/>Cache Layer)]
        end
        
        subgraph "Event Streaming"
            Z[Zookeeper<br/>Port: 2181<br/>Kafka Coordination]
            K[Kafka<br/>Port: 9092<br/>Event Streaming]
            SR[Schema Registry<br/>Port: 8081<br/>Message Schemas]
        end
        
        subgraph "Management UIs"
            PA[pgAdmin<br/>Port: 5050<br/>DB Management]
            KU[Kafka UI<br/>Port: 8080<br/>Event Monitoring]
        end
        
        subgraph "Network"
            N[coreflow-network<br/>Bridge Network]
        end
    end
    
    subgraph "Microservices (Future)"
        C[CMS Service<br/>Port: 3001]
        G[API Gateway<br/>Port: 3000]
        AI[AI Service<br/>Port: 8000]
        B[Blockchain Service<br/>Port: 3002]
        P[Payments Service<br/>Port: 8080]
    end
    
    %% Connections
    PG -.->|Health Check| PA
    K -.->|Health Check| KU
    Z -->|Coordination| K
    K -->|Schema Management| SR
    
    %% Network connections
    PG -->|Network| N
    R -->|Network| N
    K -->|Network| N
    Z -->|Network| N
    SR -->|Network| N
    PA -->|Network| N
    KU -->|Network| N
    
    %% Future microservices
    C -.->|Future| N
    G -.->|Future| N
    AI -.->|Future| N
    B -.->|Future| N
    P -.->|Future| N
    
    %% Styling
    classDef database fill:#e3f2fd
    classDef streaming fill:#f3e5f5
    classDef management fill:#e8f5e8
    classDef network fill:#fff3e0
    classDef future fill:#fce4ec
    
    class PG,R database
    class Z,K,SR streaming
    class PA,KU management
    class N network
    class C,G,AI,B,P future
```

## 🔐 Diagram 4: Security & Authentication Flow

```mermaid
sequenceDiagram
    participant U as User
    participant A as Astro Frontend
    participant G as API Gateway
    participant AUTH as Auth Service
    participant C as CMS Service
    participant S as Sanity CMS
    
    Note over U,S: Authentication Flow
    
    U->>A: Login request
    A->>AUTH: Authenticate user
    AUTH-->>A: JWT token
    A->>G: API request + JWT
    G->>AUTH: Validate JWT
    AUTH-->>G: Token valid
    G->>C: Forward request
    C->>S: Authorized API call
    S-->>C: Response
    C-->>G: Response
    G-->>A: Response
    A-->>U: Authenticated response
```

## 📊 Diagram 5: Data Flow Architecture

```mermaid
graph LR
    subgraph "Data Sources"
        S[Sanity CMS<br/>Content Data]
        U[User Input<br/>Forms & Actions]
    end
    
    subgraph "Processing Layer"
        C[CMS Service<br/>Content Processing]
        AI[AI Service<br/>Content Generation]
        B[Blockchain Service<br/>Data Verification]
    end
    
    subgraph "Storage Layer"
        PG[(PostgreSQL<br/>Structured Data)]
        R[(Redis<br/>Cache & Sessions)]
        K[Kafka<br/>Event Logs]
    end
    
    subgraph "Presentation Layer"
        A[Astro Frontend<br/>Static Content]
        D[React Dashboard<br/>Dynamic Content]
    end
    
    %% Data flow
    S -->|GROQ API| C
    U -->|HTTP| C
    C -->|SQL| PG
    C -->|Cache| R
    C -->|Events| K
    
    K -->|Consume| AI
    AI -->|Generated Content| C
    AI -->|SQL| PG
    
    K -->|Consume| B
    B -->|Verification| C
    B -->|SQL| PG
    
    PG -->|Query| A
    PG -->|Query| D
    R -->|Cache| A
    R -->|Cache| D
    
    %% Styling
    classDef source fill:#e1f5fe
    classDef process fill:#e8f5e8
    classDef storage fill:#fce4ec
    classDef presentation fill:#fff3e0
    
    class S,U source
    class C,AI,B process
    class PG,R,K storage
    class A,D presentation
```

## 🚀 Diagram 6: Deployment Architecture

```mermaid
graph TB
    subgraph "Development Environment"
        subgraph "Local Docker"
            D1[PostgreSQL]
            D2[Redis]
            D3[Kafka]
            D4[pgAdmin]
            D5[Kafka UI]
        end
        
        subgraph "Local Services"
            L1[CMS Service<br/>localhost:3001]
            L2[API Gateway<br/>localhost:3000]
            L3[AI Service<br/>localhost:8000]
        end
        
        subgraph "External Services"
            E1[Sanity CMS<br/>sanity.io]
        end
    end
    
    subgraph "Production Environment"
        subgraph "Cloud Infrastructure"
            P1[Kubernetes Cluster]
            P2[Load Balancer]
            P3[Database Cluster]
            P4[Redis Cluster]
            P5[Kafka Cluster]
        end
        
        subgraph "Microservices"
            M1[CMS Service<br/>Pod]
            M2[API Gateway<br/>Pod]
            M3[AI Service<br/>Pod]
            M4[Blockchain Service<br/>Pod]
            M5[Payments Service<br/>Pod]
        end
        
        subgraph "External Services"
            E2[Sanity CMS<br/>Production]
            E3[Blockchain Network<br/>Polygon]
            E4[Payment Gateway<br/>Stripe]
        end
    end
    
    %% Development connections
    L1 --> D1
    L1 --> D2
    L1 --> D3
    L1 --> E1
    L2 --> L1
    L3 --> D1
    L3 --> D3
    
    %% Production connections
    P2 --> M2
    M2 --> M1
    M2 --> M3
    M2 --> M4
    M2 --> M5
    M1 --> P3
    M1 --> P4
    M1 --> P5
    M1 --> E2
    M4 --> E3
    M5 --> E4
    
    %% Styling
    classDef dev fill:#e3f2fd
    classDef prod fill:#e8f5e8
    classDef external fill:#fff3e0
    
    class D1,D2,D3,D4,D5,L1,L2,L3 dev
    class P1,P2,P3,P4,P5,M1,M2,M3,M4,M5 prod
    class E1,E2,E3,E4 external
```

## 📈 Diagram 7: Monitoring & Observability

```mermaid
graph TB
    subgraph "Application Layer"
        A[Astro Frontend]
        D[React Dashboard]
        G[API Gateway]
        C[CMS Service]
        AI[AI Service]
    end
    
    subgraph "Infrastructure Layer"
        PG[PostgreSQL]
        R[Redis]
        K[Kafka]
    end
    
    subgraph "Monitoring Stack"
        M1[Prometheus<br/>Metrics Collection]
        M2[Grafana<br/>Dashboards]
        M3[Jaeger<br/>Distributed Tracing]
        M4[ELK Stack<br/>Log Aggregation]
    end
    
    subgraph "Alerting"
        A1[AlertManager<br/>Notification Rules]
        A2[Slack/Email<br/>Alerts]
    end
    
    %% Monitoring connections
    A -->|Metrics| M1
    D -->|Metrics| M1
    G -->|Metrics| M1
    C -->|Metrics| M1
    AI -->|Metrics| M1
    
    A -->|Traces| M3
    G -->|Traces| M3
    C -->|Traces| M3
    AI -->|Traces| M3
    
    A -->|Logs| M4
    D -->|Logs| M4
    G -->|Logs| M4
    C -->|Logs| M4
    AI -->|Logs| M4
    
    PG -->|Metrics| M1
    R -->|Metrics| M1
    K -->|Metrics| M1
    
    M1 -->|Query| M2
    M1 -->|Alerts| A1
    A1 -->|Notify| A2
    
    %% Styling
    classDef app fill:#e1f5fe
    classDef infra fill:#f3e5f5
    classDef monitoring fill:#e8f5e8
    classDef alerting fill:#ffebee
    
    class A,D,G,C,AI app
    class PG,R,K infra
    class M1,M2,M3,M4 monitoring
    class A1,A2 alerting
```

## 🛠️ How to Use These Diagrams

### Online Tools
1. **Mermaid Live Editor**: https://mermaid.live/
2. **GitHub/GitLab**: Paste the code in markdown files
3. **VS Code**: Install Mermaid extension

### Local Tools
1. **VS Code**: Install "Mermaid Preview" extension
2. **Obsidian**: Native Mermaid support
3. **Notion**: Supports Mermaid diagrams

### Export Options
- PNG/SVG from Mermaid Live Editor
- PDF from VS Code with Mermaid extension
- Interactive diagrams in GitHub/GitLab

---

**Last Updated:** October 15, 2024  
**Maintainer:** Jean Pierre Farfan Suarez (jeanferfs30@gmail.com)
