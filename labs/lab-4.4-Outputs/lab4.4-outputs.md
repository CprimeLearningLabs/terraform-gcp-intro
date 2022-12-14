# Outputs

Lab Objective:
- Add outputs for resource attributes

## Preparation

If you did not complete lab 4.3, you can simply copy the solution code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

Look through the configuration files, and think about what outputs you might want to provide to users who instantiate this configuration.

:question: What attributes have you needed to find so you can use them in running commands?

For this lab, we will output two values:
- Public IP of virtual machine (needed when using ssh to connect to the bastion host)
- Database endpoint (needed if you wanted to execute a psql command to connect to the database)

Create a file called `outputs.tf`.

Add outputs for the above two attributes to the file.  Try your hand at it first before looking at the solution.  You might want to take a look at the Terraform documentation to see what attributes are exported for the two resources:
- google_compute_instance
- google_sql_database_instance

<details>

 _<summary>Click to see solution for outputs</summary>_

```
output "bastion-public-ip" {
  value = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
}

output "db-server-endpoint" {
  value = google_sql_database_instance.lab-database.ip_address[0].ip_address
}
```
</details>

Run terraform validate to check for syntax errors:
```
terraform validate
```

Run terraform plan. See that the execution plan will be adding the outputs to the state. Since the output values are derived from existing state, the plan will also show you the values.  Are they what you expect?
```
terraform plan
```

![Terraform Plan - Outputs](./images/tf-plan-outputs.png "Terraform Plan - Outputs")

Run terraform apply.  This is necessary to save the output values into the Terraform state.

```
terraform apply
```

The output values will show up in the console at the end of the apply console output.

![Terraform Apply - Outputs](./images/tf-apply-outputs.png "Terraform Apply - Outputs")

You can execute terraform output to view the output values now that they are part of the Terraform state.

```
terraform output bastion-public-ip

terraform output db-server-endpoint
```

![Terraform Output](./images/tf-output.png "Terraform Output")
