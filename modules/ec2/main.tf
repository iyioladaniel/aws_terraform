#Create Security Groups for public instances
resource "aws_security_group" "public_ec2_sg" {
  name = "${var.security_group_name}"
  description = "Allows TLS inbound traffic and outbound traffic"
  vpc_id = "${var.id_of_vpc}"

  tags = {
    Name = "${var.security_group_name}"
    owner = "${var.ec2_sg_owner}"
    environment = "${var.ec2_sg_environment}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_all_ipv4_inbound_traffic" {
  security_group_id = aws_security_group.public_ec2_sg.id
  description = "allow all inbound ssh traffic from anywhere on the internet"
  cidr_ipv4         = "${var.sg_inbound_traffic}"
  ip_protocol       = "${var.sg_ip_protocol}"
  #Port 22 is used to establish an SSH connection to an EC2 instance and access a shell
  from_port         = "${var.port_number}"
  to_port           = "${var.port_number}"
}

#rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "public_allow_all_ipv4_outbound_traffic" {
  security_group_id = aws_security_group.public_ec2_sg.id
  cidr_ipv4 = "${var.sg_inbound_traffic}"
  ip_protocol = "${var.sg_ip_protocol}"
}

#Create key pair for SSH access
resource "aws_key_pair" "public_ec2_key_pair" {
  key_name = "${var.ssh_keyname}"
  public_key = "${var.ssh_filepath}"
}

#Create ec2 instance in public subnet
resource "aws_instance" "public_instance" {
  ami = "${var.ec2_ami}"
  instance_type = "${var.ec2_instance_type}"
  subnet_id = module.vpc_module.public_subnet_id
  security_groups = [aws_security_group.public_ec2_sg.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "${var.ec2_instance_name}"
    owner = "${var.ec2_instance_owner}"
    environment = "${var.ec2_instance_environment}"
  }
}

#Create Security Groups for private instance
resource "aws_security_group" "private_ec2_sg" {
  name = "${var.security_group_name}"
  description = "Allows TLS inbound traffic and outbound traffic from public subnet"
  vpc_id = "${var.id_of_vpc}"

  tags = {
    Name = "${var.security_group_name}"
    environment = "${var.ec2_sg_environment}"
  }
}

#rule to allow inbound ssh from public subnet only
resource "aws_vpc_security_group_ingress_rule" "private_allow_inbound_ipv4_ssh_traffic" {
  security_group_id = aws_security_group.private_ec2_sg.id
  description = "allow ssh from ips within the CIDR of the public subnet"
  cidr_ipv4 = "${var.sg_inbound_traffic}"
  ip_protocol = "${var.sg_ip_protocol}" 
  from_port = "${var.port_number}"
  to_port = "${var.port_number}"

  #reference the public security group
  referenced_security_group_id = aws_security_group.public_ec2_sg.id 
}

#rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "private_allow_all_outbound_ipv4_ssh_traffic" {
  security_group_id = aws_security_group.private_ec2_sg.id
  cidr_ipv4 = "${var.sg_inbound_traffic}"
  ip_protocol = "${var.sg_ip_protocol}"
}

# Create ec2 instance in private subnet
resource "aws_instance" "private_instance" {
  ami = "${var.ec2_ami}"
  instance_type = "${var.ec2_instance_type}"
  subnet_id = module.vpc_module.private_subnet_id
  security_groups = [aws_security_group.private_ec2_sg.id]

  tags = {
    Name = "${var.ec2_instance_name}"
    owner= "${var.ec2_instance_owner}"
    environment = "${var.ec2_instance_environment}"
  }
}
