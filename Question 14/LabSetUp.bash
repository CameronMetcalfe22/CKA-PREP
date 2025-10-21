#=== Step 1: Backing up current kube-apiserver manifest ===
sudo cp /etc/kubernetes/manifests/kube-apiserver.yaml /root/kube-apiserver.yaml.bak

#=== Step 2: Simulating migration issue — changing etcd client port to peer port 2380 ===
sudo sed -i 's/:2379/:2380/g' /etc/kubernetes/manifests/kube-apiserver.yaml

#=== Step 3: Showing kube-apiserver pod logs (expected: connection refused to etcd) ===
sudo crictl ps -a | grep kube-apiserver || echo "kube-apiserver pod not found yet"
KAPISERVER_ID=$(sudo crictl ps -a | grep kube-apiserver | awk '{print $1}' | head -n 1)
if [ -n "$KAPISERVER_ID" ]; then
  sudo crictl logs "$KAPISERVER_ID" | tail -n 10 || true
fi

# === Step 4: Verifying kubectl fails (API server down) ==="
kubectl get nodes || echo "As expected, API server is down."