# -----------------------------------------------------------------------------
# DEPLOY INFRABLE.IO ON AWS.
# -----------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket         = "terraform-state-infrable-io"
    key            = "infrable-io/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-infrable-io"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "terraform_aws_static_website" {
  source      = "git@github.com:infrable-io/terraform-aws-static-website.git"
  domain_name = "infrable.io"
}
