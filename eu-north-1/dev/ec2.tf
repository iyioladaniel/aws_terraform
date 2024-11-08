#import vpc module
#import vpc module
module "vpc_module" {
  source = "../../modules/vpc"
  vpc_cidr = module.vpc_module.practice_vpc
  vpc_name = "custom vpc"
  vpc_stack_owner = "data platform team"
  vpc_stack_environment = "dev" 
}


#Create Security Groups for public instances
resource "aws_security_group" "public_ec2_sg" {
  name = "public security group"
  description = "Allows TLS inbound traffic and outbound traffic"
  vpc_id = module.vpc_module.practice_vpc

  tags = {
    Name = "public security group"
    Owner = "data platform team"
    Environment = "dev"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_all_ipv4_inbound_traffic" {
  security_group_id = aws_security_group.public_ec2_sg.id
  description = "allow all inbound ssh traffic from anywhere on the internet"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  #Port 22 is used to establish an SSH connection to an EC2 instance and access a shell
  from_port         = "22"
  to_port           = "22"
}

#rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "public_allow_all_ipv4_outbound_traffic" {
  security_group_id = aws_security_group.public_ec2_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

#Create key pair for SSH access
resource "aws_key_pair" "public_ec2_key_pair" {
  key_name = "...."
  public_key = "...."
}


#Create Security Groups for private instance
resource "aws_security_group" "private_ec2_sg" {
  name = "private security group"
  description = "Allows TLS inbound traffic and outbound traffic from public subnet"
  vpc_id = module.vpc_module.practice_vpc

  tags = {
    Name = "private security group"
    Owner = "data platform team"
    Environment = "dev"
  }
}

#rule to allow inbound ssh from public subnet only
resource "aws_vpc_security_group_ingress_rule" "private_allow_inbound_ipv4_ssh_traffic" {
  security_group_id = aws_security_group.private_ec2_sg.id
  description = "allow ssh from ips within the CIDR of the public subnet"
  cidr_ipv4 = module.vpc_module.subnet_cidr #public cidr range to be called from vpc.tf here
  ip_protocol = "-1" 
  from_port = "22"
  to_port = "22"

  #reference the public security group
  referenced_security_group_id = aws_security_group.public_ec2_sg.id 
}

#rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "private_allow_all_outbound_ipv4_ssh_traffic" {
  security_group_id = aws_security_group.private_ec2_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}


#create public ec2 
module "public_ec2"{
    source = "../../modules/ec2"
    instance_ami = "ami-08ec94f928cf25a9d"
    instance_type = "t2.micro" 
    subnet_id = module.vpc_module.practice_subnet
    security_group_name = [aws_security_group.public_ec2_sg.id]
    attach_public_ip = true
    ec2_instance_name = "public ec2"
    ec2_instance_owner = "data platform team"

}


#create private ec2 
module "private_ec2"{
    source = "../../modules/ec2"
    instance_ami = "ami-08ec94f928cf25a9d"
    instance_type = "t2.micro" 
    subnet_id = module.vpc_module_priv.practice_subnet
    security_group_name = [aws_security_group.private_ec2_sg.id]
    attach_public_ip = false
    ec2_instance_name = "private ec2"
    ec2_instance_owner = "data platform team"

}
