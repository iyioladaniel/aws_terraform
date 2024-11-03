#Import vpc module
module vpc_module {
  source = "../vpc/"
}

#Create Security Groups for public instances
resource "aws_security_group" "public_ec2_sg" {
  name = "public_ec2_sg"
  description = "Allows TLS inbound traffic and outbound traffic"
  vpc_id = module.vpc_module.practice_vpc_id

  tags = {
    Name = "public_ec2_security_group"
    owner = "Data Platform Team"
    environment = "production"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_all_ipv4_inbound_traffic" {
  security_group_id = aws_security_group.public_ec2_sg.id
  description = "allow all inbound ssh traffic from anywhere on the internet"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  #Port 22 is used to establish an SSH connection to an EC2 instance and access a shell
  from_port         = 22 
  to_port           = 22
}

#rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "public_allow_all_ipv4_outbound_traffic" {
  security_group_id = aws_security_group.public_ec2_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

#Create key pair for SSH access
resource "aws_key_pair" "public_ec2_key_pair" {
  key_name = "dpe_practice_key_pair"
  public_key = file("${path.module}/dpe_practice_key.pub")
}

#Create ec2 instance in public subnet
resource "aws_instance" "public_instance" {
  ami = "ami-08ec94f928cf25a9d"
  instance_type = "t2.micro"
  subnet_id = module.vpc_module.public_subnet_id
  security_groups = [aws_security_group.public_ec2_sg.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "public_instance"
    owner= "Data Platform Team"
    subnet = "public_subnet"
  }
}

#Create Security Groups for private instance
resource "aws_security_group" "private_ec2_sg" {
  name = "private_ec2_sg"
  description = "Allows TLS inbound traffic and outbound traffic from public subnet"
  vpc_id = module.vpc_module.practice_vpc_id

  tags = {
    Name = "private_ec2_security_group"
    environment = "vpc_stacks_practice"
  }
}

#rule to allow inbound ssh from public subnet only
resource "aws_vpc_security_group_ingress_rule" "private_allow_inbound_ipv4_ssh_traffic" {
  security_group_id = aws_security_group.private_ec2_sg.id
  description = "allow ssh from ips within the CIDR of the public subnet"
  cidr_ipv4 = module.vpc_module.public_subnet_cidr_block
  ip_protocol = "tcp" 
  from_port = 22
  to_port = 22

  #reference the public security group
  referenced_security_group_id = aws_security_group.public_ec2_sg.id 
}

#rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "private_allow_all_outbound_ipv4_ssh_traffic" {
  security_group_id = aws_security_group.private_ec2_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

# Create ec2 instance in private subnet
# You can search for amis on aws cli using aws ec2 describe-images --owner amazon --filter "Name=**,Value=**"
 # The ami_id for Amazon Linux 2023 AMI (free tier) is ami-08ec94f928cf25a9d
resource "aws_instance" "private_instance" {
  ami = "ami-08ec94f928cf25a9d"
  instance_type = "t2.micro"
  subnet_id = module.vpc_module.private_subnet_id
  security_groups = [aws_security_group.private_ec2_sg.id]

  tags = {
    Name = "private_instance"
    owner= "Data Platform Team"
    subnet = "private_subnet"
    environment = "vpc_stacks_practice"
  }
}
