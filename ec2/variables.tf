
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
variable "INFRA_VCP_ID" {
  type = string
}
variable "INFRA_PUB_SUB_ID" {
  type = string
}

variable "TFC_SECRET_APP" {
  type = string
}


variable "vpc_env" {
  type = string
  default = "DEV"
}

variable "application_name" {
  type = string
  default = "myapp"
}


variable "HCP_CLIENT_ID" {
  type = string
}

variable "HCP_CLIENT_SECRET" {
  type = string
}

variable "EC2Key" {
  type = string
}
