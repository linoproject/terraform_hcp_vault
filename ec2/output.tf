output "ec2_ip" {
  value = aws_instance.web.public_ip
}

resource "hcp_vault_secrets_secret" "subnet_id" {
    app_name = var.TFC_SECRET_APP
    secret_name = "EC2_APP_IP"
    secret_value = aws_instance.web.public_ip
}

resource "hcp_vault_secrets_secret" "private_key" {
    app_name = var.TFC_SECRET_APP
    secret_name = "EC2Key"
    secret_value = tls_private_key.private_key.private_key_pem
}
