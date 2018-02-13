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

locals {
  website_bucket_name = "c-crypt-${random_pet.suffix.id}"
}
