@echo off
REM CoreFlow Infrastructure Startup Script for Windows
REM This script starts the CoreFlow infrastructure and verifies all services

echo 🏗️  Starting CoreFlow Infrastructure...
echo ========================================

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: Docker is not running. Please start Docker Desktop and try again.
    pause
    exit /b 1
)

REM Check if docker-compose is available
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Error: docker-compose is not installed. Please install Docker Compose.
    pause
    exit /b 1
)

REM Start services
echo 🚀 Starting services...
docker-compose up -d

REM Wait for services to be ready
echo ⏳ Waiting for services to be ready...
timeout /t 10 /nobreak >nul

REM Check service status
echo 📊 Checking service status...
docker-compose ps

REM Test connections
echo 🔍 Testing service connections...

REM Test PostgreSQL
echo   Testing PostgreSQL...
docker exec coreflow-postgres pg_isready -U coreflow >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ PostgreSQL is ready
) else (
    echo   ❌ PostgreSQL is not ready
)

REM Test Redis
echo   Testing Redis...
docker exec coreflow-redis redis-cli ping >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Redis is ready
) else (
    echo   ❌ Redis is not ready
)

REM Test Kafka
echo   Testing Kafka...
docker exec coreflow-kafka kafka-broker-api-versions --bootstrap-server localhost:9092 >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Kafka is ready
) else (
    echo   ❌ Kafka is not ready
)

echo.
echo 🌐 Service Access Points:
echo   📊 pgAdmin:     http://localhost:5050 (admin@coreflow.dev / admin123)
echo   📈 Kafka UI:    http://localhost:8080
echo   🔧 Schema Registry: http://localhost:8081
echo.
echo 🔌 Service Endpoints:
echo   🗄️  PostgreSQL: localhost:5432
echo   ⚡ Redis:      localhost:6379
echo   📨 Kafka:      localhost:9092
echo.
echo ✅ CoreFlow Infrastructure is running!
echo    Use 'docker-compose logs -f' to view logs
echo    Use 'docker-compose down' to stop services
echo.
pause
