# DevOps Test Project - Windows Quick Demo
# PowerShell script for Windows users

Write-Host "🚀 DevOps Test - Windows Quick Demo" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# Check if Docker is available
try {
    $dockerVersion = docker --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker not found"
    }
    Write-Host "✅ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is required for this demo" -ForegroundColor Red
    Write-Host "📥 Please install Docker Desktop: https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🌐 Alternative: Use GitHub Codespaces for instant setup" -ForegroundColor Cyan
    Write-Host "   1. Fork this repository on GitHub" -ForegroundColor White
    Write-Host "   2. Click Code → Codespaces → Create codespace" -ForegroundColor White
    Write-Host "   3. Run: chmod +x quick-demo.sh && ./quick-demo.sh" -ForegroundColor White
    Write-Host ""
    Write-Host "⏸️  Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Navigate to monitoring directory
$monitoringPath = Join-Path $PSScriptRoot "monitoring"
if (-not (Test-Path $monitoringPath)) {
    Write-Host "❌ Monitoring directory not found: $monitoringPath" -ForegroundColor Red
    exit 1
}

Set-Location $monitoringPath

# Start the monitoring stack
Write-Host "📊 Starting Prometheus + Grafana + Alertmanager..." -ForegroundColor Cyan
docker-compose up -d

# Wait for services to start
Write-Host "⏳ Waiting for services to initialize..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Check service status
Write-Host "🔍 Checking service status..." -ForegroundColor Cyan
docker-compose ps

Write-Host ""
Write-Host "🎉 Demo setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📍 Access points:" -ForegroundColor White
Write-Host "   📊 Grafana:      http://localhost:3000 (admin/admin123)" -ForegroundColor Cyan
Write-Host "   🔍 Prometheus:   http://localhost:9090" -ForegroundColor Cyan
Write-Host "   🚨 Alertmanager: http://localhost:9093" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 What you can explore:" -ForegroundColor White
Write-Host "   ✅ Pre-configured Grafana dashboards" -ForegroundColor Green
Write-Host "   ✅ Prometheus metrics and queries" -ForegroundColor Green
Write-Host "   ✅ Alert rules and notification setup" -ForegroundColor Green
Write-Host "   ✅ Infrastructure monitoring capabilities" -ForegroundColor Green
Write-Host ""
Write-Host "🛑 To stop: docker-compose down" -ForegroundColor Red
Write-Host "📚 Full documentation: README.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "⏸️  Press any key to open Grafana in browser..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Try to open Grafana in default browser
try {
    Start-Process "http://localhost:3000"
    Write-Host "🌐 Grafana opened in your default browser!" -ForegroundColor Green
} catch {
    Write-Host "📱 Please manually open: http://localhost:3000" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎯 Next steps:" -ForegroundColor White
Write-Host "   1. Login to Grafana (admin/admin123)" -ForegroundColor White
Write-Host "   2. Explore the pre-configured dashboards" -ForegroundColor White
Write-Host "   3. Check Prometheus metrics at http://localhost:9090" -ForegroundColor White
Write-Host "   4. Review alert rules in Alertmanager" -ForegroundColor White