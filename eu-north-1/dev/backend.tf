terraform {
  backend "s3" {
    bucket         = "dpe-terraform-statefile"
    key            = "dev/dev.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}
