variable "vpc_cidr"{
    description = "cidr block range for the vpc"
    default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "name of created vpc"
}

variable "vpc_owner" {
  description = "owner of created vpc stack resource"
}

variable "environment" {
  description = "environment the vpc stack resource is deployed"
}
