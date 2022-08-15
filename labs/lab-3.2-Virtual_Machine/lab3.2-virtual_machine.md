# Virtual Machine

Lab Objectives:
- Create a virtual machine with a public IP
- See the effect of making a change to an existing resource

## Preparation

If you did not complete lab 3.1, you can simply copy the solution code from that lab (and run terraform apply) as the starting point for this lab.

## Lab

### Creating a Virtual Machine

The virtual machine we create in this lab is for a bastion host that has access from the public Internet.

Create a new file `bastion.tf`.

Add two new resources to this file.

1. A firewall rule to enable SSH access to the bastion host.  It will be linked to the bastion host via the target tag: "ssh".
```
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
```

2. A virtual machine.
```
resource "google_compute_instance" "bastion" {
  name             = "bastion"
  machine_type     = "f1-micro"
  zone             = "us-central1-a"
  tags             = ["ssh"]
  metadata = {
    enable-oslogin = "TRUE"
  }
  boot_disk {
    initialize_params {
      image        = "projects/rocky-linux-cloud/global/images/rocky-linux-8-v20220719"
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
```
Save the file.

Run terraform validate to make sure you have no errors:
```
terraform validate
```

Run terraform plan.  See that two new resources will be created.
```
terraform plan
```

Run terraform apply:
```
terraform apply
```

### Connect to the Virtual Machine

Let's check that the infrastructure actually works by connecting to the new virtual machine.

To connect to the virtual machine, you need its public IP.  You can get this in a couple ways:

1. Run `gcloud compute ssh`

    a. Run `gcloud compute ssh --zone "us-central1-a" "bastion"  --project "tf-project-000000"` replace "tf-project-000000" with your project name.

    b. Notice that this also generates a SSH key pair adding it to the running VM.

2. Go to the GCP Console UI

    a. In the Console search bar, type 'virtual machine'.  Select the VM instances in the drop-down.  

    b. On the VM instances dashboard, click the "SSH" option on the "bastion" row.  This will connect to the bastion host through a web interface.

3. Through SSH client of choice

    a. Take note of the username from the options #1 and #2.  It should be your login name for GCP replacing special characters with "_".  Use this username in your SSH client.

    b. The public IP address can be found by running `terraform show`. Scroll up in the output to find the state for the virtual machine resource "google_compute_instance.bastion".  One of its attributes under "network_interfaces" should be `nat_ip`. Use that as the publiIP to connect to.

    c. The private key was generated earlier.  To use OpenSSH from a bash shell run 'ssh username@pubicIP' to connect.

*You may be prompted to confirm that you want to connect. Enter "yes".*

<br /><br />

Confirm you can ssh into the new bastion host machine.  You should see that the terminal prompt has changed to the private IP of the new virtual machine.

> You could also connect to the new bastion host from your personal machine, in which case you can use the same SSH key you used to connect to the workstation virtual machine.

Exit the SSH session on the bastion host virtual machine.

### Making Changes to An Existing Resource

Let's suppose your organization also wants to support accessing the bastion host via a VPN.  To enable this access, we will modify the firewall rules to allow TCP traffic on port 1194.

Add the following to the security group in the `bastion.tf` file.  To see where to add the code, go to the Terraform documentation page for "aws_security_group". (Or you can look at the code in the solution folder of this lab.)

```
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
```

Also add the "vpn" tag to the bastion instances

```
  tags             = ["ssh", "vpn"]
```

Save the file and run terraform plan:
```
terraform plan
```

Notice that the plan shows an update to the security group.

Run terraform apply (remember to confirm yes to the changes):

```
terraform apply
```
