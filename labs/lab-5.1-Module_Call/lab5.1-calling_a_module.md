# Calling a Module

Lab Objective:
- Use a module to recreate our PostgreSQL server

## Preparation

If you did not complete lab 4.7, you can simply copy the solution code from that lab (and do terraform apply) as the starting point for this lab.

## Lab

Go the Terraform registry (https://registry.terraform.io/browse/modules?provider=google) to see what modules are available for creating sql-db.  What do you find?  Don't miss the submodules option.

The module we want to use in this lab is at:

* https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/12.0.0/submodules/postgresql

Look through the module documentation to see how it should be used.  Look at the inputs section to see what input arguments are required versus optional.

Open `database.tf`

Using the module documentation as a guide, replace the "google_sql_database_instance" and "google_sql_user" sections with the "sql-db_postgresql" module.:
* the database version is "POSTGRES_14"
* the name to "module-database"
* turn off delete protection
* the zone to "us-central1-a"
* create a "lab-db" use with the generated password from "random_password.dbpassword"

Specify the version explicitly as "12.0.0" since that is what this lab was based on.

Compare your code to the solution below (or in the database.tf file in the solution folder).

<details>

 _<summary>Click to see solution for module call</summary>_

```
module "sql-db_postgresql" {
  source              = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version             = "12.0.0"
  name                = "lab-database"
  deletion_protection = false
  project_id          = local.project
  zone                = "us-central1-a"
  database_version    = "POSTGRES_14"
  additional_users    = [
    {
      name            = "lab-db"
      password        = random_password.dbpassword.result
    },
  ]
}
```
</details>

You will also need to adjust the "db-server-endpoint" in `outputs.tf` to "".

If you try running terraform validate at this point, you would get an error that you must first run terraform init.  Do you know why you would need to call init?

Run terraform init:
```
terraform init
```

You may notice an error with the version of "hashicorp/random" being to old.  Set it to "3.1.0" in "main.tf" then run `terraform init -upgrade` to resolve the version issues.

Run terraform validate:
```
terraform validate
```

Run terraform plan.
```
terraform plan
```

Run terraform apply:
```
terraform apply
```

This may take a while.  Depending on the details you may run into some issues with it timing out.  If it does try the "terraform apply" again, if future runs produce errors regarding the database name already existing, try changing the DB name. For instance append a number to the end of the name (lab-database01).  A better solution needs to be resolved as this seems to be an issue with Cloud SQL and this module.
