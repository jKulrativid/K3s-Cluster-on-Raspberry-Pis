# Installation Script for K3s Worker Node
# OS : Raspberry Pi OS

# Update existing packages
sudo apt update
sudo apt upgrade -y

# Install vim for debugging purpose
sudo apt install vim

cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
    
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo swapoff -a

cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory

sudo mkdir -p /etc/rancher/k3s

sudo -i
echo "apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
shutdownGracePeriod: 30s
shutdownGracePeriodCriticalPods: 10s" > /etc/rancher/k3s/kubelet.config
exit
