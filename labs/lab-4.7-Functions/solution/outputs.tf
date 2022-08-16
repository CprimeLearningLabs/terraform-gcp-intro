output "bastion-public-ip" {
  value = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
}

output "db-server-endpoint" {
  value = google_sql_database_instance.lab-database.ip_address[0].ip_address
}

output "load-balancer-dns" {
  value = aws_lb.lab.dns_name
}
