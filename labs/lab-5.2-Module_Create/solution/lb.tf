module "load-balancer" {
  source = "./load-balancer"

  port              = "80"
  backend_instances = google_compute_instance.cluster.*.self_link
}
