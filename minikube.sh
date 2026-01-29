

minikube start --nodes=2 --cpus=1 --memory=2048
minikube start --nodes=2


# for loading images to minikube
minikube image load todo-app-kubernetes-todo-frontend:latest
minikube image load todo-app-kubernetes-todo-backend:latest



# for mounting folder to minikube (below cmd must stay alive to access the mount).
minikube mount /media/homepc/FILES/lavan-practice/Todo-App-Kubernetes/persistent-stores/mongo-vol:/persistent-stores/mongo-vol

kubectl -n todo-app port-forward service/frontend-svc 3331:3000
alias k="kubectl -n todo-app"