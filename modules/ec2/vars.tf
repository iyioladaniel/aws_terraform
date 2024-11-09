variable "instance_ami"{
    description = "operating system of the ec2"
    default = "ami-08ec94f928cf25a9d"
}


variable "instance_type"{
    description = "hardware to use for the ec2"
    default = "t2.micro"
}


variable "security_group_name"{
    description = "security group name for the ec2"
}


variable "attach_public_ip"{
    description = "specify 'true' if ec2 instance will be in a public subnet, 'false' otherwise"
    default = false
}


variable "subnet_id"{
    description = "id of subnet to create the ec2"
}

variable "ec2_instance_name"{
    description = "name of the created private ec2"
}

variable "ec2_instance_owner"{
    description = "owner of the created ec2"
    default = "data platform team"
}

variable "environment"{
    description = "environment of the created ec2"
}
