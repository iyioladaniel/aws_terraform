#Create vpc
resource "aws_vpc" "custom_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = var.vpc_name
        Owner= var.vpc_stack_owner
        Environment = var.vpc_stack_environment
    }
}

#Create subnets
resource "aws_subnet" "custom_subnet" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block =  var.subnet_cidr

    tags = {
        Name = var.subnet_name
        Owner= var.vpc_stack_owner
        Environment = var.vpc_stack_environment
    }
}

