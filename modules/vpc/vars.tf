variable "vpc_cidr"{
    description = "cidr block range for the vpc"
    default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "name of created vpc"
}

variable "vpc_stack_owner" {
  description = "owner of created vpc stack resource"
}

variable "vpc_stack_environment" {
  description = "environment the vpc stack resource is deployed"
}

variable "subnet_cidr"{
    description = "cidr block range for the private subnet"
    default = "10.0.0.0/24"
}

variable "subnet_name" {
  description = "name of created private subnet"
}
