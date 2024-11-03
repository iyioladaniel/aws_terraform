# Create S3 bucket
# resource "aws_s3_bucket" "terraform_state" {
#     bucket = "remote-state-bucket-vpc-stack"
# }

# # Configure s3 bucket versioning
# resource "aws_s3_bucket_versioning" "versioning" {
#     bucket = aws_s3_bucket.terraform_state.bucket

#     versioning_configuration {
#         status = "Enabled"
#     }
# }

# Create DynamoDB table for terraform state locking
# resource "aws_dynamodb_table" "terraform_lock" {
#     name         = "terraform-lock-table"
#     billing_mode = "PAY_PER_REQUEST"
#     hash_key     = "LockID"

#     attribute {
#         name = "LockID"
#         type = "S"
#     }
# }

#configured in aws cli using 
# Create the S3 bucket in eu-central-1
# aws s3api create-bucket \
#     --bucket remote-state-bucket \
#     --region eu-central-1 \
#     --create-bucket-configuration LocationConstraint=eu-central-1

# Enable versioning on the bucket
# aws s3api put-bucket-versioning \
#     --bucket remote-state-bucket \
#     --versioning-configuration Status=Enabled
