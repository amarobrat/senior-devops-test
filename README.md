# Senior DevOps Test Project

## 🎯 Objective
This project demonstrates advanced DevOps skills through the implementation of:
- **WordPress Bedrock** with Sage theme
- **Automated CI/CD** with GitHub Actions (parallel builds, efficient caching)
- **GCP deployment** (Compute Engine/GKE/Cloud Run)
- **Complete monitoring** with Prometheus and Grafana
- **Infrastructure as Code** with best practices

## 🏗️ Project Architecture

```
├── .github/
│   ├── workflows/
│   │   └── deploy.yml              # Pipeline CI/CD
│   └── copilot-instructions.md     # Project instructions
├── web/
│   ├── app/
│   │   ├── themes/
│   │   │   └── sage-theme/         # Sage theme with Blade
│   │   └── plugins/                # Plugins WordPress
│   ├── index.php
│   └── wp-config.php
├── monitoring/
│   ├── docker-compose.yml          # Monitoring stack
│   ├── prometheus/
│   │   ├── prometheus.yml          # Prometheus configuration
│   │   ├── alert_rules.yml         # Alert rules
│   │   ├── blackbox.yml            # HTTP checks configuration
│   │   └── alertmanager.yml        # Alert configuration
│   └── grafana/
│       ├── provisioning/           # Automatic configuration
│       └── dashboards/             # Pre-configured dashboards
├── infrastructure/                 # Terraform/Ansible (bonus)
├── config/
│   ├── application.php             # Bedrock configuration
│   └── environments/               # Environment configurations
├── composer.json                   # PHP dependencies
├── package.json                    # Node.js dependencies
└── README.md                       # This documentation
```

## 🚀 Technology Stack

### Base
- **WordPress Bedrock** - Modern WordPress framework with Composer
- **Sage Theme** - Theme with Laravel Blade, Webpack and Sass
- **PHP 8.1+** - Backend language
- **Node.js 18+** - Frontend build tools

### Included Plugins
- **Yoast SEO** - Search engine optimization
- **WooCommerce** - Complete e-commerce solution

### CI/CD
- **GitHub Actions** - Deploy automation
- **Parallel builds** - Performance optimization
- **Smart caching** - Composer and npm
- **Rollback strategy** - Deploy Security

### Deploy & Infrastructure
- **GCP Compute Engine** (preferred)
- **GKE** (Kubernetes)
- **Cloud Run** (serverless alternative)
- **Nginx** - Web server
- **PHP-FPM** - Process manager

### Monitoring
- **Prometheus** - Metrics collection
- **Grafana** - Visualization and dashboards
- **Node Exporter** - System metrics
- **cAdvisor** - Container metrics
- **Blackbox Exporter** - HTTP monitoring
- **Alertmanager** - Alert management

## ⚡ Quick Start

### 1. Prerequisites
```bash
# Install local dependencies
php >= 8.1
composer
node.js >= 18
docker & docker-compose
gcloud CLI (for GCP)
```

### 2. Local Setup
```bash
# Clone the repository
git clone <repository-url>
cd DevOps-Wis

# Install PHP dependencies
composer install

# Install Node.js dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with your settings

# Build assets
npm run build

# Build Sage theme
cd web/app/themes/sage-theme
npm install
npm run build
cd ../../../../
```

### 3. Start Monitoring
```bash
# Start monitoring stack
cd monitoring
docker-compose up -d

# Check services
docker-compose ps
```

**Access Points:**
- Grafana: http://localhost:3000 (admin/admin123)
- Prometheus: http://localhost:9090
- Alertmanager: http://localhost:9093

## 🔧 Deploy Configuration

### Required GitHub Secrets

#### For GCP Compute Engine:
```bash
GCP_SA_KEY              # Service Account JSON key
GCP_PROJECT_ID          # GCP project ID
GCP_INSTANCE_NAME       # Instance name
GCP_ZONE               # Instance zone (e.g: us-central1-a)
STAGING_URL            # Staging environment URL
PRODUCTION_URL         # Production environment URL
```

#### For notifications (optional):
```bash
SLACK_WEBHOOK          # Slack webhook for notifications
```

### GCP Configuration

