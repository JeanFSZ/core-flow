#!/bin/bash
# CoreFlow Server Deployment Script
# For VPS/Dedicated Server deployment

set -e

echo "🚀 Starting CoreFlow Server Deployment..."
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COREFLOW_DIR="/opt/coreflow"
DOMAIN="yourdomain.com"
EMAIL="admin@yourdomain.com"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root. Please run as a regular user with sudo privileges."
   exit 1
fi

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
    print_error "sudo is not installed. Please install it first."
    exit 1
fi

print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

print_status "Installing essential packages..."
sudo apt install -y curl wget git unzip software-properties-common apt-transport-https ca-certificates gnupg lsb-release

print_status "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo rm get-docker.sh
    print_success "Docker installed successfully"
else
    print_warning "Docker is already installed"
fi

print_status "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose installed successfully"
else
    print_warning "Docker Compose is already installed"
fi

print_status "Installing Node.js 18..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    print_success "Node.js installed successfully"
else
    print_warning "Node.js is already installed: $(node --version)"
fi

print_status "Installing PM2..."
if ! command -v pm2 &> /dev/null; then
    sudo npm install -g pm2
    print_success "PM2 installed successfully"
else
    print_warning "PM2 is already installed"
fi

print_status "Installing Nginx..."
if ! command -v nginx &> /dev/null; then
    sudo apt install -y nginx
    sudo systemctl enable nginx
    print_success "Nginx installed successfully"
else
    print_warning "Nginx is already installed"
fi

print_status "Installing Certbot for SSL..."
if ! command -v certbot &> /dev/null; then
    sudo apt install -y certbot python3-certbot-nginx
    print_success "Certbot installed successfully"
else
    print_warning "Certbot is already installed"
fi

print_status "Creating CoreFlow directory structure..."
sudo mkdir -p $COREFLOW_DIR/{apps,infra,logs,scripts,ssl}
sudo chown -R $USER:$USER $COREFLOW_DIR

print_status "Setting up firewall..."
sudo ufw --force enable
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw deny 3000:8080/tcp  # Block direct access to microservices
print_success "Firewall configured"

print_status "Copying infrastructure files..."
cp docker-compose.yml $COREFLOW_DIR/infra/
cp env.example $COREFLOW_DIR/.env
cp start.sh $COREFLOW_DIR/scripts/
cp start.bat $COREFLOW_DIR/scripts/
chmod +x $COREFLOW_DIR/scripts/start.sh

print_status "Setting up environment variables..."
if [ ! -f "$COREFLOW_DIR/.env" ]; then
    cp env.example $COREFLOW_DIR/.env
    print_warning "Please edit $COREFLOW_DIR/.env with your configuration"
fi

print_status "Starting infrastructure services..."
cd $COREFLOW_DIR/infra
docker-compose up -d

print_status "Waiting for services to be ready..."
sleep 30

print_status "Checking service status..."
docker-compose ps

print_status "Creating PM2 ecosystem configuration..."
cat > $COREFLOW_DIR/ecosystem.config.js << 'EOF'
module.exports = {
  apps: [
    {
      name: 'api-gateway',
      script: 'dist/main.js',
      cwd: '/opt/coreflow/apps/api-gateway',
      instances: 2,
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      log_file: '/opt/coreflow/logs/api-gateway.log',
      error_file: '/opt/coreflow/logs/api-gateway-error.log',
      out_file: '/opt/coreflow/logs/api-gateway-out.log',
      time: true
    },
    {
      name: 'cms-service',
      script: 'dist/main.js',
      cwd: '/opt/coreflow/apps/cms-service',
      instances: 2,
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        PORT: 3001
      },
      log_file: '/opt/coreflow/logs/cms-service.log',
      error_file: '/opt/coreflow/logs/cms-service-error.log',
      out_file: '/opt/coreflow/logs/cms-service-out.log',
      time: true
    },
    {
      name: 'ai-service',
      script: 'main.py',
      cwd: '/opt/coreflow/apps/ai-service',
      interpreter: 'python3',
      instances: 1,
      env: {
        NODE_ENV: 'production',
        PORT: 8000
      },
      log_file: '/opt/coreflow/logs/ai-service.log',
      error_file: '/opt/coreflow/logs/ai-service-error.log',
      out_file: '/opt/coreflow/logs/ai-service-out.log',
      time: true
    },
    {
      name: 'blockchain-service',
      script: 'dist/main.js',
      cwd: '/opt/coreflow/apps/blockchain-service',
      instances: 1,
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        PORT: 3002
      },
      log_file: '/opt/coreflow/logs/blockchain-service.log',
      error_file: '/opt/coreflow/logs/blockchain-service-error.log',
      out_file: '/opt/coreflow/logs/blockchain-service-out.log',
      time: true
    },
    {
      name: 'payments-service',
      script: 'target/payments-service.jar',
      cwd: '/opt/coreflow/apps/payments-service',
      interpreter: 'java',
      instances: 1,
      env: {
        NODE_ENV: 'production',
        PORT: 8080
      },
      log_file: '/opt/coreflow/logs/payments-service.log',
      error_file: '/opt/coreflow/logs/payments-service-error.log',
      out_file: '/opt/coreflow/logs/payments-service-out.log',
      time: true
    }
  ]
};
EOF

