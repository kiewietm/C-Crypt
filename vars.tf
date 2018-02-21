variable "az_count" {
  description = "Number of AZs to deploy Lambdas in"
  default     = "2"
}

variable "https_subnet_cidrs" {
  description = "Subnet Cidrs for HTTPS traffic only"
  type        = "list"
  default     = ["10.0.0.0/25", "10.0.0.128/25"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/24"
}

variable "region" {
  description = "VPC CIDr range"
  default     = "eu-west-1"
}

variable "profile" {
  description = "Profile used to deploy resources / assume cross-account role"
  default     = "default"
}

variable "s3_profile" {
  description = "Profile of account where S3 website will be deployed"
  default     = "default"
}

variable "role_arn" {
  description = "Cross-account role arn (valid value=\"\")"
}

variable "session_name" {
  description = "Session name used when assuming roles (valid value=\"\")"
}

variable "origin_name" {
  description = "Name used by OAI CloudFront"
  default     = "ccrypt"
}

variable "log_prefix" {
  description = "S3 location where to store logs"
  default     = "log/"
}

variable "mfa_period" {
  description = "Time in Seconds that MFA will be valid for"
  default     = "5"
}

locals {
  website_bucket_name = "c-crypt-website-${random_pet.suffix.id}"
  logging_bucket      = "c-crypt-logging-${random_pet.suffix.id}"
  secret_bucket       = "c-crypt-secret-${random_pet.suffix.id}"
}
