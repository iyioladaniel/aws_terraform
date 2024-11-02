terraform {
  backend "s3" {
    bucket         = "remote-state-bucket"
    key            = "state-files/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}