# API Gateway
resource "aws_api_gateway_rest_api" "main" {
  name               = "mcaree-guestbook-api"
  binary_media_types = ["multipart/form-data", "image/png", "image/jpg", "image/jpeg"]
  tags = {
    "project" : "mcaree-wedding"
  }
}

# Main API Gateway resource
resource "aws_api_gateway_resource" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "{proxy+}"
}

# /api - API GW Resource
resource "aws_api_gateway_resource" "api" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "api"
}

# /api/upload - API GW Resource
resource "aws_api_gateway_resource" "upload" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "upload"
}

# POST /api/upload - API Gateway method
resource "aws_api_gateway_method" "upload_method" {
  rest_api_id      = aws_api_gateway_rest_api.main.id
  resource_id      = aws_api_gateway_resource.upload.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "upload_integration" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.upload.id
  http_method = aws_api_gateway_method.upload_method.http_method

  credentials = aws_iam_role.upload_invocation_role.arn

  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.guestbook_uploader_lambda.invoke_arn
  integration_http_method = "POST"
}

# API Gateway deployment
resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "production"
  depends_on = [
    aws_api_gateway_integration.upload_integration,
  ]

  variables = {
    # just to trigger redeploy on resource changes
    resources = join(", ", [aws_api_gateway_resource.main.id, aws_api_gateway_resource.upload.id])

    # note: redeployment might be required with other gateway changes.
    # when necessary run `terraform taint <this resource's address>`
  }

  lifecycle {
    create_before_destroy = true
  }
}