GCP# Secure Password

Lab Objective:
- Create a random password and store it in GCP parameter store
- Update database user resource to use secured password

## Preparation

If you did not complete lab 3.3, you can simply copy the solution code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

Open the file `database.tf` for edit.

Add a new resource to create a random password that satisfies the constraints for the DB user password.
```
resource "random_password" "dbpassword" {
  length           = 12
  min_numeric      = 1
  special          = true
  override_special = "_%#*!"
}
```

Now, update the database resource to use the new secure password instead of a hard-coded password.  In the existing "aws_db_instance" resource, change the "password" argument:
```
  password = random_password.dbpassword.result
```

Run terraform validate to make sure you have no errors:
```
terraform validate
```

Run terraform plan.  Two new resources will be created, and the database will be updated in-place.
```
terraform plan
```

Run terraform apply.
```
terraform apply
```

Let's now see that Terraform treats a random password resource as a sensitive value.

First, look back at the output from the terraform plan and apply operations.  You will see that the password value in all the resources is shown as "(sensitive value)".

Next, run the following to verify that the value is also displayed as “(sensitive value)” when displaying the terraform state.  This ensures that the secure password does not leak into logs.

```
terraform state show random_password.dbpassword
```

:bangbang: NOTE: Using credentials stored in parameter store helps secure the database.  Applications that need to access the database should use provisioning logic to extract the password from the parameter store and inject it into the application.  The password should not be saved in files on an application server.
