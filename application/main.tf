terraform { 
  cloud { 
    
    organization = "linoproject" 

    workspaces { 
      name = "application" 
    } 
  } 
  required_providers {
    hcp = {
        source = "hashicorp/hcp"
        version = "0.91.0"
    }
  }

}
provider "aws" {
  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
  region = "eu-west-1"

  default_tags {
    tags = {
      Application = var.application_name
      Environment = var.vpc_env
      Workspace = terraform.workspace
    }
  }
}
