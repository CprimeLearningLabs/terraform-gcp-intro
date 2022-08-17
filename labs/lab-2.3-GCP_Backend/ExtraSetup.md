# Steps to setup environment

- Login to Google Cloud

–	Switch to “tf-project-XX”

–	Create Service Account

–	Add Key to Service Account (tf-shell)

–	Download Key (Should happen automatically)

–	Authenticate (from a shell): `export GOOGLE_APPLICATION_CREDENTIALS=~/Downloads/tf-project-000000-xxxxxxx.json`

–	Login : `gcloud auth login`

  –	Verify login works with: `gcloud projects list`

–	Select your project : `gcloud config set project PROJECT_ID`

–	Create the state bucket `gsutil mb -p PROJECT_ID gs://tf-state-PROJECT_ID#``

–	Add the "tf-shell" Service Account as a new principle the new Cloud Storage Bucket “Role/Storage Object Admin”

–	in IAM add the Role “Compute Admin” to the "tf-shell" principal
