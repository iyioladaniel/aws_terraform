provider "aws" {
    region = "eu-north-1"
}

#Create vpc
resource "aws_vpc" "practice" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "practice-vpc"
    }
}

#Create subnets
resource "aws_subnet" "practice_private_subnet" {
    vpc_id = aws_vpc.practice.id
    cidr_block =  "10.0.0.0/24"

    tags = {
        Name = "practice-private-vpc"
    }
}

resource "aws_subnet" "practice_public_subnet" {
    vpc_id = aws_vpc.practice.id
    cidr_block =  "10.0.1.0/24"

    tags = {
        Name = "practice-public-vpc"
    }
}

#Create internet gateway
resource "aws_internet_gateway" "practice_internet_gw" {
  vpc_id = aws_vpc.practice.id

  tags = {
    Name = "practice-internet-gateway"
  }
}

#Create public NAT gateway
resource "aws_nat_gateway" "practice-public-nat-gw" {
  subnet_id     = aws_subnet.practice_public_subnet.id

  tags = {
    Name = "practice-public-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.practice_internet_gw]
}

#Create route tables
resource "aws_route_table" "practice_public_route_table" {
  vpc_id = aws_vpc.practice.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.practice_internet_gw.id
  }


  tags = {
    Name = "practice-public-route-table"
  }
}


resource "aws_route_table" "practice_private_route_table" {
  vpc_id = aws_vpc.practice.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_nat_gateway.practice-public-nat-gw.id 
  }


  tags = {
    Name = "practice-private-route-table"
  }
}