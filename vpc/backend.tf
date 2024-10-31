terraform {
  backend "s3" {
    bucket         = "remote-state-bucket"
    key            = "state-files/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock-table" # For state locking
    encrypt        = true
  }
}
