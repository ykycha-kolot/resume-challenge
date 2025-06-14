terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "resume-challenge-tf-state"
    key    = "resume-challenge/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = var.region
  #profile = var.user_account
}

locals {
  content_types = {
    "index.html" = "text/html"
    "error.html" = "text/html"
    "index.css" = "text/css"
    "script.js"  = "application/javascript"
  }
}