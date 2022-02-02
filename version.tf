terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }

    kustomization = {
      source  = "kbst/kustomize"
      version = "0.2.0-beta.3"
    }

  }
}