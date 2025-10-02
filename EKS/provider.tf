# # AWS профіль/регіон
# provider "aws" {
#   region  = var.region
#   profile = var.iam_profile
# }

# # Kubernetes провайдер під EKS
# provider "kubernetes" {
#   host                   = aws_eks_cluster.danit.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.danit.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.danit.token
# }

# # ЄДИНИЙ блок required_providers (об'єднав helm+http)
# terraform {
#   required_providers {
#     helm = {
#       source  = "hashicorp/helm"
#       version = "= 2.12.1"
#     }
#     http = {
#       source  = "hashicorp/http"
#       version = "~> 3.4"
#     }
#   }
# }

# # Helm провайдер через kube creds з EKS
# provider "helm" {
#   kubernetes {
#     host                   = aws_eks_cluster.danit.endpoint
#     cluster_ca_certificate = base64decode(aws_eks_cluster.danit.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.danit.token
#   }
# }

# # HTTP провайдер (для icanhazip)
# provider "http" {}

# data "aws_availability_zones" "available" {}


# AWS профіль/регіон
provider "aws" {
  region  = var.region
  profile = var.iam_profile
}

# Kubernetes провайдер під EKS
provider "kubernetes" {
  host                   = aws_eks_cluster.danit.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.danit.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.danit.token
}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.12.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.danit.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.danit.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.danit.token
  }
}

provider "http" {}

data "aws_availability_zones" "available" {}

# External-DNS через публічний модуль
module "eks-external-dns" {
  source  = "lablabs/eks-external-dns/aws"
  version = "2.1.1"

  cluster_identity_oidc_issuer     = aws_eks_cluster.danit.identity.0.oidc.0.issuer
  cluster_identity_oidc_issuer_arn = module.oidc-provider-data.arn
}