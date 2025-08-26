provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket  = "dgamrlewis-3tier-web-application-tf-state"
    key     = "prod/dgamrlewis-3tier-web-application.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}