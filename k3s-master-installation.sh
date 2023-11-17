# Installation Script for K3s Master Node
# OS : Ubuntu 22.04

# Update existing packages
sudo apt update
sudo apt upgrade -y

# Install vim for debugging purpose
sudo apt install -y vim curl wget net-tools

# Install K3s with docker
curl https://releases.rancher.com/install-docker/20.10.sh | sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.112" sh -s - --docker

## then switch to the root user
sudo -i

kubectl cluster-info

## generate token for worker to join
k3s token create

## port forwarding
kubectl port-forward service/web-service 80:3000
kubectl port-forward service/gateway-service 8080:8080
