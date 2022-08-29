module "sql-db_postgresql" {
  source              = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version             = "12.0.0"
  name                = "lab-database"
  deletion_protection = false
  project_id          = local.project
  zone                = "us-central1-a"
  database_version    = "POSTGRES_14"
  create_timeout      = "30m"
  delete_timeout      = "30m"
  additional_users    = [
    {
      name            = "lab-db"
      password        = random_password.dbpassword.result
    },
  ]
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
