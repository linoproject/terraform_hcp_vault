provider "aws" {
  region = "eu-west-1"
}

provider "tfe" {
  hostname = var.tfc_hostname
}

# Data source used to grab the TLS certificate for Terraform Cloud.
#
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate
data "tls_certificate" "tfc_certificate" {
  url = "https://${var.tfc_hostname}"
}

# Creates an OIDC provider which is restricted to
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}

module "tfc_aws_oidc" {
  count = length(var.tcf_oidc_workflows)
  
  

  source = "./tfc_aws_oidc"
  tfc_provider = aws_iam_openid_connect_provider.tfc_provider
  tfc_organization_name = var.tfc_organization_name
  tfc_project_name = var.tfc_project_name
  tfc_workspace_name = var.tcf_oidc_workflows[count.index]

}

data "tfe_project" "myprj" {
  name = var.tfc_project_name
  organization = var.tfc_organization_name
}

data "tfe_workspace" "all_ws" {
  depends_on = [ module.tfc_aws_oidc ]
  count = length(var.tcf_oidc_workflows)
  organization = var.tfc_organization_name
  name = var.tcf_oidc_workflows[count.index]
}

locals {
  all_ws_ids = [
    for ws in data.tfe_workspace.all_ws:
    ws.id 
  ]
}

resource "tfe_variable_set" "infra" {
  name = "INFRA_SHARED"
  description = "Infrastructure shared variables"
  organization = var.tfc_organization_name
  workspace_ids = local.all_ws_ids
  parent_project_id = data.tfe_project.myprj.id
}


resource "tfe_variable" "TFC_ORG_NAME" {
  variable_set_id = tfe_variable_set.infra.id
  key = "TFC_ORG_NAME"
  value = var.tfc_organization_name
  category = "terraform"

}

resource "tfe_variable" "TFC_PRJ_ID" {
  variable_set_id = tfe_variable_set.infra.id
  key = "TFC_SECRET_APP"
  value = var.tfc_project_name
  category = "terraform"

}
