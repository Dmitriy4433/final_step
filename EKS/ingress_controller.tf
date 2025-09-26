# resource "helm_release" "nginx_ingress" {
#   name             = "ingress-nginx"
#   repository       = "https://kubernetes.github.io/ingress-nginx"
#   chart            = "ingress-nginx"
#   version          = "4.10.0"
#   namespace        = "kube-system"
#   create_namespace = true

#   # This is the marker that node is not edge, we add label system in eks node group
#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
#     value = module.acm.acm_certificate_arn
#   }
#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
#     value = "http"
#   }
#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
#     value = "https"
#   }
#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
#     value = "internet-facing"
#   }
#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
#     value = "nlb"
#   }
#   set {
#     name  = "controller.service.targetPorts.http"
#     value = "http"
#   }
#   set {
#     name  = "controller.service.targetPorts.https"
#     value = "http"
#   }
# }

########################################
# Ingress NGINX через Helm + TLS на NLB
# (сертифікат ACM уже створений модулем `module.acm`)
########################################

resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.10.0"
  namespace        = "kube-system"
  create_namespace = true
  wait             = true
  timeout          = 900

  # Підв'язуємо ACM-сертифікат до NLB-лістенера 443.
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = module.acm.acm_certificate_arn
  }

  # TLS термінація на NLB. Далі з NLB -> до pod-ів — TCP (plain HTTP).
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "tcp"
  }

  # Які порти NLB мають бути TLS (443).
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
    value = "https"
  }

  # Публічний NLB.
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }

  # Тип балансувальника — NLB.
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  # Опційно: крос-зонова балансировка (рекомендовано).
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
  }

  # Мапимо "https" сервіс на pod-порт 80 (бо TLS завершується на NLB).
  set {
    name  = "controller.service.targetPorts.https"
    value = "http"
  }

  # Залишаємо HTTP як є.
  set {
    name  = "controller.service.targetPorts.http"
    value = "http"
  }
}

# Прочитати hostname NLB сервісу після інсталяції
data "kubernetes_service" "nginx_lb" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "kube-system"
  }
  depends_on = [helm_release.nginx_ingress]
}

output "nginx_nlb_hostname" {
  description = "DNS-ім'я NLB для ingress-nginx"
  value       = try(data.kubernetes_service.nginx_lb.status[0].load_balancer[0].ingress[0].hostname, "")
}
