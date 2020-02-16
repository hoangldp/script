# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl

# Ubuntu
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# https://www.cyberciti.biz/faq/ubuntu-change-hostname-command/

# Init cluster
sudo kubeadm init --apiserver-advertise-address=192.168.33.10 --pod-network-cidr=192.168.0.0/16

# Configure NetworkManager before attempting to use Calico networking.
cat >>/etc/NetworkManager/conf.d/calico.conf<<EOF
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*
EOF

# https://medium.com/@kanrangsan/how-to-specify-internal-ip-for-kubernetes-worker-node-24790b2884fd

# https://xuanthulab.net/gioi-thieu-va-cai-dat-kubernetes-cluster.html
# https://kubernetes.io/docs/concepts/cluster-administration/addons/
# Installing Calico for policy and networking
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml

# scp root@172.42.42.100:/etc/kubernetes/admin.conf ~/.kube/config-centos
# kubeadm reset
export KUBECONFIG=~/.kube/config:~/.kube/config-mycluster
kubectl config view --flatten > ~/.kube/config_temp
mv ~/.kube/config_temp ~/.kube/config

kubeadm token create --print-join-command

kubectl config get-contexts
kubectl config use-context kubernetes-admin@kubernetes