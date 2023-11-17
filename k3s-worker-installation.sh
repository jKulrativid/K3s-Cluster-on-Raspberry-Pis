# Installation Script for K3s Worker Node
# OS : Raspberry Pi OS

# Update existing packages
sudo apt update
sudo apt upgrade -y

# Install vim for debugging purpose
sudo apt install vim curl net-tools

cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo swapoff -a

sudo -i <<EOF
echo " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" >> /boot/cmdline.txt
EOF

curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.112:6443 K3S_TOKEN=K10194a68c519a4045c1160a190fcd9c9b54cd5a61516c786b6bfc8bf5831e7abe2::server:1aeee21ffbf7dfb3475c95c9d7cbea09 sh -
