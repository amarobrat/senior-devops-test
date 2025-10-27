#!/bin/bash

# DevOps Test - Quick Start Script
# This script quickly configures the development environment

set -e

echo "🚀 DevOps Test - Initial Setup"
echo "==============================="

# Check dependencies
echo "📋 Checking dependencies..."

command -v php >/dev/null 2>&1 || { echo "❌ PHP not found. Install PHP 8.1+"; exit 1; }
command -v composer >/dev/null 2>&1 || { echo "❌ Composer not found. Install Composer"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "❌ Node.js not found. Install Node.js 18+"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "❌ Docker not found. Install Docker"; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo "❌ Docker Compose not found. Install Docker Compose"; exit 1; }

echo "✅ All dependencies found!"

# Configure environment
echo "🔧 Configuring environment..."

if [ ! -f .env ]; then
    cp .env.example .env
    echo "✅ .env file created"
else
    echo "⚠️  .env file already exists"
fi

# Install PHP dependencies
echo "📦 Installing PHP dependencies..."
composer install

# Install Node.js dependencies (root)
echo "📦 Installing Node.js dependencies (root)..."
npm install

# Install Sage theme dependencies
echo "📦 Installing Sage theme dependencies..."
cd web/app/themes/sage-theme
npm install
cd ../../../../

# Build assets
echo "🔨 Building assets..."
npm run build

echo "🔨 Building Sage theme..."
cd web/app/themes/sage-theme
npm run build
cd ../../../../

# Start monitoring
echo "📊 Starting monitoring stack..."
cd monitoring
docker-compose up -d
cd ..

# Check status
echo "🔍 Checking services status..."
sleep 5
cd monitoring
docker-compose ps
cd ..

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📍 Next steps:"
echo "   1. Configure your .env with database credentials"
echo "   2. Configure GitHub Secrets for CI/CD"
echo "   3. Access Grafana: http://localhost:3000 (admin/admin123)"
echo "   4. Access Prometheus: http://localhost:9090"
echo ""
echo "📚 Complete documentation: README.md"