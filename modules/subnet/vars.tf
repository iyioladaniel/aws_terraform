variable "vpc_id"{
    description = "id of the vpc to deploy the subnet in"
}


variable "subnet_cidr"{
    description = "cidr block range for the private subnet"
    default = "10.0.0.0/24"
}


variable "subnet_name" {
  description = "name of created private subnet"
}


variable "subnet_owner" {
  description = "owner of the subnet"
}


variable "subnet_environment" {
  description = "environment where the subnet will be deployed"
}
