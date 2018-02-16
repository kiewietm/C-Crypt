variable "az_count" {
  default = "2"
}

variable "private_subnet_cidrs" {
  type    = "list"
  default = ["10.0.0.0/25", "10.0.0.128/25"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/24"
}

variable "region" {
  default = "eu-west-1"
}

variable "profile" {
  default = "default"
}

variable "role_arn" {
  description = "Cross-account role arn (valid value=\"\")"
  default     = ""
}

variable "session_name" {
  description = "Session name used when assuming roles (valid value=\"\")"
  default     = ""
}

variable "origin_name" {
  default = "ccrypt"
}

variable "log_prefix" {
  default = "log/"
}

variable "mfa_period" {
  default = "5"
}

locals {
  website_bucket_name = "c-crypt-website-${random_pet.suffix.id}"
  logging_bucket      = "c-crypt-logging-${random_pet.suffix.id}"
  secret_bucket       = "c-crypt-secret-${random_pet.suffix.id}"
}
