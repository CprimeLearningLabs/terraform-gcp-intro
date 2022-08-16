resource "google_sql_database_instance" "lab-database" {
  name             = "lab-database-instance"
  region           = "us-central1"
  database_version = "POSTGRES_14"
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection  = "false"
}

resource "google_sql_user" "lab-db" {
  name     = "lab-db"
  instance = google_sql_database_instance.lab-database.name
  password = "Gcptfl4b$"
}
