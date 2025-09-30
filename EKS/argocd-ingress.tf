# Створюємо власний ingress для ArgoCD
resource "kubernetes_ingress_v1" "argocd_custom" {
  metadata {
    name      = "argocd-custom"
    namespace = "argocd"
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"     = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
      "external-dns.alpha.kubernetes.io/hostname"    = "argocd.${var.name}.${var.zone_name}"
    }
  }

  spec {
    ingress_class_name = "nginx"
    
    rule {
      host = "argocd.${var.name}.${var.zone_name}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
  
  depends_on = [helm_release.argocd]
}
