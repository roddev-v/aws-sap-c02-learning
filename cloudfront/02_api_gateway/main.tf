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
}
