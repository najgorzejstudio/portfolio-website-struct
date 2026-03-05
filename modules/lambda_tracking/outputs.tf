output "lambda_function_name" {
  value = aws_lambda_function.resume-site-lambda.function_name
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.resume-site-lambda.invoke_arn
}

output "lambda_arn" {
  value = aws_lambda_function.resume-site-lambda.arn
}