terraform {
  required_version = "~> 1.10.3"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.49.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-backend-h"
    region         = "ap-south-1"
    key            = "eks/terraform.tfstate"
    dynamodb_table = "Lock-Files"
    encrypt        = true
  }
  
}