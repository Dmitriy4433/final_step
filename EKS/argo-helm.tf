# locals {
#   cluster_name = var.name
#   argocd_host  = "argocd.${local.cluster_name}.${var.zone_name}"
# }

# resource "helm_release" "argocd" {
#   name       = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   version    = "8.5.6"

#   namespace        = "argocd"
#   create_namespace = true
#   wait             = true
#   timeout          = 900

#   # Використовуємо правильну структуру для ArgoCD v8.5.6
#   set {
#     name  = "server.insecure"
#     # value = "true"
#   }
  
#   set {
#     name  = "server.service.type"
#     value = "ClusterIP"
#   }

#   # Ingress налаштування - правильна структура для v8.5.6
#   set {
#     name  = "server.ingress.enabled"
#     value = "false"
#   }
  
#   set {
#     name  = "server.ingress.ingressClassName"
#     value = "nginx"
#   }
  
#   set_list {
#     name  = "server.ingress.hosts"
#     value = [local.argocd_host]
#   }

#   # Анотації
#   set {
#     name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-redirect"
#     value = "false"
#   }
  
#   set {
#     name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/backend-protocol"
#     value = "HTTP"
#   }
  
#   set {
#     name  = "server.ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
#     value = local.argocd_host
#   }

#   # CRDs
#   set {
#     name  = "crds.install"
#     value = "true"
#   }

#   depends_on = [
#     helm_release.nginx_ingress
#   ]
# }

# output "argocd_hostname" {
#   value = local.argocd_host
# }
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
    # важливо: ArgoCD повинен знати свій зовнішній URL і що він HTTP
    configs = {
      cm = {
        url = "http://${local.argocd_host}"
      }
      params = {
        "server.insecure" = true
      }
    }

    server = {
      service = { type = "ClusterIP" }
      ingress = {
        enabled          = true
        ingressClassName = "nginx"
        hosts            = [local.argocd_host]
        annotations = {
          "nginx.ingress.kubernetes.io/ssl-redirect"     = "false"
          "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
          "external-dns.alpha.kubernetes.io/hostname"    = local.argocd_host
        }
      }
    }
  })]

  depends_on = [helm_release.nginx_ingress]
}

output "argocd_hostname" {
  value = local.argocd_host
}
