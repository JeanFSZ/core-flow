#!/bin/bash

# CoreFlow Infrastructure Startup Script
# This script starts the CoreFlow infrastructure and verifies all services

set -e

echo "🏗️  Starting CoreFlow Infrastructure..."
echo "========================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Error: docker-compose is not installed. Please install Docker Compose."
    exit 1
fi

# Start services
echo "🚀 Starting services..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check service status
echo "📊 Checking service status..."
docker-compose ps

# Test connections
echo "🔍 Testing service connections..."

# Test PostgreSQL
echo "  Testing PostgreSQL..."
if docker exec coreflow-postgres pg_isready -U coreflow > /dev/null 2>&1; then
    echo "  ✅ PostgreSQL is ready"
else
    echo "  ❌ PostgreSQL is not ready"
fi

# Test Redis
echo "  Testing Redis..."
if docker exec coreflow-redis redis-cli ping > /dev/null 2>&1; then
    echo "  ✅ Redis is ready"
else
    echo "  ❌ Redis is not ready"
fi

# Test Kafka
echo "  Testing Kafka..."
if docker exec coreflow-kafka kafka-broker-api-versions --bootstrap-server localhost:9092 > /dev/null 2>&1; then
    echo "  ✅ Kafka is ready"
else
    echo "  ❌ Kafka is not ready"
fi

echo ""
echo "🌐 Service Access Points:"
echo "  📊 pgAdmin:     http://localhost:5050 (admin@coreflow.dev / admin123)"
echo "  📈 Kafka UI:    http://localhost:8080"
echo "  🔧 Schema Registry: http://localhost:8081"
echo ""
echo "🔌 Service Endpoints:"
echo "  🗄️  PostgreSQL: localhost:5432"
echo "  ⚡ Redis:      localhost:6379"
echo "  📨 Kafka:      localhost:9092"
echo ""
echo "✅ CoreFlow Infrastructure is running!"
echo "   Use 'docker-compose logs -f' to view logs"
echo "   Use 'docker-compose down' to stop services"
