#!/bin/bash

POD_NETWORK_CIDR="10.244.0.0/16"
SERVICE_CIDR="10.96.0.0/12"

# initialise Kube

kubeadm init --pod-network-cidr=$POD_NETWORK_CIDR --service-cidr=$SERVICE_CIDR --apiserver-cert-extra-sans=webinnovations.ru --apiserver-cert-extra-sans=92.39.139.7

# install Flannel pod network
wget https://raw.githubusercontent.com/sixeyed/k8s-win/master/setup/flannel/kube-flannel-hybrid.yaml

kubectl --kubeconfig='/etc/kubernetes/admin.conf' apply -f kube-flannel-hybrid.yaml
