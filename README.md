# HashiTalks Terraform Vault Secret integrations (using AWS)

This example is composed of one setup template called bootstrap and 3 streams (workspaces):
* infrastructure (vpc): build the environment with the essential things like internet gateway, subnets, etc...
* EC2: build the instance to run the application
* Application: An example web application
