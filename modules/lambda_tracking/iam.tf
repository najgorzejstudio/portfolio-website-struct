resource "aws_iam_role" "resume_lambda_role" {
  assume_role_policy = file("${path.module}/lambda-policy.json")
  name               = "resume_lambda_role"
}

resource "aws_iam_role_policy_attachment" "lambda_exec_role_attachment" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    role       = aws_iam_role.resume_lambda_role.name
}

data "aws_iam_policy_document" "ddb_policy" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:UpdateItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem"
    ]

    resources = [var.dynamodb_table_arn]
  }
}

resource "aws_iam_role_policy" "lambda_ddb_policy" {
  name   = "lambda-ddb-access"
  role   = aws_iam_role.resume_lambda_role.id
  policy = data.aws_iam_policy_document.ddb_policy.json
}