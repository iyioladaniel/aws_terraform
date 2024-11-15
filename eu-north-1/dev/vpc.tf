#import vpc module
module "vpc_module" {
  source = "../../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "custom vpc"
  vpc_owner = var.vpc_owner
  environment = var.environment 
}


#private subnet
module "private_subnet" {
  source = "../../modules/subnet"
  vpc_id = module.vpc_module.vpc_id
  subnet_cidr = "10.0.0.0/24"
  subnet_name = "private subnet"
  subnet_owner = var.vpc_owner
  environment = var.environment
}

#public subnet
module "public_subnet" {
  source = "../../modules/subnet"
  vpc_id = module.vpc_module.vpc_id
  subnet_cidr = "10.0.1.0/24"
  subnet_name = "public subnet"
  subnet_owner = var.vpc_owner
  environment = var.environment
}


#Create internet gateway
 resource "aws_internet_gateway" "internet_gateway" {
   vpc_id = module.vpc_module.vpc_id

   tags = {
     Name = "internet gateway"
     Owner = var.vpc_owner
     Environment = var.environment
   }
 }

 # Create Elastic IP for NAT Gateway
 resource "aws_eip" "eip_nat_gateway" {
   tags = {
     Name        = "public NAT elastic ip"
     Owner       = var.vpc_owner
     Environment = var.environment
   }
 }

 #Create public NAT gateway
 resource "aws_nat_gateway" "nat_gateway" {
   subnet_id     =  module.private_subnet.subnet_id
   allocation_id = aws_eip.eip_nat_gateway.id

   # To ensure proper ordering, it is recommended to add an explicit dependency
   # on the Internet Gateway for the VPC.
   depends_on = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "public NAT"
     Owner= var.vpc_owner
     Environment = var.environment
   }
 }

 #Create route tables
 resource "aws_route_table" "public_route_table" {
   vpc_id = module.vpc_module.vpc_id

   route {
     cidr_block = "0.0.0.0/0" 
     gateway_id = aws_internet_gateway.internet_gateway.id
   }

   tags = {
     Name = "public route table"
     Owner= var.vpc_owner
     Environment = var.environment
   }
 }


 resource "aws_route_table" "private_route_table" {
   vpc_id = module.vpc_module.vpc_id

   route {
     cidr_block =  "0.0.0.0/0" 
     gateway_id = aws_nat_gateway.nat_gateway.id 
   }

   tags = {
     Name = "private route table"
     Owner= var.vpc_owner
     Environment = var.environment
   }
 }


 #Create route table associations between subnets and route tables
 resource "aws_route_table_association" "public_rt_association" {
   subnet_id = module.public_subnet.subnet_id
   route_table_id = aws_route_table.public_route_table.id
 }


 resource "aws_route_table_association" "private_rt_association" {
   subnet_id = module.private_subnet.subnet_id
   route_table_id = aws_route_table.private_route_table.id
 }
