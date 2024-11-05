terraform {
  backend "s3" {
    bucket         = "remote-state-bucket-vpc-stack"
    key            = "prod-state-files/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}
