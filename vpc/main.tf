#Create vpc
resource "aws_vpc" "practice_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "practice_vpc"
        owner= "Data Platform Team"
        environment = "vpc_stacks_practice"
    }
}

#Create subnets
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.practice_vpc.id
    cidr_block =  "10.0.0.0/24"

    tags = {
        Name = "private_subnet"
        Type = "Private"
        owner= "Data Platform Team"
        environment = "vpc_stacks_practice"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.practice_vpc.id
    cidr_block =  "10.0.1.0/24"

    tags = {
      Name = "public_subnet" 
      Type = "Public"
      owner= "Data Platform Team"
      environment = "vpc_stacks_practice"
    }
}

#Create internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.practice_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "eip_nat_gateway" {
  domain = vpc

  tags = {
    Name = "nat_gateway_elastic_ip"
    owner= "Data Platform Team"
    environment = "vpc_stacks_practice"
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
    Name = "nat_gateway"
    owner= "Data Platform Team"
    environment = "vpc_stacks_practice"
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
    Type = "Public"
    owner= "Data Platform Team"
    environment = "vpc_stacks_practice"
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
    Type = "Private"
    owner= "Data Platform Team"
    environment = "vpc_stacks_practice"
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