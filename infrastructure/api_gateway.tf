resource "aws_apigatewayv2_api" "http_api" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"
  cors_configuration {
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_origins = ["*"]
    allow_headers = ["content-type", "authorization"]
    max_age       = 300
  }
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.lambda_function.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "user_count_get" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /user-count"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
resource "aws_apigatewayv2_route" "user_count_post" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /user-count"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
resource "aws_apigatewayv2_route" "some_default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*/*"
}
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}
output "API_ENDPOINT" {
  value = aws_apigatewayv2_api.http_api.api_endpoint

}
