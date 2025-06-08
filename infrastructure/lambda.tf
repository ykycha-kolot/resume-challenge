data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "lambda_dynamodb_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${var.dynamodb_table_name}"]
  }
}
data "aws_iam_policy_document" "lambda_logs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}
resource "aws_iam_role" "iam_for_lambda" {
  name               = "lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name   = "lambda_dynamodb_policy"
  policy = data.aws_iam_policy_document.lambda_dynamodb_policy.json
}

resource "aws_iam_policy" "lambda_logs_policy" {
  name   = "lambda_logs_policy"
  policy = data.aws_iam_policy_document.lambda_logs_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
}
resource "aws_lambda_function" "lambda_function" {
  function_name    = "user_count_lambda"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.13"
  filename         = "${path.module}/../lambda/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/lambda_function.zip")
}
