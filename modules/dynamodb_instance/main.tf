resource "aws_dynamodb_table" "dynamotable" {
  name           = var.dynamo_table_name
  billing_mode   = var.dynamo_billing_mode
  hash_key       = "id"

  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${var.env}-${var.dynamo_table_name}"
    Environment = var.env
  }
}