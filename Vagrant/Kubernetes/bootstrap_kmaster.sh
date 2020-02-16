#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Configure NetworkManager before attempting to use Calico networking.
cat >>/etc/NetworkManager/conf.d/calico.conf<<EOF
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*
EOF

# Deploy Calico network
echo "[TASK 3] Deploy Calico network"
su - vagrant -c "kubectl create -f https://docs.projectcalico.org/manifests/calico.yaml"
# su - vagrant -c "kubectl create -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml"

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh

# Create a systemd drop-in directory for the docker service
mkdir -p /etc/systemd/system/docker.service.d

cat >>/etc/systemd/system/docker.service.d/http-proxy.conf<<EOF
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80/"
EOF

systemctl daemon-reload
systemctl restart docker