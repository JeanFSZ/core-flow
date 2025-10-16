# 🏗️ CoreFlow Infrastructure Overview

## 📊 Current Infrastructure Status

```mermaid
graph TB
    subgraph "Docker Compose Stack - RUNNING ✅"
        subgraph "Database Services"
            PG[(PostgreSQL<br/>Port: 5432<br/>Database: coreflow<br/>Status: Ready)]
            R[(Redis<br/>Port: 6379<br/>Cache Layer<br/>Status: Ready)]
        end
        
        subgraph "Event Streaming"
            Z[Zookeeper<br/>Port: 2181<br/>Kafka Coordination<br/>Status: Ready]
            K[Kafka<br/>Port: 9092<br/>Event Streaming<br/>Status: Ready]
            SR[Schema Registry<br/>Port: 8081<br/>Message Schemas<br/>Status: Ready]
        end
        
        subgraph "Management UIs"
            PA[pgAdmin<br/>Port: 5050<br/>DB Management<br/>Status: Ready]
            KU[Kafka UI<br/>Port: 8080<br/>Event Monitoring<br/>Status: Ready]
        end
        
        subgraph "Network"
            N[coreflow-network<br/>Bridge Network<br/>Status: Active]
        end
    end
    
    subgraph "External Services"
        S[Sanity CMS<br/>sanity.io<br/>Content Management<br/>Status: External]
    end
    
    subgraph "Future Microservices (Not Started)"
        C[CMS Service<br/>Port: 3001<br/>Status: Pending]
        G[API Gateway<br/>Port: 3000<br/>Status: Pending]
        AI[AI Service<br/>Port: 8000<br/>Status: Pending]
        B[Blockchain Service<br/>Port: 3002<br/>Status: Pending]
        P[Payments Service<br/>Port: 8080<br/>Status: Pending]
    end
    
    %% Current connections
    PG -->|Health Check| PA
    K -->|Health Check| KU
    Z -->|Coordination| K
    K -->|Schema Management| SR
    
    %% Network connections
    PG -->|Connected| N
    R -->|Connected| N
    K -->|Connected| N
    Z -->|Connected| N
    SR -->|Connected| N
    PA -->|Connected| N
    KU -->|Connected| N
    
    %% Future connections (dotted)
    C -.->|Future| N
    G -.->|Future| N
    AI -.->|Future| N
    B -.->|Future| N
    P -.->|Future| N
    
    %% External service
    C -.->|Future| S
    
    %% Styling
    classDef running fill:#c8e6c9
    classDef external fill:#e3f2fd
    classDef pending fill:#ffcdd2
    classDef network fill:#fff3e0
    
    class PG,R,Z,K,SR,PA,KU,N running
    class S external
    class C,G,AI,B,P pending
```

## 🔌 Service Endpoints

| Service | Port | URL | Credentials | Purpose |
|---------|------|-----|-------------|---------|
| **PostgreSQL** | 5432 | `localhost:5432` | `coreflow/coreflow123` | Primary database |
| **Redis** | 6379 | `localhost:6379` | No auth | Cache layer |
| **Kafka** | 9092 | `localhost:9092` | No auth | Event streaming |
| **Zookeeper** | 2181 | `localhost:2181` | No auth | Kafka coordination |
| **pgAdmin** | 5050 | http://localhost:5050 | `admin@coreflow.dev/admin123` | DB management |
| **Kafka UI** | 8080 | http://localhost:8080 | No auth | Event monitoring |
| **Schema Registry** | 8081 | http://localhost:8081 | No auth | Message schemas |

## 📊 Database Schema

```mermaid
erDiagram
    DATABASES {
        string coreflow "Main database"
        string cms_service "CMS Service DB"
        string api_gateway "API Gateway DB"
        string ai_service "AI Service DB"
        string blockchain_service "Blockchain Service DB"
        string payments_service "Payments Service DB"
    }
    
    TABLES {
        string users "User management"
        string posts "Blog posts"
        string categories "Post categories"
        string tags "Post tags"
        string events "Event logs"
        string transactions "Blockchain transactions"
        string payments "Payment records"
    }
    
    DATABASES ||--o{ TABLES : contains
```

