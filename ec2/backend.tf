terraform {
  backend "s3" {
    bucket         = "remote-state-bucket-vpc-stack"
    key            = "state-files/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}
