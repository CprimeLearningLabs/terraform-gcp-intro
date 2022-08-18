resource "google_compute_forwarding_rule" "lab-http" {
  name       = "website-forwarding-rule"
  target     = "${google_compute_target_pool.lab-http.self_link}"
  port_range = "80"
}

resource "google_compute_target_pool" "lab-http" {
  name         = "instance-pool"
  instances    = google_compute_instance.cluster.*.self_link
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
