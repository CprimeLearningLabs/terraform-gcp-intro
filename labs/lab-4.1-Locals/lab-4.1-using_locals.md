# Using Locals

Lab Objective:
- Use locals to set common or potentially changeable values

## Preparation

If you did not complete lab 3.4, you can simply copy the solution code from that lab (and run terraform apply) as the starting point for this lab.

## Lab

Look through the code to see what literal values might be best declared in a common block rather than sprinkled throughout the code.  What do you come up with?

Open the file `main.tf` for edit.

Add a locals block at the bottom of the file:
```
locals {
  region         = "us-central1"
  project        = "tf-project-000000"
  instance_image = "projects/rocky-linux-cloud/global/images/rocky-linux-8-v20220719"
}
```

Use the locals to replace the literal values in various resources:
* Replace the region attribute value in the GCP provider block in "main.tf" with <code>local.region</code>
* Replace the value of the project tag in the GCP provider block in "main.tf" with <code>local.project</code>
* Replace the image attribute value in the "bastion" resource in "bastion.tf" with <code>local.instance_image</code>

Compare your changes to the code in the solution folder.

Run terraform validate to confirm your edits are okay.  
```
terraform validate
```

Run terraform plan:
```
terraform plan
```

Confirm that the plan does not come up with any changes to make to the actual infrastructure in GCP.
![Terraform plan results with locals declared](./images/tf-locals.png "Terraform plan results with locals declared")