print_status "Creating Nginx configuration..."
sudo tee /etc/nginx/sites-available/coreflow > /dev/null << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN www.$DOMAIN;
    
    # SSL Configuration (will be updated by certbot)
    ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
    ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;
    
    # Security headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    # Frontend (Astro) - will be configured after build
    location / {
        root /opt/coreflow/apps/coreflow-astro/dist;
        try_files \$uri \$uri/ /index.html;
        
        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
    
    # API Gateway
    location /api/ {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
    
    # Dashboard (React)
    location /dashboard {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
    
    # Management UIs (Restricted)
    location /pgadmin {
        allow 127.0.0.1;
        deny all;
        proxy_pass http://localhost:5050;
    }
    
    location /kafka-ui {
        allow 127.0.0.1;
        deny all;
        proxy_pass http://localhost:8080;
    }
}
EOF

print_status "Enabling Nginx site..."
sudo ln -sf /etc/nginx/sites-available/coreflow /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t

print_status "Creating monitoring scripts..."
cat > $COREFLOW_DIR/scripts/health-check.sh << 'EOF'
#!/bin/bash
echo "🔍 CoreFlow Health Check - $(date)"
echo "=================================="

echo "📊 Docker Services:"
docker-compose ps

echo ""
echo "📊 PM2 Processes:"
pm2 status

echo ""
echo "📊 System Resources:"
echo "Memory:"
free -h
echo ""
echo "Disk:"
df -h

echo ""
echo "📊 Recent Errors:"
tail -n 20 /opt/coreflow/logs/*.log | grep -i error || echo "No recent errors found"

echo ""
echo "📊 Service Endpoints:"
echo "Frontend: http://localhost (via Nginx)"
echo "API Gateway: http://localhost:3000"
echo "pgAdmin: http://localhost:5050"
echo "Kafka UI: http://localhost:8080"
EOF

chmod +x $COREFLOW_DIR/scripts/health-check.sh

cat > $COREFLOW_DIR/scripts/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/backups/coreflow"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

echo "🔄 Starting backup..."

# Backup database
docker exec coreflow-postgres pg_dump -U coreflow coreflow > $BACKUP_DIR/database_$DATE.sql

# Backup application files
tar -czf $BACKUP_DIR/apps_$DATE.tar.gz /opt/coreflow/apps

# Backup logs
tar -czf $BACKUP_DIR/logs_$DATE.tar.gz /opt/coreflow/logs

# Clean old backups (keep last 7 days)
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "✅ Backup completed: $BACKUP_DIR"
EOF

chmod +x $COREFLOW_DIR/scripts/backup.sh

print_status "Setting up log rotation..."
sudo tee /etc/logrotate.d/coreflow > /dev/null << EOF
/opt/coreflow/logs/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 $USER $USER
    postrotate
        pm2 reloadLogs
    endscript
}
EOF

print_status "Creating systemd service for PM2..."
sudo tee /etc/systemd/system/coreflow.service > /dev/null << EOF
[Unit]
Description=CoreFlow PM2 Process Manager
After=network.target

[Service]
Type=forking
User=$USER
WorkingDirectory=$COREFLOW_DIR
ExecStart=/usr/bin/pm2 start $COREFLOW_DIR/ecosystem.config.js
ExecReload=/usr/bin/pm2 reload all
ExecStop=/usr/bin/pm2 stop all
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable coreflow

print_success "Server deployment completed!"
echo ""
echo "🎯 Next Steps:"
echo "1. Edit $COREFLOW_DIR/.env with your configuration"
echo "2. Clone your microservice repositories to $COREFLOW_DIR/apps/"
echo "3. Build and start your services:"
echo "   cd $COREFLOW_DIR/apps/[service-name]"
echo "   npm install && npm run build"
echo "   pm2 start ecosystem.config.js"
echo "4. Setup SSL certificate:"
echo "   sudo certbot --nginx -d $DOMAIN"
echo "5. Test your deployment:"
echo "   $COREFLOW_DIR/scripts/health-check.sh"
echo ""
echo "📊 Service URLs:"
echo "Frontend: http://$DOMAIN"
echo "API Gateway: http://$DOMAIN/api"
echo "pgAdmin: http://$DOMAIN/pgadmin (restricted)"
echo "Kafka UI: http://$DOMAIN/kafka-ui (restricted)"
echo ""
echo "🔧 Management Commands:"
echo "Health Check: $COREFLOW_DIR/scripts/health-check.sh"
echo "Backup: $COREFLOW_DIR/scripts/backup.sh"
echo "PM2 Status: pm2 status"
echo "PM2 Logs: pm2 logs"
echo "Docker Status: docker-compose ps"
echo ""
print_success "CoreFlow server is ready for microservice deployment!"
