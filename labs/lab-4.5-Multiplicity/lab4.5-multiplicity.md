# Multiplicity

Lab Objective:
- Use for_each for multiple S3 buckets
- Use count for multiple VMs in an availability set

## Preparation

If you did not complete lab 4.4, you can simply copy the solution code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

### Using for_each

Create a new file `bucket.tf`, and open it for edit.

We are going to create a few cloud storage buckets where the buckets differ not only by the bucket name but also by a couple of other properties.

The for_each operation requires a map to define the different values for each resource instance.  Add the following map to the `bucket.tf` file to specify three buckets and two properties for each bucket.  Look closely at the code to see that it is a map of maps.  We will be iterating over the outer "application_buckets" map.
```
locals {
  bucket_settings = {
    uploads = {
      location = var.region
      force_destroy = false
    },
    media = {
      location = var.region
      force_destroy = true
    },
    feeds = {
      location = var.region
      force_destroy = true
    }
  }
}
```

We can now add a resource declaration to create the S3 buckets.  Examine the code below to make sure you understand how it is using the map key and map values in the resource.
```
resource "google_storage_bucket" "lab_bucket" {
  for_each      = local.bucket_settings

  name          = "${local.project}-${each.key}"
  location      = each.value.location
  storage_class = "REGIONAL"
  force_destroy = each.value.force_destroy
}
```

Run terraform validate:
```
terraform validate
```

Run terraform plan.  You should get a plan that will create three buckets.  Notice how the bucket resources are referenced in the plan using the map keys.
```
terraform plan
```

Run terraform apply.
```
terraform apply
```

---

### Using count

To show the use of count, we will create a small cluster of virtual machines behind a load balancer.

Create a new file called `lb.tf`

1. Add a forwarding rule, this is the load balancer frontend.

```
resource "google_compute_forwarding_rule" "lab-http" {
  name       = "website-forwarding-rule"
  target     = "${google_compute_target_pool.lab-http.self_link}"
  port_range = "80"
}
```

2. Add a target pool, this is the load balancer backend.

```
resource "google_compute_target_pool" "lab-http" {
  name         = "instance-pool"
  instances    = google_compute_instance.cluster.*.self_link
  health_checks = [
    google_compute_http_health_check.lab-cluster.name,
  ]
}
```

3. Lastly, add a health check to that the target pool will use.

```
resource "google_compute_http_health_check" "lab-cluster" {
  name               = "lab-cluster"
  request_path       = "/"
  check_interval_sec = 5
  timeout_sec        = 2
}
```

Open `outputs.tf`

Add a new output so we can easily get the load balancer DNS name:
```
output "network_load_balancer_ip" {
    value = "${google_compute_forwarding_rule.lab-http.ip_address}"
}
```

Create a new file called `vm-cluster.tf` and open it for edit.

Next, we will create two resources.  Notice that we will be using the count meta-argument in the "google_compute_instance" resource to create multiple nodes.  The count will be based on a new local (which we will add later) to set the size of the VM cluster.

1. Add a firewall for HTTP traffic from the load balancer.
```
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
```

2. Add the virtual machines.  We use count here to create multiple virtual machines.  Note that these instance will install and start a web server that returns some basic node information.
```
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
```

Open `main.tf` for edit.

In the locals block, add a new local value for cluster_size, which be the number of virtual machines to create in the cluster.  Set it to 2.
```
  cluster_size = "2"
```

Open `variables.tf`

Add a variable block for "cluster_vm_type".  It can be set with a default value so we do not need to set it elsewhere.

```
variable "cluster_vm_type" {
  description = "Instance type for the cluster VMs"
  type = string
  default = "f1-micro"
}
```

Okay, that's a lot of edits.  Be sure to run terraform validate to make sure you got everything.
```
terraform validate
```

Run terraform plan to verify what will be created.  Scroll through the plan.  Does it match what you would expect?  Notice how the plan uses an array index to reference the multiple instances of the new virtual machine resources.
```
terraform plan
```

Run terraform apply:
```
terraform apply
```

Now some fun parts.  Notice the output for the "network_load_balancer_ip".  Give it a few minutes to provision the new web instances. Then see if you can connect to that ip address of the load balancer.  When the connection succeeds reload the page a few times.  Notice how the content changes.

---   

### Using count for conditional creation

Open the file `main.tf` for edit.  In the locals block, add a local to control whether or not we allow archiving.
```
  archiving_enabled = false
```

Open the file `bucket.tf` again for edit.

Add a resource for another cloud storage bucket, but with a conditional expression for count.  Note that the count could evaluate to either 1 or 0 depending on the value of `local.archiving_enabled`.
```
resource "google_storage_bucket" "archive" {
  count = local.archiving_enabled ? 1 : 0

  name          = archive
  location      = var.region
  storage_class = "REGIONAL"
  force_destroy = false
}
```

Add `archiving_enabled` to the locals section in `bucket.tf` a value of `0`

Validate your new code.
```
terraform validate
```

Run terraform plan to see whether or not the additional bucket gets created.  Is the result what you expect?
```
terraform plan
```

Change the value of `archiving_enabled` to `1` and see how it changes the `terraform plan`.
