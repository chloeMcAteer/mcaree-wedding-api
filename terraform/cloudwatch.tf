resource "aws_cloudwatch_log_group" "guestbook_uploader_lambda" {
  name              = "/aws/lambda/guestbook/uploader"
  retention_in_days = 14
}