# Creating mariadb namespace
kubectl create ns mariadb

# Creating PersistentVolume
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mariadb-pv
  labels:
    app: mariadb
spec:
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""  # Empty storage class
  hostPath:
    path: /mnt/data/mariadb
EOF

# Creating initial PVC in mariadb namespace
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: mariadb
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
  storageClassName: ""  # Empty storage class
EOF

# Creating initial MariaDB Deployment
cat <<EOF > ~/mariadb-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
        - name: mariadb
          image: mariadb:10.6
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: rootpass
          volumeMounts:
            - name: mariadb-storage
              mountPath: /var/lib/mysql
      volumes:
        - name: mariadb-storage
          persistentVolumeClaim:
            claimName: mariadb
EOF

kubectl apply -f ~/mariadb-deploy.yaml


# Simulating accidental deletion of deployment and PVC...
kubectl delete deployment mariadb -n mariadb
kubectl delete pvc mariadb -n mariadb