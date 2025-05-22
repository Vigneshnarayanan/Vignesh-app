# Vignesh App - Helm Deployment on Minikube

This project contains a Helm chart for deploying a frontend-backend Kubernetes app on Minikube.

---

## 🛠 Prerequisites

- Docker Desktop
- Minikube
- Helm 3.x
- kubectl
- Git

---

## 🚀 Setup Instructions

### 1. Start Minikube

```bash
minikube start

Deploy Using Helm
helm upgrade --install vignesh-app ./vignesh-app --namespace team-a --create-namespace

Port Forward to Access Services
kubectl port-forward svc/vignesh-app-backend 6101:5000 -n team-a

kubectl port-forward svc/vignesh-app-frontend 8186:80 -n team-a

Now visit:
	•	Backend: http://localhost:6101
	•	Frontend: http://localhost:8186
Local CI/CD Testing with act

act -j helm-lint

Helm Chart structure

vignesh-app/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── hpa.yaml
│   └── pvc.yaml


