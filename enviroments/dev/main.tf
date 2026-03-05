module "s3_site"{
    source = "../../modules/s3"

    bucket_name = "${var.project_name}-dev-site"
    cloudfront_distribution_arn = module.cdn.distribution_arn
}

module "cdn" {
  source = "../../modules/cloudfront"

  origin_domain = module.s3_site.bucket_domain_name
}

module "lambda_tracking" {
  source              = "../../modules/lambda_tracking"
  function_name       = "resume-site-counter"
  dynamodb_table_arn  = module.dynamodb.table_arn
  dynamodb_table_name = module.dynamodb.table_name
}

module "api_gateway" {
  source = "../../modules/api_gateway"

  lambda_invoke_arn  = module.lambda_tracking.lambda_invoke_arn
  lambda_function_name = module.lambda_tracking.lambda_function_name
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  dynamodb_table_name = "resume-counter-table"
}