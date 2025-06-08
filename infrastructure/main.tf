terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region 
  profile = var.user_account
}

locals {
  content_types = {
    "index.html" = "text/html"
    "error.html" = "text/html"
    "styles.css" = "text/css"
    "script.js"  = "application/javascript"
  }
}