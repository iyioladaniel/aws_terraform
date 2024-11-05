variable "id_of_vpc"{
    description = "vpc in which the security group should be created in"
}


variable "public_security_group_name"{
    description = "name of public security group"
    default = "security group"
}

variable "private_security_group_name"{
    description = "name of private security group"
    default = "security group"
}

variable "ec2_sg_owner" {
  description = "owner of created ec2 security resource"
  default = "data platform team"
}

variable "ec2_sg_environment" {
  description = "environment the ec2 security group is deployed"
  default = "dev"
}

variable "public_sg_inbound_traffic"{
    description = "permissible inbound IP addresses to the public ec2 instance"
    default = "0.0.0.0/0"
}

variable "public_sg_outbound_traffic"{
    description = "permissible outbound IP addresses to the public ec2 instance"
    default = "0.0.0.0/0"
}


variable "private_sg_inbound_traffic"{
    description = "permissible inbound IP addresses to the private ec2 instance"
    default = "0.0.0.0/0"
}

variable "private_sg_outbound_traffic"{
    description = "permissible outbound IP addresses to the private ec2 instance"
    default = "0.0.0.0/0"
}

variable "sg_ip_protocol"{
    description = "IP protocol to use"
    default = "-1"
}

variable "port_number"{
    description = "port"
    default = "22"
}

variable "public_ssh_keyname"{
    description = "name given to the ssh key created for public ec2 "
    default = "public-ec2-ssh-key"
}

variable "public_ssh_filepath"{
    description = "file path to the ssh key created for public ec2 instance"
    default = "ec2 ssh key file path for private key"
}

#variable "private_ssh_keyname"{
    #description = "name given to the ssh key created for private ec2 "
    #default = "public-ec2-ssh-key"
#}

#variable "private_ssh_filepath"{
    #description = "file path to the ssh key created for private ec2 instance"
    #default = "ec2 ssh key file path for private key"
#}

variable "public_ec2_ami"{
    description = "operating system of public ec2"
    default = "ami-08ec94f928cf25a9d"
}

variable "public_ec2_instance_type"{
    description = "hardware to use for the public ec2"
    default = "t2.micro"
}

variable "private_ec2_ami"{
    description = "operating system of private ec2"
    default = "ami-08ec94f928cf25a9d"
}

variable "private_ec2_instance_type"{
    description = "hardware to use for the private ec2"
    default = "t2.micro"
}

variable "public_ec2_instance_name"{
    description = "name of the created public ec2"
}

variable "private_ec2_instance_name"{
    description = "name of the created private ec2"
}

variable "ec2_instance_owner"{
    description = "owner of the created ec2"
    default = "data platform team"
}

variable "ec2_instance_environment"{
    description = "environment of the created ec2"
    default = "dev"
}
