output "bastion-public-ip" {
  value = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
}

output "db-server-endpoint" {
  value = module.sql-db_postgresql.public_ip_address
}

output "network_load_balancer_ip" {
    value = "${google_compute_forwarding_rule.lab-http.ip_address}"
}
