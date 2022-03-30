# argocd-education

# Initializing infrastructure 
*Note: if some resources were created before, please delete all related namespaces first.* 

## 0. Prerequisites
See https://github.com/SergeyDz/terraform-infrastructure-sample/blob/main/vms/docker-windows-server-sample/init.ps1 for details

0.1. Docker Desktop needs to be install 
0.2. Hyper-V needs to be enabled
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install kind minikube k9s kubernetes-helm octant -y
```

*If You are using minikube - needs to create new cluster with extra resources*
```
minikube start --memory 4096 --cpus 4 --nodes 2
minikube tunnel
```

## 1. Deploy argo-cd to orchestrate the cluster
```
kubectl cluster-info
kubectl create namespace argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/SergeyDz/argocd-education/main/argocd-all-in-one.yml
```
*Need to wait until argocd will install and create all corresponding resources*

## 2. Expose port and user login
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

*Windows user ? Not a problem!*
```
$p = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($p))
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## 3. Login to Argo CD UI
Open http://localhost:8080
User: admin 
Password: use output from 2

## 4. Initialize applications tree
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/SergeyDz/argocd-education/main/argocd-applications-root.yaml
```

## 5. Accessing cluster components
```
kubectl port-forward svc/prometheus-grafana -n monitoring 8081:80
```