# for loading images to minikube
# minikube image load todo-app-kubernetes-todo-frontend:latest
# minikube image load todo-app-kubernetes-todo-backend:latest


minikube cp ./scripts/minikube-volume-folder-setup.sh minikube-m02:/home/docker/setup.sh
minikube ssh -n minikube-m02 "sudo chmod +x /home/docker/setup.sh && sudo /home/docker/setup.sh"
minikube cp ./backend/video.mp4 minikube-m02:/todo_storage/backend/staticfiles/video.mp4