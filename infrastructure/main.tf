terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use the appropriate version
    }
  }
}

provider "aws" {
  region  = "us-east-1" # Replace with your desired region
  profile = "tf_user"   # Replace with your profile name
}

locals {
  content_types = {
    "index.html" = "text/html"
    "error.html" = "text/html"
    "styles.css" = "text/css"
    "script.js"  = "application/javascript"
  }
  s3_origin_id = "resume-bucket-tf_origin"
  domain_name = "yurii-k.xyz"
}
