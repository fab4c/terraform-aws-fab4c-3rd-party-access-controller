# Provider config

terraform {

  required_version = "~> 1.5"

  required_providers {
    aws = {
      version = "~> 6.0"
      source  = "hashicorp/aws"
    }

    null = {
      version = "2.1.2"
      source  = "hashicorp/null"
    }

    template = {
      version = "2.2.0"
      source  = "hashicorp/template"
    }

    local = {
      version = "2.4.1"
      source  = "hashicorp/local"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }

    tfutils = {
      source  = "fab4c/tfutils"
      version = "0.4.0"
    }

  }

}

