variable "guestbook_uploads" {
  type = string
}
resource "aws_s3_bucket" "guestbook_uploads" {
  bucket = var.guestbook_uploads
  acl    = "private"

  tags = {
    "project" : "mcaree-wedding"
  }
}