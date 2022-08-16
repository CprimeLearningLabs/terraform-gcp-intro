resource "google_sql_database_instance" "lab-database" {
  name             = var.db_name
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
  password = random_password.dbpassword.result
}

resource "random_password" "dbpassword" {
  length           = 12
  min_numeric      = 1
  special          = true
  override_special = "_%#*!"
}

### This can be used to store the password in KMS.
### It is removed because of delete limitation of KMS.
# resource "google_kms_key_ring" "lab_key_ring" {
#   name     = "lab-key-ring"
#   location = "us-central1"
# }
#
# resource "google_kms_crypto_key" "lab_crypto_key" {
#   name     = "lab_crypto_key"
#   key_ring = google_kms_key_ring.lab_key_ring.id
# }
#
# data "google_kms_secret_ciphertext" "db_password" {
#   crypto_key = google_kms_crypto_key.lab_crypto_key.id
#   plaintext  = random_password.dbpassword.result
# }
