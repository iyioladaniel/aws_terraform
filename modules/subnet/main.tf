#Create subnets
resource "aws_subnet" "custom_subnet" {
    vpc_id = var.vpc_id
    cidr_block =  var.subnet_cidr

    tags = {
        Name = var.subnet_name
        Owner= var.subnet_owner
        Environment = var.environment
    }
}

