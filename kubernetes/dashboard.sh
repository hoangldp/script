# https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
curl https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml > dashboard.yaml

# Find kind Service with name: kubernetes-dashboard
# Add line "type: NodePort" into spec
# Add line "nodePort: 31000" into ports
# Example:

# kind: Service
# apiVersion: v1
# metadata:
#   labels:
#     k8s-app: kubernetes-dashboard
#   name: kubernetes-dashboard
#   namespace: kubernetes-dashboard
# spec:
#   type: NodePort
#   ports:
#     - port: 443
#       targetPort: 8443
#       nodePort: 31000
#   selector:
#     k8s-app: kubernetes-dashboard

# Find kind Secret with name: kubernetes-dashboard-certs
# Then comment all

# apiVersion: v1
# kind: Secret
# metadata:
#   labels:
#     k8s-app: kubernetes-dashboard
#   name: kubernetes-dashboard-certs
#   namespace: kubernetes-dashboard
# type: Opaque

kubectl apply -f dashboard.yaml

# Create kubernetes-dashboard-certs
sudo mkdir certs
sudo chmod 777 -R certs
openssl req -nodes -newkey rsa:2048 -keyout certs/dashboard.key -out certs/dashboard.csr -subj "/C=/ST=/L=/O=/OU=/CN=kubernetes-dashboard"
openssl x509 -req -sha256 -days 365 -in certs/dashboard.csr -signkey certs/dashboard.key -out certs/dashboard.crt
sudo chmod -R 777 certs

# Then
kubectl create secret generic kubernetes-dashboard-certs --from-file=certs -n kubernetes-dashboard
# Go to: https://172.42.42.100:31000

# Get token login dashboard
# https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

cat > dashboard-adminuser.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

kubectl apply -f dashboard-adminuser.yaml

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

