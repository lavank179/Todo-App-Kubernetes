

# Install minikube ubuntu
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

minikube start --nodes=2 --cpus=1 --memory=2048
minikube start --nodes=2


# for loading images to minikube
minikube image load todo-app-kubernetes-todo-frontend:latest
minikube image load todo-app-kubernetes-todo-backend:latest

kind load docker-image todo-app-kubernetes-todo-frontend:latest --name kind-cluster
docker save -o todo-frontend.tar todo-app-kubernetes-todo-frontend:latest
kind load image-archive todo-frontend.tar --name kind-cluster

docker save -o todo-backend.tar todo-app-kubernetes-todo-backend:latest
kind load image-archive todo-backend.tar --name kind-cluster


kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/headlamp/main/kubernetes-headlamp.yaml

minikube cp ./backend/video.mp4 /todo_storage/backend/staticfiles/video.mp4


# for mounting folder to minikube (below cmd must stay alive to access the mount).
minikube mount /media/homepc/FILES/lavan-practice/Todo-App-Kubernetes/persistent-stores/mongo-vol:/persistent-stores/mongo-vol

kubectl -n todo-app port-forward service/frontend-svc 3331:3000
alias k="kubectl -n todo-app"


minikube ssh
cd /
sudo mkdir todo_storage
cd todo_storage/
sudo mkdir logs
sudo mkdir backend
cd logs/
sudo mkdir backend
sudo mkdir frontend
cd ../backend/
sudo mkdir staticfiles