resource "google_compute_firewall" "ssh" {
  name          = "allow-ssh"
  allow {
    ports       = ["22"]
    protocol    = "tcp"
  }
  direction     = "INGRESS"
  network       = "default"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "vpn" {
  name          = "allow-vpn"
  allow {
    ports       = ["1194"]
    protocol    = "udp"
  }
  direction     = "INGRESS"
  network       = "lab"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["vpn"]
}

resource "google_compute_instance" "bastion" {
  name             = "bastion"
  machine_type     = "f1-micro"
  zone             = "us-central1-a"
  tags             = ["ssh", "vpn"]
  metadata = {
    enable-oslogin = "TRUE"
  }
  boot_disk {
    initialize_params {
      image        = local.instance_image
    }
  }
  network_interface {
    network        = "lab"
    subnetwork     = "lab-public"
    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
