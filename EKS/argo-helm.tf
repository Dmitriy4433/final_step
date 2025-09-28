locals {
  cluster_name = var.name
  argocd_host  = "argocd.${local.cluster_name}.${var.zone_name}"
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "8.5.6"

  namespace        = "argocd"
  create_namespace = true
  wait             = true
  timeout          = 900

  values = [yamlencode({
    configs = {
      cm = {
        url = "http://${local.argocd_host}"
      }
      params = {
        "server.insecure" = true
      }
    }

    server = {
      service = { 
        type = "ClusterIP" 
      }
      ingress = {
        enabled          = false  # Вимикаємо ingress ArgoCD - використовуємо власний
        ingressClassName = "nginx"
        hosts            = [local.argocd_host]
        annotations = {
          "nginx.ingress.kubernetes.io/ssl-redirect"     = "false"
          "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
          "external-dns.alpha.kubernetes.io/hostname"    = local.argocd_host
        }
      }
    }

    crds = {
      install = true
    }
  })]

  depends_on = [helm_release.nginx_ingress]
}

output "argocd_hostname" {
  value = local.argocd_host
}