resource "aws_lambda_function" "dummy_lambda" {
  function_name = "dummy-lamba"
  handler       = "helloWorld.handle"
  runtime       = "nodejs20.x"
  filename      = "${path.module}/dist/helloWorld.zip"
  role          = aws_iam_role.dummy_lambda_iam_role.arn
}

resource "aws_s3_bucket" "dummy_bucket" {
  bucket        = "dummy-bucket-for-lambda-0122025"
  force_destroy = true
}

resource "aws_dynamodb_table" "dummy_table" {
  name         = "Users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}

resource "aws_iam_role" "dummy_lambda_iam_role" {
  name = "dummy_lambda_iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowListBucket",
        Effect   = "Allow",
        Action   = ["s3:ListBucket"],
        Resource = "${aws_s3_bucket.dummy_bucket.arn}/*"
      },
      {
        Sid      = "AllowGetObject",
        Effect   = "Allow",
        Action   = ["s3:GetObject"],
        Resource = "${aws_s3_bucket.dummy_bucket.arn}/*"
      },
      {
        Sid = "AllowDynamoRead"
        Effect = "Allow",
        Action = ["dynamodb:GetItem"]
        Resource = "${aws_dynamodb_table.dummy_table.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_to_role" {
  role       = aws_iam_role.dummy_lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
