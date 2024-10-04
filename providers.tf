terraform {
  required_version = ">= 1.6.6, < 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
      configuration_aliases = [
        aws.west,
        aws.main
      ]
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  alias  = "west"
  region = aws.main

  default_tags {
    tags = {
      filmdrop-project-name = var.project_name
      filmdrop-stage        = var.environment
    }
  }

}

provider "aws" {
  alias = "main"

  default_tags {
    tags = {
      filmdrop-project-name = var.project_name
      filmdrop-stage        = var.environment
    }
  }

}
