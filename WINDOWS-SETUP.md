# Windows Setup Guide - DevOps Test Project

## Quick Setup Options

### Option A: Using Docker (Recommended - No local PHP/Composer needed)
This option allows you to run everything in containers without installing PHP locally.

### Option B: Local Installation
Install PHP, Composer, Node.js directly on Windows.

---

## 🐳 Option A: Docker-Only Approach (Recommended)

### 1. Install Docker Desktop
1. Download Docker Desktop from: https://www.docker.com/products/docker-desktop/
2. Install and start Docker Desktop
3. Verify installation: `docker --version`

### 2. Run Project with Docker
```bash
# Start monitoring stack (this works without PHP/Composer)
cd monitoring
docker-compose up -d

# Check services
docker-compose ps

# Access Grafana: http://localhost:3000 (admin/admin123)
# Access Prometheus: http://localhost:9090
```

### 3. WordPress Setup with Docker
Create a WordPress container for demonstration:
```bash
# Create WordPress development environment
docker run --name wordpress-demo -p 8080:80 -d \
  -e WORDPRESS_DB_HOST=mysql \
  -e WORDPRESS_DB_USER=wordpress \
  -e WORDPRESS_DB_PASSWORD=wordpress \
  -e WORDPRESS_DB_NAME=wordpress \
  wordpress:latest

# Access WordPress: http://localhost:8080
```

---

## 💻 Option B: Local Windows Installation

### 1. Install PHP
```bash
# Using Chocolatey (recommended)
choco install php composer

# Or download from: https://windows.php.net/download/
# Add to PATH: C:\php
```

### 2. Install Composer
```bash
# Download from: https://getcomposer.org/download/
# Or use: choco install composer
```

### 3. Install Node.js
```bash
# Download from: https://nodejs.org/
# Or use: choco install nodejs
```

### 4. Verify Installations
```bash
php --version
composer --version
node --version
npm --version
```

---

## 🚀 Quick Demo Setup (Docker Only)

If you just want to demonstrate the project capabilities:

### 1. Start Monitoring
```powershell
cd c:\DevOps-Wis\monitoring
docker-compose up -d
```

### 2. Create Demo WordPress
```powershell
# Simple WordPress demo
docker run --name wp-demo -p 8080:80 -d wordpress:latest
```

### 3. Access Services
- **Grafana**: http://localhost:3000 (admin/admin123)
- **Prometheus**: http://localhost:9090  
- **WordPress Demo**: http://localhost:8080
- **Alertmanager**: http://localhost:9093

---

## 📊 What This Demonstrates

Even with just Docker, you can showcase:
- ✅ **Monitoring Stack**: Prometheus + Grafana + Alertmanager
- ✅ **Infrastructure as Code**: Docker Compose configurations
- ✅ **DevOps Best Practices**: Containerization, monitoring, alerting
- ✅ **Grafana Dashboards**: Pre-configured monitoring dashboards
- ✅ **CI/CD Pipeline**: GitHub Actions workflow (in code)

---

## 🎯 Next Steps for Full Evaluation

1. **Upload to GitHub**: Show the complete codebase
2. **Create Demo Video**: Record the monitoring in action  
3. **Documentation**: Complete README with screenshots
4. **Portfolio**: Make it available for technical review

This approach demonstrates professional DevOps skills without requiring complex local PHP setup!