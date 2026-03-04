output "cloudfront_url" {
  value = module.cdn.domain_name
}

output "s3_bucket" {
  value = module.s3_site.bucket_id
}