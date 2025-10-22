#!/bin/bash
set -e

echo "🚀 Setting up Kubernetes Gateway API migration lab..."

# 1. Install Gateway API CRDs (official source)
echo "📦 Installing Gateway API CRDs..."
kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.1.0" >/dev/null

# 2. Create the working namespace
kubectl create ns web-app --dry-run=client -o yaml | kubectl apply -f -

# 3. Deploy a simple nginx web app
cat <<EOF | kubectl apply -n web-app -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: nginx
        ports:
        - containerPort: 80
EOF

# 4. Create a service for the web app
cat <<EOF | kubectl apply -n web-app -f -
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
  - name: http
    port: 80
    targetPort: 80
EOF

# 5. Create a self-signed TLS certificate and secret
echo "🔐 Creating TLS certificate..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=gateway.web.k8s.local/O=web" >/dev/null 2>&1

kubectl create secret tls web-tls --cert=tls.crt --key=tls.key -n web-app >/dev/null
rm -f tls.crt tls.key

# 6. Create an existing Ingress resource (to migrate from)
cat <<EOF | kubectl apply -n web-app -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
  - hosts:
    - gateway.web.k8s.local
    secretName: web-tls
  rules:
  - host: gateway.web.k8s.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
EOF

# 7. Create a working GatewayClass (using a mock nginx controller)
cat <<EOF | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx-class
spec:
  controllerName: example.net/nginx-gateway-controller
EOF

echo
echo "✅ Gateway API lab setup complete!"
echo
echo "Resources created:"
echo "  - Namespace: web-app"
echo "  - Deployment: web-deployment"
echo "  - Service: web-service"
echo "  - Ingress: web"
echo "  - GatewayClass: nginx-class"
echo
echo "🎯 Next steps:"
echo "  1️⃣  Create a Gateway named web-gateway using hostname gateway.web.k8s.local and nginx-class."
echo "  2️⃣  Create a HTTPRoute named web-route referencing web-service."
echo "  3️⃣  Use 'kubectl get gatewayclass,gateway,httproute -A' to verify."
