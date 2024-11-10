#Create ec2 instance in public subnet
resource "aws_instance" "custom_instance" {
  ami = var.instance_ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  security_groups = var.security_group_name
  associate_public_ip_address = var.attach_public_ip
  
  tags = {
    Name = var.ec2_instance_name
    Owner = var.ec2_instance_owner
    Environment = var.environment
  }
}
