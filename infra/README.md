# 🏗️ CoreFlow Infrastructure

This directory contains the infrastructure configuration for the CoreFlow ecosystem.

## 📋 Services Included

| Service | Port | Description | UI Access |
|---------|------|-------------|-----------|
| **PostgreSQL** | 5432 | Primary database | pgAdmin (5050) |
| **Redis** | 6379 | Cache layer | - |
| **Kafka** | 9092 | Event streaming | Kafka UI (8080) |
| **Zookeeper** | 2181 | Kafka coordination | - |
| **Schema Registry** | 8081 | Kafka schemas | - |

## 🚀 Quick Start

### Prerequisites
- Docker Desktop installed and running
- At least 4GB RAM available
- Ports 5432, 6379, 9092, 5050, 8080, 8081 available

### Start Infrastructure
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes all data)
docker-compose down -v
```

### Verify Services
```bash
# Check service status
docker-compose ps

# Test PostgreSQL connection
docker exec coreflow-postgres psql -U coreflow -d coreflow -c "SELECT version();"

# Test Redis connection
docker exec coreflow-redis redis-cli ping

# Test Kafka connection
docker exec coreflow-kafka kafka-topics --bootstrap-server localhost:9092 --list
```

## 🌐 Access Points

### Management UIs
- **pgAdmin**: http://localhost:5050
  - Email: admin@coreflow.dev
  - Password: admin123
  - Connect to PostgreSQL: host=postgres, port=5432, user=coreflow, password=coreflow123

- **Kafka UI**: http://localhost:8080
  - View topics, messages, and consumer groups
  - Monitor Kafka cluster health

- **Schema Registry**: http://localhost:8081
  - Manage Kafka message schemas
  - API documentation available

### Service Endpoints
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379
- **Kafka**: localhost:9092

## 📊 Database Schema

### Databases Created
- `coreflow` - Main database
- `cms_service` - CMS microservice data
- `api_gateway` - Gateway service data
- `ai_service` - AI service data
- `blockchain_service` - Blockchain service data
- `payments_service` - Payments service data

### Users Created
- `cms_user` - CMS service user
- `gateway_user` - API Gateway user
- `ai_user` - AI service user
- `blockchain_user` - Blockchain service user
- `payments_user` - Payments service user

## 🔄 Kafka Topics

Topics are auto-created when first message is sent:

### Content Events
- `blog.post.created` - New blog post created
- `blog.post.updated` - Blog post updated
- `blog.post.deleted` - Blog post deleted

### AI Events
- `ai.blog.generated` - AI generated new content
- `ai.blog.enhanced` - AI enhanced existing content

### Blockchain Events
- `tx.submitted` - Transaction submitted to blockchain
- `tx.confirmed` - Transaction confirmed on blockchain

### User Events
- `user.authenticated` - User logged in
- `user.registered` - New user registered

### Payment Events
- `payment.processed` - Payment processed

## 🛠️ Development Workflow

### 1. Start Infrastructure
```bash
cd infra
docker-compose up -d
```

### 2. Verify All Services
```bash
# Check all containers are healthy
docker-compose ps

# Check logs for any errors
docker-compose logs
```

### 3. Connect Your Microservices
```bash
# Environment variables for your services
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_DB=coreflow
export POSTGRES_USER=coreflow
export POSTGRES_PASSWORD=coreflow123

export REDIS_HOST=localhost
export REDIS_PORT=6379

export KAFKA_BROKERS=localhost:9092
```

### 4. Monitor and Debug
- Use pgAdmin for database queries
- Use Kafka UI for message monitoring
- Check container logs: `docker-compose logs <service-name>`

## 🔧 Configuration

### Environment Variables
Copy `env.example` to `.env` and customize:
```bash
cp env.example .env
# Edit .env with your preferred settings
```

### Customizing Services
Edit `docker-compose.yml` to:
- Change ports
- Modify resource limits
- Add new services
- Update environment variables

## 🐛 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Check what's using the port
netstat -tulpn | grep :5432

# Stop conflicting services or change ports in docker-compose.yml
```

#### Services Not Starting
```bash
# Check logs
docker-compose logs <service-name>

# Restart specific service
docker-compose restart <service-name>

# Rebuild and restart
docker-compose up -d --build <service-name>
```

#### Database Connection Issues
```bash
# Check if PostgreSQL is ready
docker exec coreflow-postgres pg_isready -U coreflow

# Reset database (WARNING: deletes all data)
docker-compose down -v
docker-compose up -d
```

#### Kafka Connection Issues
```bash
# Check Kafka status
docker exec coreflow-kafka kafka-broker-api-versions --bootstrap-server localhost:9092

# List topics
docker exec coreflow-kafka kafka-topics --bootstrap-server localhost:9092 --list
```

### Performance Tuning

#### Memory Usage
- PostgreSQL: Default 256MB, increase if needed
- Kafka: Default 1GB, increase for production
- Redis: Default 100MB, usually sufficient

#### Disk Usage
- Monitor volumes: `docker system df`
- Clean up unused volumes: `docker volume prune`

## 📚 Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)
- [Apache Kafka Documentation](https://kafka.apache.org/documentation/)
- [Confluent Platform](https://docs.confluent.io/)

## 🔒 Security Notes

⚠️ **This configuration is for DEVELOPMENT only!**

For production:
- Change all default passwords
- Use secrets management
- Enable SSL/TLS
- Configure firewall rules
- Use proper authentication
- Regular security updates

---

**Last Updated:** October 15, 2024  
**Maintainer:** Jean Pierre Farfan Suarez (jeanferfs30@gmail.com)