#### 1. Create Service Account
```bash
# Create service account
gcloud iam service-accounts create bedrock-deploy \
    --description="Service account for Bedrock deployment" \
    --display-name="Bedrock Deploy"

# Grant necessary permissions
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:bedrock-deploy@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/compute.instanceAdmin.v1"

# Generate JSON key
gcloud iam service-accounts keys create key.json \
    --iam-account=bedrock-deploy@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

#### 2. Create Compute Engine Instance
```bash
# Create instance
gcloud compute instances create wordpress-server \
    --zone=us-central1-a \
    --machine-type=e2-medium \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=20GB \
    --tags=http-server,https-server

# Configure firewall
gcloud compute firewall-rules create allow-wordpress \
    --allow tcp:80,tcp:443 \
    --source-ranges 0.0.0.0/0 \
    --target-tags http-server,https-server
```

#### 3. Server Setup
```bash
# SSH into instance
gcloud compute ssh wordpress-server --zone=us-central1-a

# Install dependencies
sudo apt update
sudo apt install -y nginx php8.1-fpm php8.1-mysql php8.1-xml php8.1-mbstring php8.1-curl php8.1-zip mysql-server

# Configure Nginx (see configurations in monitoring/ folder)
# Configure PHP-FPM
# Configure MySQL
# Create backup directories
sudo mkdir -p /backup
sudo chown www-data:www-data /var/www/html
```

## 🔄 Pipeline CI/CD

### Triggers
- **Push to main** → Deploy production
- **Push to develop** → Deploy staging  
- **Manual dispatch** → Deploy chosen environment
- **Pull Request** → Only Tests

### Stages

#### 1. **Test Stage**
- Setup PHP 8.1 + extensions
- Cache Composer inteligent
- Dependencies installation
- Linting PHP (PHPStan/PHPCS)

#### 2. **Build Assets (Paralelo)**
- Setup Node.js 18
- Cache npm optimized
- Build assets root
- Build tema Sage
- Upload artifacts

#### 3. **Create Release**
- Production installation (--no-dev)
- Download de artifacts
- Creation packges deployment
- Optimezed compression

#### 4. **Deploy**
- Authentication GCP
- Automatic backup (production)
- Deploy with rsync
- Reload services
- Health checks
- Automatic rollback (failure)

### Strategy of Cache

#### Composer Cache
```yaml
key: ${{ runner.os }}-composer-${{ hashFiles('**/composer.lock') }}
restore-keys: ${{ runner.os }}-composer-
```

#### NPM Cache
```yaml  
key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
restore-keys: ${{ runner.os }}-node-
```

## 📊 Monitoring and Observability

### Collected Metrics

#### System (Node Exporter)
- CPU, Memory, Disk
- Network I/O
- Load average
- Filesystem usage

#### Containers (cAdvisor)
- CPU/Memory por container
- Network/Disk I/O
- Container status

#### HTTP (Blackbox Exporter)
- Site availability
- Response time
- Status codes
- SSL certificate

#### Nginx (Nginx Exporter)
- Requests/second
- Response times
- Status code distribution
- Active connections

### Dashboards Grafana

#### 1. **WordPress Infrastructure Monitoring**
- CPU e Memory usage
- Disk utilization
- Site availability gauge
- HTTP response times

#### 2. **WordPress Application Performance**
- HTTP request rates
- Status code distribution
- Container metrics
- Application-specific KPIs

### Alertas Configurados

#### Critical
- Site down (>2min)
- Disk space < 15%
- Container down

#### Warning  
- High CPU > 80% (5min)
- High memory > 85% (5min)
- Slow response > 5s (2min)

## 🔒 Security

### Secrets Management
- GitHub Secrets for credentials
- Environment variables
- Regular key rotation

### WordPress Configuration
```php
// Disable file editor
define('DISALLOW_FILE_EDIT', true);

// Disable install plugins via admin
define('DISALLOW_FILE_MODS', true);

// Force HTTPS
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}
```

### Nginx Hardening
- Rate limiting
- Security headers
- SSL/TLS configuration
- Access log monitoring

## 🧪 Tests e Validation

### Health Checks
```bash
# WordPress availability
curl -f $SITE_URL/wp-admin/admin-ajax.php

# Database connection  
curl -f $SITE_URL/wp-json/wp/v2/posts

# Theme assets
curl -f $SITE_URL/wp-content/themes/sage-theme/public/main.css
```

### Performance Tests
```bash
# Load testing with Apache Bench
ab -n 1000 -c 10 http://your-site.com/