## 🔄 Kafka Topics (Auto-created)

```mermaid
graph LR
    subgraph "Content Events"
        T1[blog.post.created]
        T2[blog.post.updated]
        T3[blog.post.deleted]
    end
    
    subgraph "AI Events"
        T4[ai.blog.generated]
        T5[ai.blog.enhanced]
    end
    
    subgraph "Transaction Events"
        T6[tx.submitted]
        T7[tx.confirmed]
    end
    
    subgraph "User Events"
        T8[user.authenticated]
        T9[user.registered]
    end
    
    subgraph "Payment Events"
        T10[payment.processed]
    end
    
    %% Styling
    classDef content fill:#e1f5fe
    classDef ai fill:#f3e5f5
    classDef transaction fill:#e8f5e8
    classDef user fill:#fff3e0
    classDef payment fill:#ffebee
    
    class T1,T2,T3 content
    class T4,T5 ai
    class T6,T7 transaction
    class T8,T9 user
    class T10 payment
```

## 🚀 Quick Start Commands

### Start Infrastructure
```bash
# Option 1: Use startup script
cd infra
./start.sh          # Linux/Mac
start.bat           # Windows

# Option 2: Manual Docker Compose
cd infra
docker-compose up -d
```

### Verify Services
```bash
# Check all services
docker-compose ps

# Check specific service logs
docker-compose logs -f postgres
docker-compose logs -f kafka
docker-compose logs -f redis

# Test connections
docker exec coreflow-postgres pg_isready -U coreflow
docker exec coreflow-redis redis-cli ping
docker exec coreflow-kafka kafka-broker-api-versions --bootstrap-server localhost:9092
```

### Stop Infrastructure
```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: Deletes all data)
docker-compose down -v
```

## 🔧 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **Port already in use** | Check if another service is using the port: `netstat -tulpn \| grep :5432` |
| **Docker not running** | Start Docker Desktop and wait for it to be ready |
| **Services not starting** | Check logs: `docker-compose logs [service-name]` |
| **Database connection failed** | Wait 30 seconds for PostgreSQL to fully initialize |
| **Kafka not ready** | Wait for Zookeeper to be ready first, then Kafka |

### Health Checks

```bash
# PostgreSQL
docker exec coreflow-postgres pg_isready -U coreflow

# Redis
docker exec coreflow-redis redis-cli ping

# Kafka
docker exec coreflow-kafka kafka-broker-api-versions --bootstrap-server localhost:9092

# All services status
docker-compose ps
```

## 📈 Resource Usage

### Default Resource Allocation

| Service | CPU | Memory | Storage |
|---------|-----|--------|---------|
| PostgreSQL | 0.5 cores | 512MB | 1GB |
| Redis | 0.1 cores | 128MB | 100MB |
| Kafka | 0.5 cores | 512MB | 1GB |
| Zookeeper | 0.2 cores | 256MB | 100MB |
| pgAdmin | 0.1 cores | 128MB | 50MB |
| Kafka UI | 0.1 cores | 128MB | 50MB |
| Schema Registry | 0.1 cores | 128MB | 50MB |

### Monitoring Commands

```bash
# View resource usage
docker stats

# View disk usage
docker system df

# Clean up unused resources
docker system prune
```

## 🔐 Security Notes

### Current Security Status
- ✅ **Network isolation** with Docker bridge network
- ✅ **No external exposure** (all services on localhost)
- ✅ **Default credentials** for development only
- ⚠️ **Production setup needed** for deployment

### Security Checklist for Production
- [ ] Change default passwords
- [ ] Enable SSL/TLS encryption
- [ ] Configure firewall rules
- [ ] Set up proper authentication
- [ ] Enable audit logging
- [ ] Regular security updates

---

**Last Updated:** October 15, 2024  
**Status:** Infrastructure Complete and Running  
**Next Step:** Start CMS Service Development
