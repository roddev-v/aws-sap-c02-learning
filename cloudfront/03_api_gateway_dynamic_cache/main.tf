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

resource "aws_lambda_function" "lambda_ttl_example_a" {
  function_name = "api_with_ttl_example_a"
  role          = aws_iam_role.basic_json_lambda_role.arn
  runtime       = "nodejs20.x"
  handler       = "index.handle"
  filename      = "${path.module}/api/dist/ttlExampleA.zip"
}

resource "aws_lambda_function" "lambda_ttl_example_b" {
  function_name = "api_with_ttl_example_b"
  role          = aws_iam_role.basic_json_lambda_role.arn
  runtime       = "nodejs20.x"
  handler       = "index.handle"
  filename      = "${path.module}/api/dist/ttlExampleB.zip"
}


resource "aws_api_gateway_rest_api" "rest_api" {
  name = "dynamic-ttl-api"
}

resource "aws_api_gateway_resource" "ttl_example_a" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "ttl-example-a"
}

resource "aws_api_gateway_resource" "ttl_example_b" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "ttl-example-b"
}

resource "aws_api_gateway_method" "get_ttl_example_a" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.ttl_example_a.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_ttl_example_b" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.ttl_example_b.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ttl_example_a_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.ttl_example_a.id
  http_method = aws_api_gateway_method.get_ttl_example_a.http_method

  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.lambda_ttl_example_a.invoke_arn
}

resource "aws_api_gateway_integration" "ttl_example_b_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.ttl_example_b.id
  http_method = aws_api_gateway_method.get_ttl_example_b.http_method

  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.lambda_ttl_example_b.invoke_arn
}

resource "aws_lambda_permission" "apigw_invoke_ttl_a" {
  statement_id  = "AllowAPIGatewayInvokeTTLA"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_ttl_example_a.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_invoke_ttl_b" {
  statement_id  = "AllowAPIGatewayInvokeTTLB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_ttl_example_b.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "ttl_deploy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeploy = sha1(jsonencode([
      aws_api_gateway_integration.ttl_example_a_integration,
      aws_api_gateway_integration.ttl_example_b_integration
    ]))
  }

  depends_on = [
    aws_api_gateway_integration.ttl_example_a_integration,
    aws_api_gateway_integration.ttl_example_b_integration
  ]
}

resource "aws_api_gateway_stage" "ttl_stage" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  deployment_id = aws_api_gateway_deployment.ttl_deploy.id
  stage_name    = "prod"
}

resource "aws_cloudfront_cache_policy" "dynamic_cache_policy" {
  min_ttl     = 0
  max_ttl     = 86400 # 1 day
  default_ttl = 3600  # 1h

  name = "dynamic_cache_policy"

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
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

    cache_policy_id = aws_cloudfront_cache_policy.dynamic_cache_policy.id
  }

  origin {
    origin_id   = "apigateway"
    domain_name = replace(aws_api_gateway_stage.ttl_stage.invoke_url, "/^https?://([^/]*).*/", "$1")
    origin_path = "/${aws_api_gateway_stage.ttl_stage.stage_name}"
    

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
}
