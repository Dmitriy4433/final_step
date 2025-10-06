### Terraform init
```sh
terraform init -backend-config "region=eu-central-1" -backend-config "profile=danit"
```

### Terraform apply
```sh
terraform apply -var="iam_profile=danit"
```
# Final Step Project - EKS + ArgoCD

## Структура проекту

- `EKS/` — Terraform для EKS, ACM, ingress-nginx, external-dns, ArgoCD
- `k8s/app/` — маніфести Deployment/Service/Ingress
- `k8s/argocd/argocd-app.yml` — ArgoCD Application (backend-app)
- `app/` — тестовий бекенд (Dockerfile, web-app.py)
- `.github/workflows/ci-docker.yml` — GitHub Actions: build+push

## Як запустити
1. AWS credentials
2. terraform apply
3. ArgoCD
4. Deploy додатку

## URLs
- App: https://app.dpon-finalstep.devops8.test-danit.com
- ArgoCD: https://argocd.dpon-finalstep.devops8.test-danit.com

## Автори
Dmitriy Ponomarenko