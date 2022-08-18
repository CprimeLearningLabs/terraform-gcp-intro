terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.31.0"
    }
  }
  required_version = "> 1.0.0"
}

resource "google_compute_forwarding_rule" "lab-http" {
  name       = "website-forwarding-rule"
  target     = "${google_compute_target_pool.lab-http.self_link}"
  port_range = var.port
}

resource "google_compute_target_pool" "lab-http" {
  name         = "instance-pool"
  instances    = var.backend_instances
  health_checks = [
    google_compute_http_health_check.lab-cluster.name,
  ]
}

resource "google_compute_http_health_check" "lab-cluster" {
  name               = "lab-cluster"
  request_path       = "/"
  check_interval_sec = 5
  timeout_sec        = 2
}
