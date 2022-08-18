# Database and Data Source

Lab Objective:
- Use a data source to obtain a KMS key
- Add a database to your infrastructure

## Preparation

If you did not complete lab 3.2, you can simply copy the solution code from that lab (and run terraform apply) as the starting point for this lab.

## Lab

### Add a Data Source

To provide security of data at rest in our infrastructure, we will be creating a database that is encrypted.  For this, we will need an encryption key.  Let's suppose that in our organization the management of keys is handled by a separate security group that has already created encryption keys in GCP KMS.

In order to read a key from KMS, we will need to use a data source in Terraform.

Create a new file `database.tf`.
```
touch database.tf
```

Open the file for edit and add a data source to read a specified key from GCP KMS.  The "key_id" provides the criteria by which to find the desired key.


### Define a Database

*If you have not yet you will need to enable "Cloud SQL Admin API access on your project"*

Open the file for edit and add a resource for the PostgreSQL database.

1. A PostgreSQL database.
```
resource "google_sql_database_instance" "lab-database" {
  name             = "lab-database-instance"
  region           = "us-central1"
  database_version = "POSTGRES_14"
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection  = "false"
}
```

2. A database user
```
resource "google_sql_user" "lab-db" {
  name     = "lab-db"
  instance = google_sql_database_instance.lab-database.name
  password = "Gcptfl4b$"
}
```

Look through the resources for a moment. What is the processing order dependency between the resources?

Run terraform validate to make sure you have no errors:
```
terraform validate
```

Run terraform plan and verify that the new resources will be created.
```
terraform plan
```

Run terraform apply. (Remember to agree to the changes.)  The database can sometimes take several minutes to create.
```
terraform apply
```
