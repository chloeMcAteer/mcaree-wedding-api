variable "guestbook_api_key_value" {
  type = string
}

resource "aws_api_gateway_usage_plan" "api_gw_usage_plan" {
  name        = "guestbook-plan"
  description = "Usage plan for managing all requests into API Gateway"

  api_stages {
    api_id = aws_api_gateway_rest_api.main.id
    stage  = "production"
  }

  throttle_settings {
    burst_limit = 1000
    rate_limit  = 200
  }

  depends_on = [
    aws_api_gateway_deployment.main,
  ]
}

resource "aws_api_gateway_api_key" "api_gw_guestbook_key" {
  name  = "guestbook-key"
  value = var.guestbook_api_key_value
}

resource "aws_api_gateway_usage_plan_key" "api_gw_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.api_gw_guestbook_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.api_gw_usage_plan.id
}