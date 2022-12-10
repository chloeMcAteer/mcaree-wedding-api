provider "aws" {
  region  = "eu-west-2"
  profile = "default"
}

# S3 bucket for holding terraform state
terraform {
  backend "s3" {
    bucket = "mcaree-guestbook-terraform-state"
    key    = "guestbook-api/terraform.tfstate"
    region = "eu-west-2"
  }
}
