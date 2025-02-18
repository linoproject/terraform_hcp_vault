variable "tfc_aws_dynamic_credentials" {
  description = "Object containing AWS dynamic credentials configuration"
  type = object({
    default = object({
      shared_config_file = string
    })
    aliases = map(object({
      shared_config_file = string
    }))
  })
}

variable "TFC_ORG_NAME" {
  type        = string
}

variable "HCP_CLIENT_ID" {
  type = string
  sensitive = true
}

variable "HCP_CLIENT_SECRET" {
  type = string
  sensitive = true
}

variable "TFC_SECRET_APP" {
  type = string
}

variable "vpc_name" {
  type = string
  default = "MyVPC"
}

variable "vpc_env" {
  type = string
  default = "DEV"
}

variable "application_name" {
  type = string
  default = "myapp"
}

variable "EC2Key" {
  type = string
}

