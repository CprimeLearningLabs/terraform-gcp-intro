# Steps to setup environment

- Install Python
  - Open PowerShell ISE as Administrator (The instructor provide a password)

- Login to Google Cloud

–	Switch to “tf-project-XX”

–	Create Service Account (Search for "Service Account")
  - Call it "tf-shell"
  - Grant "Owner" role

–	Add Key to Service Account (Actions -> Manage Keys)
  - Select JSON type
  –	Download Key (Should happen automatically)

–	Authenticate (from a shell): `export GOOGLE_APPLICATION_CREDENTIALS= ~/Downloads/tf-project-XX-XXXXXXXXXXXX.json`

–	Login : `gcloud auth login`



---

  –	Verify login works with: `gcloud projects list`

–	Select your project : `gcloud config set project PROJECT_ID`

–	Create the state bucket `gsutil mb -p tf-project-XX gs://tf-state-XX``
  - example `gsutil mb -p tf-project-42 gs://tf-state-42`

–	Add the "tf-shell" Service Account as a new principle the new Cloud Storage Bucket “Role/Storage Object Admin”

–	in IAM add the Role “Compute Admin” to the "tf-shell" principal


---

- enable "Compute Engine API" for your project
  - https://console.cloud.google.com/apis/library/compute.googleapis.com?project=tf-project-XX
