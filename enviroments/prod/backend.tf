terraform {
  backend "s3" {
    bucket         = "terraform-state-mieszko"
    key            = "resume-site/prod/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}