# Lighthouse CI for web metrics
npm install -g @lhci/cli
lhci autorun
```

## 🎛️ Useful Commands

### Local Development
```bash
# Watch mode for development
npm run dev                          # Root assets
cd web/app/themes/sage-theme && npm run dev  # Sage theme

# Linting
composer run lint                    # PHP
npm run lint                        # JavaScript

# Testing
composer run test                   # PHP tests
npm run test                       # JS tests
```

### Monitoring
```bash
# View container logs
docker-compose -f monitoring/docker-compose.yml logs -f grafana
docker-compose -f monitoring/docker-compose.yml logs -f prometheus

# Restart services
docker-compose -f monitoring/docker-compose.yml restart

# Backup Grafana configurations
docker exec grafana grafana-cli admin export-dashboard > backup.json
```

### Manual Deploy
```bash
# Complete build
composer install --no-dev --optimize-autoloader
npm run build
cd web/app/themes/sage-theme && npm run build

# Create package
tar --exclude-from=.deployignore -czf deploy.tar.gz .

# Deploy via rsync (example)
rsync -avz --delete deploy/ user@server:/var/www/html/
```

## 📈 Performance Metrics

### SLA Targets
- **Availability**: 99.9%
- **Response time**: < 2s (95th percentile)
- **MTTR**: < 5 minutes
- **Deploy time**: < 10 minutes

### Monitoring KPIs
- Monthly uptime
- Page load time
- Error rate (< 0.1%)
- CPU/Memory utilization
- Disk space usage

## 🔧 Troubleshooting

### Deploy Issues
```bash
# View GitHub Actions logs
# Check in repository Actions tab

# Verify GCP connectivity
gcloud compute instances list
gcloud compute ssh instance-name --dry-run

# Test manual health check
curl -v http://your-site.com/wp-admin/admin-ajax.php
```

### Monitoring Issues  
```bash
# Check container status
docker-compose -f monitoring/docker-compose.yml ps

# Verify Prometheus configuration
curl http://localhost:9090/-/healthy

# Test Prometheus queries
curl 'http://localhost:9090/api/v1/query?query=up'
```

### WordPress Issues
```bash
# Debug mode (development only)
# In .env: WP_DEBUG=true

# Check logs
tail -f web/wp-content/debug.log

# Check permissions
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
```

## 🏆 Evaluation Criteria Met

### ✅ CI/CD Pipeline
- [x] Automatic and manual triggers
- [x] Parallel builds (Composer + NPM)
- [x] Efficient cache with TTLs
- [x] Release artifacts
- [x] Automated GCP deploy
- [x] Health checks
- [x] Automatic rollback

### ✅ Monitoring
- [x] Prometheus + Node Exporter + cAdvisor  
- [x] Grafana with dashboards
- [x] HTTP monitoring via Blackbox
- [x] Configured alerts
- [x] Automatic provisioning

### ✅ Infrastructure
- [x] WordPress Bedrock
- [x] Configured Sage theme
- [x] Plugins (Yoast SEO + WooCommerce)
- [x] GCP deployment ready
- [x] Secrets management

### ✅ Bonus Features  
- [x] Alertmanager for notifications
- [x] Multiple deployment targets
- [x] Infrastructure monitoring
- [x] Performance dashboards
- [x] Security hardening

## 📚 Additional Documentation

### Project Documentation
- [📋 Executive Summary](EXECUTIVE-SUMMARY.md) - Key achievements and business value
- [🏆 Evaluation Guide](EVALUATION-GUIDE.md) - Technical skills demonstration
- [🚀 Deployment Guide](DEPLOYMENT-GUIDE.md) - Quick setup for evaluators
- [💻 Windows Setup](WINDOWS-SETUP.md) - Local development on Windows

### External References
- [Bedrock Documentation](https://roots.io/bedrock/)
- [Sage Theme Guide](https://roots.io/sage/)
- [Prometheus Configuration](https://prometheus.io/docs/prometheus/latest/configuration/)
- [Grafana Provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/)
- [GitHub Actions](https://docs.github.com/en/actions)

### Next Steps
1. **SSL/TLS**: Configure Let's Encrypt certificates
2. **CDN**: Implement CloudFlare or GCP CDN
3. **Backup**: Automate DB and files backups
4. **Scaling**: Configure auto-scaling on GKE
5. **Security**: WAF and security monitoring

---

**Developed by**: DevOps Test - Amaro Lima  
**Date**: October 2025  
**Version**: 1.0.0