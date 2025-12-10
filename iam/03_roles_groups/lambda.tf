resource "aws_lambda_function" "dummy_lambda" {
  function_name = "dummy-lamba"
  handler       = "helloWorld.handle"
  runtime       = "nodejs20.x"
  filename      = "${path.module}/dist/helloWorld.zip"
  role          = aws_iam_role.dummy_lambda_iam_role.arn
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

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_policy" "dummy_lambda_interactions" {
  name = "AllowDummyLambdaInteraction"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "lambda:InvokeFunction",
        "lambda:GetFunction",
      ]
      Resource = "${aws_lambda_function.dummy_lambda.arn}"
      },
    ]
  })
}

resource "aws_iam_policy" "allow_lambda_list" {
  name = "AllowLambdaList"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "lambda:ListFunctions",
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_group_policy_attachment" "attach_to_group" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.dummy_lambda_interactions.arn
}

resource "aws_iam_group_policy_attachment" "attach_to_group_2" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.allow_lambda_list.arn
}
