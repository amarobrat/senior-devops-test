# Terraform configuration for GCP WordPress deployment
# This is a bonus infrastructure as code implementation

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

# VPC Network
resource "google_compute_network" "wordpress_vpc" {
  name                    = "wordpress-vpc-${var.environment}"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "wordpress_subnet" {
  name          = "wordpress-subnet-${var.environment}"
  network       = google_compute_network.wordpress_vpc.name
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
}

# Firewall rules
resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https-${var.environment}"
  network = google_compute_network.wordpress_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-${var.environment}"
  network = google_compute_network.wordpress_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-access"]
}

resource "google_compute_firewall" "allow_monitoring" {
  name    = "allow-monitoring-${var.environment}"
  network = google_compute_network.wordpress_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["3000", "9090", "9100"]
  }

  source_ranges = ["10.0.0.0/8"]
  target_tags   = ["monitoring"]
}

# Static IP
resource "google_compute_address" "wordpress_ip" {
  name   = "wordpress-ip-${var.environment}"
  region = var.region
}

# Cloud SQL Instance
resource "google_sql_database_instance" "wordpress_db" {
  name             = "wordpress-db-${var.environment}"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "compute-instance"
        value = google_compute_address.wordpress_ip.address
      }
    }
    
    backup_configuration {
      enabled = true
      start_time = "03:00"
    }
  }

  deletion_protection = false
}

# Database
resource "google_sql_database" "wordpress" {
  name     = "wordpress"
  instance = google_sql_database_instance.wordpress_db.name
}

# Database user
resource "google_sql_user" "wordpress_user" {
  name     = "wordpress"
  instance = google_sql_database_instance.wordpress_db.name
  password = var.db_password
}

# Compute Instance
resource "google_compute_instance" "wordpress_server" {
  name         = "wordpress-server-${var.environment}"
  machine_type = "e2-medium"
  zone         = var.zone

  tags = ["web-server", "ssh-access", "monitoring"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.wordpress_vpc.name
    subnetwork = google_compute_subnetwork.wordpress_subnet.name
    
    access_config {
      nat_ip = google_compute_address.wordpress_ip.address
    }
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")

  service_account {
    scopes = ["cloud-platform"]
  }

  depends_on = [
    google_sql_database_instance.wordpress_db,
    google_compute_firewall.allow_http_https
  ]
}

# Outputs
output "instance_ip" {
  description = "The external IP of the WordPress server"
  value       = google_compute_address.wordpress_ip.address
}

output "database_ip" {
  description = "The IP of the Cloud SQL instance"
  value       = google_sql_database_instance.wordpress_db.ip_address.0.ip_address
}

output "database_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  value       = google_sql_database_instance.wordpress_db.connection_name
}

# Variable for sensitive data
variable "db_password" {
  description = "Password for the WordPress database user"
  type        = string
  sensitive   = true
}