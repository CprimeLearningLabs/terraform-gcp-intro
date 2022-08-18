resource "google_compute_firewall" "http" {
  name          = "allow-http"
  allow {
    ports       = ["80"]
    protocol    = "tcp"
  }
  direction     = "INGRESS"
  network       = "default"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http"]
}

resource "google_compute_instance" "cluster" {
  count            = local.cluster_size
  name             = "cluster-${count.index}"
  machine_type     = var.cluster_vm_type
  zone             = "us-central1-a"
  tags             = ["http","ssh"]
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
    subnetwork     = "lab-private"
  }
  metadata_startup_script = <<SCRIPT
fallocate -l 1G /swapfile
chmod 0600 /swapfile
mkswap /swapfile
swapon /swapfile
dnf install -y nginx
sleep 5
systemctl enable nginx
systemctl start nginx
NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")
METADATA=$(curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/?recursive=True" | jq 'del(.["startup-script"])')
cat <<EOF > /usr/share/nginx/html/index.html
<pre>
  Name: $NAME
  IP: $IP
  Metadata: $METADATA
</pre>
EOF
SCRIPT
}
