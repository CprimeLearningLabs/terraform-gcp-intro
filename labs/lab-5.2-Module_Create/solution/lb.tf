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


# module "load-balancer" {
#   source = "./load-balancer"
#
#   vpc_id          = aws_vpc.lab.id
#   subnets         = [aws_subnet.lab-public-1.id, aws_subnet.lab-public-2.id]
#   security_groups = [aws_security_group.lab-alb.id]
# }
