output "public_ip" {
  value = google_compute_forwarding_rule.lab-http.ip_address
}
