variable "region" {
  default = "eu-west-1"
}

variable "profile" {
  default = "default"
}

variable "role_arn" {
  default = ""
}

variable "session_name" {
  default = ""
}

variable "origin_name" {
  default = "ccrypt"
}

variable "log_prefix" {
  default = "log/"
}

locals {
  website_bucket_name = "c-crypt-website-${random_pet.suffix.id}"
  logging_bucket      = "c-crypt-logging-${random_pet.suffix.id}"
}
