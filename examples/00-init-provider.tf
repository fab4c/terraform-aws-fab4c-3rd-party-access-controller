# Provider config

terraform {

  required_version = "~> 1.5"

  required_providers {
    aws = {
      version = "~> 6.0"
      source  = "hashicorp/aws"
    }

  }

}

