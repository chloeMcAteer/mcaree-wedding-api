resource "aws_dynamodb_table" "guestbook-entries-table" {
  name           = "guestbook_entries"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "entry_id"

  attribute {
    name = "entry_id"
    type = "S"
  }

  tags = {
    project = "mcaree-wedding"
  }
}