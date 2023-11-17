# Installation Script for K3s Master Node
# OS : Ubuntu 22.04

# Update existing packages
sudo apt update
sudo apt upgrade -y

# Install vim for debugging purpose
sudo apt install -y vim curl wget net-tools

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.112" sh -

sudo systemctl status k3s

mkdir ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config && sudo chown $USER ~/.kube/config
sudo chmod 600 ~/.kube/config && export KUBECONFIG=~/.kube/config
echo "export KUBECONFIG=~/.kube/config" >> ~/.profile
sudo chown $USER ~/.kube/config

kubectl cluster-info

## generate token for worker to join
k3s token create
