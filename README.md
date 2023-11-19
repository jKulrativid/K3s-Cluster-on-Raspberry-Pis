# Installation Guide

# K3s Cluster Installation

## Hardware Details
VM -> Ubuntu 22.04 (x86) with 2GB RAM & 
Worker -> Raspberry Pi Pico

## Network and IP
```
Network             : 192.168.56.0/24
PC Ethernet Port IP : 192.168.56.111
Master-1 IP         : 192.168.56.112
Master-2 IP         : 192.168.56.113
Worker-x IP         : 192.168.56.3x
```

## K3s Master Installation
#### config static network as defined in the first section

#### Update & Upgrade OS
```bash
sudo apt update
sudo apt upgrade -y
```

#### Install Debugging Tools
```bash
sudo apt install -y vim curl wget net-tools
```

#### Install Docker and K3s
```bash
curl https://releases.rancher.com/install-docker/20.10.sh | sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.112" K3S_ARGS="--kube-apiserver-arg=default-not-ready-toleration-seconds=5 --kube-apiserver-arg=default-unreachable-toleration-seconds=5 --kube-apiserver-arg=default-uncordon-toleration-seconds=5 --kube-apiserver-arg=default-delete-local-data-delay=5 --kube-apiserver-arg=default-pod-eviction-timeout=5s --kube-apiserver-arg=default-pod-eviction-headroom=5s" sh -s - server --cluster-init
```

#### Then change owner of the k3s config
```bash
sudo chown $USER /etc/rancher/k3s/k3s.yaml
```

#### Check if installation succeeded
```bash
kubectl cluster-info
```

#### You will need token for cluster joining, which can be obtained via running
```bash
sudo cat /var/lib/rancher/k3s/server/token
```

## K3s Master Replica Installation

#### config static network as defined in the first section

#### Update & Upgrade OS
```bash
sudo apt update
sudo apt upgrade -y
```

#### Install Debugging Tools
```bash
sudo apt install -y vim curl wget net-tools
```

#### Install K3s
```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.113" K3S_URL=https://192.168.56.112:6443 K3S_ARGS="--kube-apiserver-arg=default-not-ready-toleration-seconds=5 --kube-apiserver-arg=default-unreachable-toleration-seconds=5 --kube-apiserver-arg=default-uncordon-toleration-seconds=5 --kube-apiserver-arg=default-delete-local-data-delay=5 --kube-apiserver-arg=default-pod-eviction-timeout=5s --kube-apiserver-arg=default-pod-eviction-headroom=5s" K3S_TOKEN=<YOUR TOKEN> sh -
```

#### Taint the node in master-1 so that no pod will be schedule here
```bash
kubectl taint nodes master-2 special=true:NoSchedule
```

#### Then change owner of the k3s config
```bash
sudo chown $USER /etc/rancher/k3s/k3s.yaml
```

#### Check if installation succeeded
```bash
kubectl cluster-info
```

## K3s Agent Installation
#### config static network as defined in the first section

#### Update & Upgrade OS
sudo apt update
sudo apt upgrade -y

#### Config Network in Pi
```bash
cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo -i
cat << EOF | sudo tee /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
exit
```

#### Reset Network Config and Disable Swap
```bash
sudo sysctl --system
sudo swapoff -a
```

#### Add CGroup
```bash
sudo -i <<EOF
echo " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" >> /boot/cmdline.txt
EOF
```

#### Then Reboot
```bash
sudo reboot
```

## Then Install K3s Agent
```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip=192.168.56.3x" K3S_URL=https://192.168.56.112:6443 K3S_TOKEN=<YOUR TOKEN> sh -
```

# Deployment

## At Master Node

#### Apply Deployments and Services
```bash
make install_app
```

#### Finally Run (tmux recommended)
```bash
kubectl port-forward -n default service/web-service 3000:3000 --address 0.0.0.0
kubectl port-forward -n default service/gateway-service 8080:8080 --address 0.0.0.0
kubectl port-forward -n default service/chef-service 50001:50001 --address 0.0.0.0
kubectl port-forward -n default service/recipe-service 50002:50002 --address 0.0.0.0
kubectl port-forward -n default service/review-service 50003:50003 --address 0.0.0.0
```
