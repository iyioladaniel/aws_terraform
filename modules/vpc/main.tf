#Create vpc
resource "aws_vpc" "practice_vpc" {
    cidr_block = "${var.vpc_cidr}"

    tags = {
        Name = "${var.vpc_name}"
        owner= "${var.vpc_stack_owner}"
        environment = "${var.vpc_stack_resource_environment}"
    }
}

#Create subnets
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.practice_vpc.id
    cidr_block =  "${var.private_subnet_cidr}"

    tags = {
        Name = "${var.private_subnet_name}"
        owner= "${var.vpc_stack_owner}"
        environment = "${var.vpc_stack_resource_environment}"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.practice_vpc.id
    cidr_block =  "${var.public_subnet_cidr}"

    tags = {
      Name = "${var.public_subnet_name}" 
      owner= "${var.vpc_stack_owner}"
      environment = "${var.vpc_stack_resource_environment}"
    }
}

#Create internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.practice_vpc.id

  tags = {
    Name = "${var.internet_gateway_name}"
    owner = "${var.vpc_stack_owner}"
    environment = "${var.vpc_stack_resource_environment}"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "eip_nat_gateway" {
  domain = aws_vpc.practice_vpc.id

  tags = {
    Name = "${var.elastic_ip_name}"
    owner= "${var.vpc_stack_owner}"
    environment = "${var.vpc_stack_resource_environment}"
  }
}

#Create public NAT gateway
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnet.id
  allocation_id = aws_eip.eip_nat_gateway.id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "${var.nat_gateway_name}"
    owner= "${var.vpc_stack_owner}"
    environment = "${var.vpc_stack_resource_environment}"
  }
}

#Create route tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "${var.public_route_table_destination}" 
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.public_route_table_name}"
    owner= "${var.vpc_stack_owner}"
    environment = "${var.vpc_stack_resource_environment}"
  }
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "${var.private_route_table_destination}" 
    gateway_id = aws_nat_gateway.nat_gateway.id 
  }

  tags = {
    name = "${var.private_route_table_name}"
    owner= "${var.vpc_stack_owner}"
    environment = "${var.vpc_stack_resource_environment}"
  }
}

#Create route table associations between subnets and route tables
resource "aws_route_table_association" "public_rt_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_rt_association" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}