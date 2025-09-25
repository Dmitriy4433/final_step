locals {
  # DNS для ArgoCD: argocd.<cluster-name>.<zone_name>
  argocd_host = "argocd.${var.name}.${var.zone_name}"
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"


  namespace        = "argocd"
  create_namespace = true

  # TLS термінація на NLB, тому сервер слухає HTTP всередині кластера
  set {
    name  = "server.insecure"
    value = "true"
  }

  # Тип сервісу для argocd-server
  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  # Ingress через nginx + наш DNS-хост
  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }
  set {
    name  = "server.ingress.hosts[0]"
    value = local.argocd_host
  }

  # Встановити CRD (на випадок, якщо не включені за замовчуванням)
  set {
    name  = "crds.install"
    value = "true"
  }

  depends_on = [
    aws_eks_node_group.danit-amd,
    helm_release.nginx_ingress,
  ]
}
