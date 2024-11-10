# #Create Security Groups for public instances
resource "aws_security_group" "public_ec2_sg" {
   name = "public security group"
   description = "Allows TLS inbound traffic and outbound traffic"
   vpc_id = module.vpc_module.vpc_id

   tags = {
     Name = "public security group"
     Owner = var.vpc_owner
     Environment = var.environment
   }
 }


resource "aws_vpc_security_group_ingress_rule" "public_allow_all_ipv4_inbound_traffic" {
   security_group_id = aws_security_group.public_ec2_sg.id
   description = "allow all inbound ssh traffic from anywhere on the internet"
   cidr_ipv4         = "0.0.0.0/0"
   ip_protocol       = "tcp"
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
   key_name = "key_pair"
   public_key = file("~/.ssh/my-key.pub")
 }


 #Create Security Groups for private instance
 resource "aws_security_group" "private_ec2_sg" {
   name = "private security group"
   description = "Allows TLS inbound traffic and outbound traffic from public subnet"
   vpc_id = module.vpc_module.vpc_id

   tags = {
     Name = "private security group"
     Owner = var.vpc_owner
     Environment = var.environment
   }
 }


 #rule to allow inbound ssh from public subnet only
 resource "aws_vpc_security_group_ingress_rule" "private_allow_inbound_ipv4_ssh_traffic" {
   security_group_id = aws_security_group.private_ec2_sg.id
   description = "allow ssh from ips within the CIDR of the public subnet"
   ip_protocol = "tcp" 
   from_port = "22"
   to_port = "22"

   #reference the public security group
   referenced_security_group_id = aws_security_group.public_ec2_sg.id 
 }


# #rule to allow all outbound traffic
 resource "aws_vpc_security_group_egress_rule" "private_allow_all_outbound_ipv4_ssh_traffic" {
   security_group_id = aws_security_group.private_ec2_sg.id
   cidr_ipv4 = "0.0.0.0/0"
   ip_protocol = "-1"
 }


 #create public ec2 
 module "public_ec2"{
     source = "../../modules/ec2"
     instance_ami = "ami-089146c5626baa6bf"
     instance_type = "t3.micro" 
     subnet_id = module.public_subnet.subnet_id
     security_group_name = [aws_security_group.public_ec2_sg.id]
     attach_public_ip = true
     ec2_instance_name = "public ec2"
     ec2_instance_owner = var.vpc_owner
     environment = var.environment

 }


# #create private ec2 
 module "private_ec2"{
     source = "../../modules/ec2"
     instance_ami = "ami-089146c5626baa6bf"
     instance_type = "t3.micro" 
     subnet_id = module.private_subnet.subnet_id
     security_group_name = [aws_security_group.private_ec2_sg.id]
     attach_public_ip = false
     ec2_instance_name = "private ec2"
     ec2_instance_owner = var.vpc_owner
     environment = var.environment
 }
