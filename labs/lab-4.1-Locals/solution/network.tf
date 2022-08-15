resource "google_compute_network" "lab" {
  project                 = "tf-project-359515"
  name                    = "lab"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "lab-public" {
  project       = "tf-project-000000"
  name          = "lab-public"
  ip_cidr_range = "10.128.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.lab.id
}

resource "google_compute_subnetwork" "lab-private" {
  project       = "tf-project-000000"
  name          = "lab-private"
  ip_cidr_range = "10.128.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.lab.id
}
