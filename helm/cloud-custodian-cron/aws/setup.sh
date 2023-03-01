aws eks --region us-east-1 update-kubeconfig --name karpenter --profile dzyuban

kubectl config use-context arn:aws:eks:us-east-1:154563028627:cluster/karpenter
kubectl get namespaces 
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/SergeyDz/argocd-education/main/argocd-all-in-one.yml 

sleep 60 


kubectl apply -n argocd -f https://raw.githubusercontent.com/SergeyDz/argocd-education/main/argocd-applications-root.yaml

sleep 120

eksctl update iamserviceaccount --name c7n-service-account --namespace c7n --cluster karpenter  --attach-policy-arn arn:aws:iam::154563028627:policy/c7n-iam-policy --approve
echo "#######################"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo "#######################"
kubectl port-forward svc/argocd-server -n argocd 8080:443

