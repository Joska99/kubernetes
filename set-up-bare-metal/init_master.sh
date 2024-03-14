#!/bin/bah

# Pull kubernetes images
kubeadm config images pull

# Initialize the Kubernetes cluster
kubeadm init

# Create a .kube file
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# To install the network plugin on the Master node
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

# Verify the kubeconfig
kubectl get po -n kube-system

# Verify all the cluster component health statuses
kubectl get --raw='/readyz?verbose'

# RUN:
# export KUBE_JOIN="Join cmd from terminal"
# kubeadm join (cmd from terminal on all nodes)
