# === Step 1: Create namespace ===
kubectl create namespace relative

# === Step 2: Create deployment ===
kubectl -n relative create deployment nodeport-deployment --image=nginx --replicas=2