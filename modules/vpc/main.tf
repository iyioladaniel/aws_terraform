#Create vpc
resource "aws_vpc" "custom_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
        Name = var.vpc_name
        Owner= var.vpc_owner
        Environment = var.environment
    }
}
