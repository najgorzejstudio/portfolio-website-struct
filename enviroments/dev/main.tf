module "s3_site"{
    source = "../../modules/s3"

    bucket_name = "${var.project_name}-dev-site"
    cloudfront_distribution_arn = module.cdn.distribution_arn
}

module "cdn" {
  source = "../../modules/cloudfront"

  origin_domain = module.s3_site.bucket_domain_name
}