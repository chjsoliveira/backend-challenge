# Criando o API Gateway
resource "aws_api_gateway_rest_api" "auth_api" {
  name        = "AuthAPI"
  description = "API AuthCloud para Validação JWT"
}

# Criando um Resource no API Gateway
resource "aws_api_gateway_resource" "jwt_validation" {
  rest_api_id = aws_api_gateway_rest_api.auth_api.id
  parent_id   = aws_api_gateway_rest_api.auth_api.root_resource_id
  path_part   = "jwtvalidation"
}

# Criando um método POST no Resource
resource "aws_api_gateway_method" "post_validate_jwt" {
  rest_api_id   = aws_api_gateway_rest_api.auth_api.id
  resource_id   = aws_api_gateway_resource.jwt_validation.id
  http_method   = "POST"
  authorization = "NONE"  # Ou utilize um método de autenticação
}


# Integração com o Load Balancer
resource "aws_api_gateway_integration" "validate_jwt_integration" {
  rest_api_id = aws_api_gateway_rest_api.auth_api.id
  resource_id = aws_api_gateway_resource.jwt_validation.id
  http_method = aws_api_gateway_method.post_validate_jwt.http_method

  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_lb.authcloud_lb.dns_name}"
}

# Deploy do API Gateway
resource "aws_api_gateway_deployment" "auth_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.auth_api.id
  stage_name  = "prod"

  depends_on = [aws_api_gateway_method.post_validate_jwt]
}
