variable "vpc_id"{
    description = "id of the vpc to deploy the subnet in"
}


variable "subnet_cidr"{
    description = "cidr block range for the subnet"
}


variable "subnet_name" {
  description = "name of created subnet"
}


variable "subnet_owner" {
  description = "owner of the subnet"
}


variable "environment" {
  description = "environment where the subnet will be deployed"
}
