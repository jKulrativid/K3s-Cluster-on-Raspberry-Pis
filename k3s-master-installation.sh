# Installation Script for K3s Master Node
# OS : Ubuntu 22.04

# Update existing packages
sudo apt update
sudo apt upgrade -y

# Install vim for debugging purpose
sudo apt install -y vim curl wget net-tools

# Install K3s with docker
curl https://releases.rancher.com/install-docker/20.10.sh | sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.112" K3S_ARGS="--kube-apiserver-arg=default-not-ready-toleration-seconds=5 --kube-apiserver-arg=default-unreachable-toleration-seconds=5 --kube-apiserver-arg=default-uncordon-toleration-seconds=5 --kube-apiserver-arg=default-delete-local-data-delay=5 --kube-apiserver-arg=default-pod-eviction-timeout=5s --kube-apiserver-arg=default-pod-eviction-headroom=5s" sh -s - server --cluster-init

## ** IF MASTER REPLICA , THEN JOINN AS SERVER AND TAINT IT **
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.113" K3S_ARGS="--kube-apiserver-arg=default-not-ready-toleration-seconds=5 --kube-apiserver-arg=default-unreachable-toleration-seconds=5 --kube-apiserver-arg=default-uncordon-toleration-seconds=5 --kube-apiserver-arg=default-delete-local-data-delay=5 --kube-apiserver-arg=default-pod-eviction-timeout=5s --kube-apiserver-arg=default-pod-eviction-headroom=5s" K3S_TOKEN=K1032daaee4d4a7b13713c39a5a5033962e081c97f4e48e5f4350aca6a4a12697e5::server:bfcd72733bd5474ef5db42864144eaef sh -s - server --server https://192.168.56.112:6443
kubectl taint nodes master-2 special=true:NoSchedule

## then switch to the root user
sudo chown $USER /etc/rancher/k3s/k3s.yaml

kubectl cluster-info

## to get token
sudo cat /var/lib/rancher/k3s/server/token

## generate token for worker to join
k3s token create

## port forwarding
kubectl port-forward service/web-service 80:3000
kubectl port-forward service/gateway-service 8080:8080
