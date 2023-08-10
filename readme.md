# APTLY-REPO

A way to Set up a virtual machine with terraform for a private apt repo and configure it using ansible on azure devops
---

## First Steps
Create an Azure Account if you don't already have one and create a new subscription
---
navigate to the terraform folder and edit to suit your needs then run:
---
```
terraform init
terraform plan
terraform apply

```
## Ansible Stuff

Go to Azure Devops Under the pipelines tab and create a new pipeline using the azure-pipelines.yml file
---
Don't forget to configure stuff like DNS, GPG keys, private email, ssh (both on your local and your your azure build agent to log into the ansible machine in the inventory.yml file passwordlessly)
---
