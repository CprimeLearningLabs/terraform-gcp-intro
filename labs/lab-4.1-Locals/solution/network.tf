resource "google_compute_firewall" "lab" {
  name          = "lab"
  network       = google_compute_network.lab.name
  allow {
    protocol    = "icmp"
  }
  allow {
    protocol    = "tcp"
    ports       = ["22", "80", "443", "8000-8999"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_network" "lab" {
  name                    = "lab"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "lab-public" {
  name          = "lab-public"
  ip_cidr_range = "10.128.0.0/24"
  region        = local.region
  network       = google_compute_network.lab.id
}

resource "google_compute_subnetwork" "lab-private" {
  name          = "lab-private"
  ip_cidr_range = "10.128.1.0/24"
  region        = local.region
  network       = google_compute_network.lab.id
}

resource "google_compute_router" "lab" {
  name    = "lab-router"
  region  = local.region
  network = google_compute_network.lab.id
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "lab" {
  name                               = "lab-router-nat"
  router                             = google_compute_router.lab.name
  region                             = local.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
