# Step 1 Expose the deployment with the given features
k get deployments -n echo-sound

k expose deployment -n echo-sound echo --name echo-service --type NodePort --port 8080 --target-port 8080

# Check the service has been created
k get svc -n echo-sound

# Step 2 Create the ingress
# Use the docs for a template
vi ingress.yaml
# yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  namespace: echo-sound
spec:
  rules:
  - host: "example.org"
    http:
      paths:
      - pathType: Prefix
        path: "/echo"
        backend:
          service:
            name: echo-service
            port:
              number: 8080
# Apply
k apply -f ingress.yaml
# Check
k get ingress -n echo-sound

# Step 3 Check curl command
k get nodes -owide
# Get the IP of the node you have deployed on
k get svc -n echo-sound
# Get the NodePort of the service
curl NODEIP:NODEPORT/echo
# Output
Hostname: echo-84897cb55d-lk675

Pod Information:
        -no pod information available-

Server values:
        server_version=nginx: 1.13.3 - lua: 10008

Request Information:
        client_address=172.30.2.2
        method=GET
        real path=/echo
        query=
        request_version=1.1
        request_scheme=http
        request_uri=http://172.30.2.2:8080/echo

Request Headers:
        accept=*/*
        host=172.30.2.2:31999
        user-agent=curl/8.5.0

Request Body:
        -no body in request-