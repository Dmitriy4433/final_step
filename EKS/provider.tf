# AWS профіль/регіон
provider "aws" {
  region  = var.region
  profile = var.iam_profile
}

# Kubernetes провайдер під EKS
provider "kubernetes" {
  host                   = aws_eks_cluster.danit.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.danit.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.danit.token
}

# ЄДИНИЙ блок required_providers (об'єднав helm+http)
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.12.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

# Helm провайдер через kube creds з EKS
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.danit.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.danit.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.danit.token
  }
}

# HTTP провайдер (для icanhazip)
provider "http" {}

data "aws_availability_zones" "available" {}
