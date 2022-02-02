
locals {
  region = var.region
}

provider "aws" {
  region = local.region
}

provider "kustomization" {
  kubeconfig_path = "~/.kube/config"
}



