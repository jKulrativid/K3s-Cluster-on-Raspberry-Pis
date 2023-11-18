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

sudo -i
cat << EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
exit

sudo sysctl --system

sudo swapoff -a

sudo -i <<EOF
echo " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" >> /boot/cmdline.txt
EOF

curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.112:6443 K3S_TOKEN=K104597e0ff0524ee24995350b30f1d4210a5613d270753fe19083bb4b2798ce3de::server:bc1c1373d088eebc76d3d4bdd605002e sh -
