# Expressions

Lab Objectives:
- Construct various types of expressions
- Use "terraform console" as development tool

## Lab

In this lab we will be using the “terraform console” command.  This opens the command line into a mode that allows you to type in expressions that are then evaluated.

Open Terraform console on the command line:

```
terraform console
```

At the “>” prompt, enter the following to see what they evaluate to.

#### Literal Values:

```
> 6.3

> ["foo", "bar", "baz"]

> true
```
:information_source: Be careful when typing the quotes in the 2nd example above to use double quotes -- single quotes are invalid. Also, note that "True" will return an error in the 3rd example.

#### Conditional:

```
> local.environment == "Prod" ? "t3.large" : "t3.micro"

> local.region == "us-central1" ? "primary" : "secondary"
```
<details>

 _<summary>Click to see results of above</summary>_

![Terraform console results](./images/tf-console-2.png "Terraform console results")
</details>

#### Splat Expression:

```
> google_sql_database_instance.lab-database.ip_address[*].ip_address
```

<details>

 _<summary>Click to see results of above</summary>_

![Terraform console results](./images/tf-console-3.png "Terraform console results")
</details>

#### for expression:

_Extract the keys of the subnet tags:_

```
> [for k,v in google_compute_subnetwork.lab-public : k]
```

<details>

 _<summary>Click to see results of above</summary>_

</details>

To exit the Terraform console, type:

```
> exit
```
