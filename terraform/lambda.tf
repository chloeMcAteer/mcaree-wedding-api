variable "dynamo_table_name" {
  type = string
}

resource "aws_lambda_function" "guestbook_uploader_lambda" {
  function_name = "guestbook_uploader"
  s3_bucket     = aws_s3_bucket.guestbook_uploader_lambda.bucket
  s3_key        = "guestbook_uploader_lambda.zip"

  role    = aws_iam_role.upload_lambda_role.arn
  handler = "index.handler"
  runtime = "nodejs14.x"

  timeout = 60

  source_code_hash = base64sha256(filemd5("../guestbook_uploader_lambda.zip"))

  environment {
    variables = {
      S3_BUCKET_NAME  = var.guestbook_uploads
      DATABASE_NAME = var.dynamo_table_name
    }
  }

  tags = {
    "project" = "mcaree-wedding"
  }

  depends_on = [
    aws_s3_bucket_object.lambda_zip,
    aws_s3_bucket.guestbook_uploads
  ]
}

resource "aws_s3_bucket" "guestbook_uploader_lambda" {
  bucket = "guestbook-uploader-lambda"
  acl    = "private"

  tags = {
    "project" = "mcaree-wedding"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_lambda_private_policy" {
  bucket = aws_s3_bucket.guestbook_uploader_lambda.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "lambda_zip" {
  bucket = aws_s3_bucket.guestbook_uploader_lambda.bucket
  key    = "guestbook_uploader_lambda.zip"
  source = "../guestbook_uploader_lambda.zip"

  etag = filemd5("../guestbook_uploader_lambda.zip")
}