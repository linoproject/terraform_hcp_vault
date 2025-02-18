output "vpc_id" {
  value = aws_vpc.main.id
}

data "hcp_vault_secrets_app" "secret_app" {
  app_name = var.TFC_SECRET_APP
}

resource "hcp_vault_secrets_secret" "vpc_id" {
    app_name = var.TFC_SECRET_APP
    secret_name = "INFRA_VCP_ID"
    secret_value = aws_vpc.main.id
}

resource "hcp_vault_secrets_secret" "subnet_id" {
    app_name = var.TFC_SECRET_APP
    secret_name = "INFRA_PUB_SUB_ID"
    secret_value = aws_subnet.public.id
}
