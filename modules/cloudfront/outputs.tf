output "distribution_arn" {
  value = aws_cloudfront_distribution.cloudfront.arn
}

output "domain_name" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}