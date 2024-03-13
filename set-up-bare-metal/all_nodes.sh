#!/bin/bash

# RUN: sudo su 

# Off swap memory
swapoff -a; sed -i '/swap/d' /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

apt update

# Install dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl

# Fetch public key
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

# Add k8s packages to sources.lib.d
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update packages
apt update

# Install kubelet, kubeadm, kubectl and kubernets-cni
apt-get install -y kubelet kubeadm kubectl kubernetes-cni

# Installing docker
apt install docker.io -y

# Configuring containerd to ensure compatibility with Kubernetes
sudo mkdir /etc/containerd
sudo sh -c "containerd config default > /etc/containerd/config.toml"
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

# Restart containerd, kubelet, and enable kubelet
systemctl restart containerd.service
systemctl restart kubelet.service
systemctl enable kubelet.service