# Dynamic Blocks

Lab Objective:
- Implement a dynamic block to handle multiple allow rules in the network firewall

## Preparation

If you did not complete lab 4.5, you can simply copy the solution code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

Open `network.tf` for edit.

Notice that within the "google_compute_firewall.lab", there are multiple allow rule sub-blocks. We will replace those allow sub-blocks with a single dynamic block.

A dynamic block uses the for_each construct, which you now know requires a map of values by which to populate values for each iteration.  Since there are two items, the map will have two keys.  What might you use as the map key for the different allow rules?

Create a locals block in `network.tf`, add a new map with two keys, and a sub-map for each key to specify the following values:
*	protocol
*	ports

Try your hand at writing the map before looking at the solution below (or in network.tf in the solution directory).

<details>

 _<summary>Click to see solution for security group map</summary>_

```
locals {
  network_allow = {
    "icmp" = {
      protocol = "icmp"
      ports    = []
    }
    "tcp" = {
      protocol = "tcp"
      ports    = ["22", "80", "443", "8000-8999"]
    }
  }
}
```
</details>

Now replace the network firewall allow rules with a dynamic block.  Try your hand at it, then compare your code to the solution below (or in network.tf in the solution folder).

<details>

 _<summary>Click to see solution for dynamic block</summary>_

```
  dynamic "allow" {
    for_each = local.network_allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
```
</details>

When you are done, run terraform validate:
```
terraform validate
```

Run terraform plan.  If you have refactored the code correctly, the plan should come back with no changes to make.
```
terraform plan
```
