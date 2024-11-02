#Create vpc
resource "aws_vpc" "practice_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "practice_vpc"
    }
}

#Create subnets
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.practice_vpc.id
    cidr_block =  "10.0.0.0/24"

    tags = {
        Name = "private_subnet",
        vpc = "practice_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.practice_vpc.id
    cidr_block =  "10.0.1.0/24"

    tags = {
      Name = "public_subnet" 
      vpc = "practice_vpc"
    }
}

#Create internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.practice_vpc.id

  tags = {
    Name = "internet_gateway",
    vpc = "practice_vpc"
  }
}

#Create Elastic IP for NAT Gateway
resource "aws_eip" "eip_nat_gateway" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "nat_gateway_elastic_ip"
    vpc = "practice_vpc"
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
    Name = "nat_gateway",
    subnet = "public_subnet",
    vpc = "practice_vpc"
  }
}

#Create route tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public_route_table"
    subnet = "public_subnet"
    gateway = "nat_gateway"
    subnet = "private_subnet"
  }
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_nat_gateway.nat_gateway.id 
  }

  tags = {
    name = "private-route-table"
    vpc = "private_vpc"
    gateway = "nat_gateway"
    subnet = "private_subnet"
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