terraform {
    required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 3.0"
      }
    }
}

provider "aws" {
  region = "ap-southeast-1"
  access_key = "AKIAXLLOVC6CWB2W2C5F"
  secret_key = "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"
}