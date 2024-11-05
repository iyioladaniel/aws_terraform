variable "id_of_vpc"{
    description = "vpc in which the security group should be created in"
}


variable "security_group_name"{
    description = "name of security group"
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

variable "sg_inbound_traffic"{
    description = "permissible inbound IP addresses to the ec2 instance"
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

variable "ssh_keyname"{
    description = "name given to the ssh key created"
    default = "ec2 ssh key"
}

variable "ssh_filepath"{
    description = "file path to the ssh key created"
    default = "ec2 ssh key file path for private key"
}

variable "ec2_ami"{
    description = "operating system of ec2"
    default = "ami-08ec94f928cf25a9d"
}

variable "ec2_instance_type"{
    description = "hardware to use for the ec2"
    default = "t2.micro"
}

variable "ec2_instance_name"{
    description = "name of the created ec2"
}

variable "ec2_instance_owner"{
    description = "owner of the created ec2"
    default = "data platform team"
}

variable "ec2_instance_environment"{
    description = "environment of the created ec2"
    default = "dev"
}
