resource "aws_dynamodb_table" "lock_table" {
  name = var.lockfile_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S" # String type
  }
  tags = {
    Environment = var.env
  }
}