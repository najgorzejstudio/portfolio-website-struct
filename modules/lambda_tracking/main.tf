data "archive_file" "lambda_zip_file" {
    type        = "zip"
    source_file = "${path.module}/main.py"
    output_path = "${path.module}/main.zip"

}

resource "aws_lambda_function" "resume-site-lambda" {
    function_name = var.function_name
    filename      = data.archive_file.lambda_zip_file.output_path
    role          = aws_iam_role.resume_lambda_role.arn
    handler       = "main.handler"
    runtime       = "python3.11"
    timeout       = 30

    source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256

    environment {
      variables =  {
        TABLE_NAME = var.dynamodb_table_name
      }
    }
}