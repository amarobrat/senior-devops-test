#!/bin/bash

# DevOps Test Project - Quick Demo Script
# This script demonstrates the monitoring capabilities without requiring full WordPress setup

echo "🚀 DevOps Test - Quick Demo Setup"
echo "=================================="

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is required for this demo"
    echo "📥 Please install Docker Desktop: https://www.docker.com/products/docker-desktop/"
    echo ""
    echo "🌐 Alternative: Use GitHub Codespaces for instant setup"
    echo "   1. Fork this repository on GitHub"
    echo "   2. Click Code → Codespaces → Create codespace"
    echo "   3. Run this script in the codespace environment"
    exit 1
fi

echo "✅ Docker found! Setting up monitoring stack..."

# Navigate to monitoring directory
cd "$(dirname "$0")/monitoring"

# Start the monitoring stack
echo "📊 Starting Prometheus + Grafana + Alertmanager..."
docker-compose up -d

# Wait for services to start
echo "⏳ Waiting for services to initialize..."
sleep 15

# Check service status
echo "🔍 Checking service status..."
docker-compose ps

echo ""
echo "🎉 Demo setup complete!"
echo ""
echo "📍 Access points:"
echo "   📊 Grafana:      http://localhost:3000 (admin/admin123)"
echo "   🔍 Prometheus:   http://localhost:9090"
echo "   🚨 Alertmanager: http://localhost:9093"
echo ""
echo "📋 What you can explore:"
echo "   ✅ Pre-configured Grafana dashboards"
echo "   ✅ Prometheus metrics and queries"
echo "   ✅ Alert rules and notification setup"
echo "   ✅ Infrastructure monitoring capabilities"
echo ""
echo "🛑 To stop: docker-compose down"
echo "📚 Full documentation: README.md"