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
  region        = "us-central1"
  network       = google_compute_network.lab.id
}

resource "google_compute_subnetwork" "lab-private" {
  name          = "lab-private"
  ip_cidr_range = "10.128.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.lab.id
}
