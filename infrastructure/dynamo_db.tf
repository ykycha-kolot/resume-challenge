resource "aws_dynamodb_table" "user_count" {
  name         = "user_count"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  table_class  = "STANDARD_INFREQUENT_ACCESS"

  attribute {
    name = "id"
    type = "S"
  }
  
}