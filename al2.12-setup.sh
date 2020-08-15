#!/bin/bash

DOCKER_VERSION="5:19.03.0~3-0~ubuntu-bionic"
KUBERNETES_VERSION="1.15.1-00"

#
# turn off swap - for the Kubelet
swapoff -a 
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

#
# add debain repository
apt install debian-archive-keyring dirmngr
add-apt-repository  "deb https://mirror.yandex.ru/debian/ stretch main contrib non-free" 

#
# install Docker 18.09 (https://docs.docker.com/install/linux/docker-ce/ubuntu/)
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable"

apt-get update
apt-get remove -y docker docker-engine docker.io containerd runc
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    docker-ce \
    docker-ce-cli \
    containerd.io

#
# install Kubeadm etc.
# Note - Bionic packages not available yet
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y \
    kubelet=$KUBERNETES_VERSION \
    kubeadm=$KUBERNETES_VERSION \
    kubectl=$KUBERNETES_VERSION

# set iptables for Flannel
sysctl net.bridge.bridge-nf-call-iptables=1
