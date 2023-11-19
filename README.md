# Installation Guide

## K3s Master Installation
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
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.113" K3S_URL=https://192.168.56.112:6443 K3S_ARGS="--kube-apiserver-arg=default-not-ready-toleration-seconds=5 --kube-apiserver-arg=default-unreachable-toleration-seconds=5 --kube-apiserver-arg=default-uncordon-toleration-seconds=5 --kube-apiserver-arg=default-delete-local-data-delay=5 --kube-apiserver-arg=default-pod-eviction-timeout=5s --kube-apiserver-arg=default-pod-eviction-headroom=5s" K3S_TOKEN=K10b3c71e9d827d701deeb40eea7e2426d72687bd7aa052cddf011d146715600f8e::server:3f0e3e6d5b7e5503075cbb121ee6d886 sh -s - server --server https://192.168.56.112:6443
```

#### Taint the node so that no pod will be schedule here
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
#### config network in /etc/dhcpcd.conf
```
interface eth0
```

## Finally Run (tmux recommended)
```bash
kubectl port-forward -n default service/web-service 3000:3000 --address 0.0.0.0
kubectl port-forward -n default service/gateway-service 8080:8080 --address 0.0.0.0
kubectl port-forward -n default service/chef-service 50001:50001 --address 0.0.0.0
kubectl port-forward -n default service/recipe-service 50002:50002 --address 0.0.0.0
kubectl port-forward -n default service/review-service 50003:50003 --address 0.0.0.0
```
