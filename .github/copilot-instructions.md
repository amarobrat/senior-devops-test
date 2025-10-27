# DevOps Test Project - Copilot Instructions

## Project Overview
This is a Senior DevOps Test project that demonstrates:
- WordPress Bedrock deployment automation
- CI/CD with GitHub Actions (parallel builds, caching)
- GCP deployment (Compute Engine/GKE/Cloud Run)
- Monitoring with Prometheus and Grafana
- Infrastructure as Code best practices

## Project Structure
```
├── .github/
│   └── workflows/
│       └── deploy.yml              # CI/CD pipeline
├── web/
│   └── app/
│       └── themes/
│           └── sage-theme/         # Sage theme
├── monitoring/
│   ├── docker-compose.yml          # Prometheus + Grafana
│   ├── prometheus/
│   │   └── prometheus.yml          # Prometheus config
│   └── grafana/
│       └── dashboards/             # Pre-provisioned dashboards
├── infrastructure/                 # Terraform/Ansible (bonus)
├── composer.json                   # Bedrock dependencies
├── package.json                    # Frontend dependencies
└── README.md                       # Complete setup guide
```

## Technology Stack
- **Base**: WordPress Bedrock (Composer-based WP)
- **Theme**: Sage (Laravel Blade + Webpack)
- **Plugins**: Yoast SEO, WooCommerce
- **CI/CD**: GitHub Actions with parallel builds
- **Deployment**: GCP (Compute Engine preferred)
- **Monitoring**: Prometheus + Grafana + Node Exporter
- **Containerization**: Docker Compose

## Development Guidelines
- Follow WordPress coding standards
- Use semantic versioning for releases
- Implement proper error handling and logging
- Include comprehensive health checks
- Secure secrets management with GitHub Secrets
- Optimize for performance and scalability

## Deployment Requirements
- Health check validation after deployment
- Rollback mechanism on failure
- Zero-downtime deployment strategy
- Monitoring integration from day 1