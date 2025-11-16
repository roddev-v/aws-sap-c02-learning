resource "aws_iam_role" "basic_json_lambda_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "basic_json_lambda" {
  function_name = "basic_api_returing_data"
  role          = aws_iam_role.basic_json_lambda_role.arn
  runtime       = "nodejs20.x"
  handler       = "index.handle"
  filename      = "${path.module}/api/dist/helloWorld.zip"
}


resource "aws_api_gateway_rest_api" "rest_api" {
  name = "basic-api"
}

resource "aws_api_gateway_resource" "hello_world" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "hello-world"
}

resource "aws_api_gateway_method" "get_hello_world" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.hello_world.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.hello_world.id
  http_method = aws_api_gateway_method.get_hello_world.http_method

  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.basic_json_lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.basic_json_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "hello_deploy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeploy = sha1(jsonencode(aws_api_gateway_rest_api.rest_api))
  }

  depends_on = [
    aws_api_gateway_integration.hello_integration
  ]
}

resource "aws_api_gateway_stage" "hello_stage" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  deployment_id = aws_api_gateway_deployment.hello_deploy.id
  stage_name    = "prod"
}

resource "aws_cloudfront_distribution" "cached_api" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "Cached CloudFront distribution for API"

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    target_origin_id       = "apigateway"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  origin {
    origin_id   = "apigateway"
    domain_name = replace(aws_api_gateway_stage.hello_stage.invoke_url, "/^https?://([^/]*).*/", "$1")
    origin_path = "/${aws_api_gateway_stage.hello_stage.stage_name}" # Add this line

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
}
