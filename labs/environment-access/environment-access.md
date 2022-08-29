# Lab Environment Access

The labs for this class will require that you have access to the GCP Management Console and access to a provisioned lab workstation.

## GCP Management Console

The infrastructure created using Terraform in this class' labs will be created in an GCP account dedicated for your use.  Your instructor will provide the GCP account number and login credentials for you to access the GCP Management Console for the account.

In a browser, go to https://console.google.com

Enter the account number and login credentials.  From the console, you will have read access to view the infrastructure you subsequently provision in the labs using Terraform.

## Select your project

Each account has a corresponding project folder to work in within GCP.  You can select the project near the top of the GCP console.  You should find your project in the orginizations `tf-class` folder.  The project name will be of the format `tf-project-XX` where 'XX' is replaced by your student ID number provider by the instructor.

## Enable the APIs on the project

We will need to have some API enabled on the project.  In the Google Cloud search box type 'API' and select 'API & Services'.  Near the top of this page select '+ ENABLE APIS AND SERVICES'.  From this page enable the following APIs (Search for them):

- Compute Engine API

## Cloud shell

At the top of the main portal page, find the icon activate the Cloud Shell.  The first time accessing the new terminal it would be helpful to create a working directory for your terraform project.  This directory will be used for each of the following labs.

```shell
mkdir -p ~/terraform
cd ~/terraform
```

You may find it handy to select "Open in new window" to move the Cloud shell to an additional browser tab.  You also can optionally open the Cloud Shell editor by selecting "Open Editor".  Once the Cloud Shell Editor is open select "Open Folder.." to select your newly created "terraform" project folder.

### Selecting project on the Shell

When running commands in GCP it is important that you are using the correct project.  You will notice the project name as part of your shell prompt.  You can set the current project for the Cloud Shell with the following command.

`gcloud config set project PROJECT_ID`

### Create an Cloud Storage bucket for terraform remote state

In a later lab we will need a Cloud Storage bucket to store terraform remote state.  If you have not yet let us create that bucket now.  Within the cloud shell, first make sure you are in the correct project, then run this command replacing the two instances of 'XX' with your student ID number: `gsutil mb -p tf-project-XX gs://tf-state-XX`. For instance if your student ID number is '42' the command would look like: `gsutil mb -p tf-project-42 gs://tf-state-42`.  Later in the exercise you will use "tf-state-XX" again replacing 'XX' as your remote state bucket name.

You are now set to proceed with the labs for the class.

:bangbang: NOTE: If the cloud shell times out (and it likely will between labs), then you will get a prompt to reconnect. After reconnecting, be sure to change to the "~/terraform" directory again.
