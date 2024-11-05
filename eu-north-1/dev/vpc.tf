module "vpc"{
    source = "path to vpc module"
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "..."
    vpc_stack_owner = "data platform team"
    vpc_stack_resource_environment = "dev"
    private_subnet_cidr = "10.0.0.0/24"
    private_subnet_name = "private subnet"
    public_subnet_cidr  = "10.0.1.0/24"
    public_subnet_name = "public subnet"
    internet_gateway_name = "internet gateway"
    elastic_ip_name = "company elastic_ip"
    nat_gateway_name = "public nat gateway"
    public_route_table_destination = "0.0.0.0/0"
    public_route_table_name = "public route table"
    private_route_table_destination = "0.0.0.0/0"
    private_route_table_name = "private route table"
}


