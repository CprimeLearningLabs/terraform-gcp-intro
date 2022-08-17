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
  archiving_enabled = "0"
}

resource "google_storage_bucket" "lab_bucket" {
  for_each      = local.bucket_settings

  name          = "${local.project}-${each.key}"
  location      = each.value.location
  storage_class = "REGIONAL"
  force_destroy = each.value.force_destroy
}

resource "google_storage_bucket" "archive" {
  count = local.archiving_enabled ? 1 : 0

  name          = "${local.project}-archive"
  location      = var.region
  storage_class = "REGIONAL"
  force_destroy = false
}
