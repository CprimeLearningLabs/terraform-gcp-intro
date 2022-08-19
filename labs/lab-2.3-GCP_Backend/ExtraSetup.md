# Steps on local environments

### Option One (Local environments)

- Install Python
  - Open PowerShell ISE as Administrator (The instructor provide a password)

- Install Google Cloud SDK (Already installed on provided VM)

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

- Verify that you are connected
  - `gcloud projects list`


### Option #2 use Cloud Shell (Preferred in the labs)

- Login to Google Cloud

–	Switch to “tf-project-XX”

- Start the Cloud shell

- Verify that you are connected
  - `gcloud projects list`

---

## Finish setting up your environment

–	Select your project : `gcloud config set project PROJECT_ID`

–	Create the state bucket `gsutil mb -p tf-project-XX gs://tf-state-XX``
  - example `gsutil mb -p tf-project-42 gs://tf-state-42`

- enable "Compute Engine API" for your project (If not already completed)
  - https://console.cloud.google.com/apis/library/compute.googleapis.com?project=tf-project-XX
