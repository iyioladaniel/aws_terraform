variable "vpc_cidr"{
    description = "cidr block range for the vpc"
    default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "name of created vpc"
  default = "company vpc"
}

variable "vpc_stack_owner" {
  description = "owner of created vpc stack resource"
  default = "data platform team"
}

variable "vpc_stack_resource_environment" {
  description = "environment the vpc stack resource is deployed"
  default = "dev"
}

variable "private_subnet_cidr"{
    description = "cidr block range for the private subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_name" {
  description = "name of created private subnet"
  default = "company private subnet"
}

variable "public_subnet_cidr"{
    description = "cidr block range for the public subnet"
    default = "10.0.1.0/24"
}

variable "public_subnet_name" {
  description = "name of created public subnet"
  default = "company public subnet"
}

variable "internet_gateway_name" {
  description = "name of internet gateway"
  default = "company internet gateway"
}

variable "elastic_ip_name" {
  description = "name of elastic ip attached to NAT gateway"
  default = "company elastic_ip"
}

variable "private_subnet_name" {
  description = "name of created private subnet"
  default = "company private subnet"
}

variable "nat_gateway_name" {
  description = "name of created nat gateway"
  default = "company public nat gateway"
}

variable "public_route_table_destination"{
    description = "cidr block range for the public route table"
    default = "0.0.0.0/0"
}

variable "public_route_table_name" {
  description = "name of created public route table"
  default = "public route table"
}

variable "private_route_table_destination"{
    description = "cidr block range for the private route table"
    default = "0.0.0.0/0"
}

variable "private_route_table_name" {
  description = "name of created private route table"
  default = "private route table"
}
