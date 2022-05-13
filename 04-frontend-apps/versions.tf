terraform {
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"

  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "dev"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "global"

  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "dev"
    }
  }
}
