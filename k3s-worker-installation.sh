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
cat << EOF | sudo tee /etc/sysctl.conf
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
sudo reboot

sudo iptables -F
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo reboot

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.35" K3S_URL=https://192.168.56.112:6443 K3S_TOKEN=K1032daaee4d4a7b13713c39a5a5033962e081c97f4e48e5f4350aca6a4a12697e5::server:bfcd72733bd5474ef5db42864144eaef sh -
