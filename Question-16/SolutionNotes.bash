# Step One
# We need to edit the deployment to expose it on port 80, name it http using TCP protocol
k edit deployment -n relative nodeport-deployment

spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: nginx
        #This is the section we need to add
        ports:
        - name: http
          containerPort: 80
          protocol: TCP

# Verify the changes
k describe deployment -n relative nodeport-deployment | grep -i port
# We should see the following
Name:                   nodeport-deployment
Labels:                 app=nodeport-deployment
Selector:               app=nodeport-deployment
  Labels:  app=nodeport-deployment
    Port:          80/TCP     # THIS IS WHAT WE ARE INTERESTED IN
    Host Port:     0/TCP
OldReplicaSets:  nodeport-deployment-6fc449468d (0/0 replicas created)
NewReplicaSet:   nodeport-deployment-56b95f5667 (2/2 replicas created)
  Normal  ScalingReplicaSet  9m23s  deployment-controller  Scaled up replica set nodeport-deployment-6fc449468d from 0 to 2
  Normal  ScalingReplicaSet  2m37s  deployment-controller  Scaled up replica set nodeport-deployment-56b95f5667 from 0 to 1
  Normal  ScalingReplicaSet  2m36s  deployment-controller  Scaled down replica set nodeport-deployment-6fc449468d from 2 to 1
  Normal  ScalingReplicaSet  2m36s  deployment-controller  Scaled up replica set nodeport-deployment-56b95f5667 from 1 to 2
  Normal  ScalingReplicaSet  2m34s  deployment-controller  Scaled down replica set nodeport-deployment-6fc449468d from 1 to 0

# Step 2
# We need to create the service as per the given requirements, we know a service will require a selector so run
k get deployments -n relative nodeport-deployment --show-labels

NAME                  READY   UP-TO-DATE   AVAILABLE   AGE   LABELS
nodeport-deployment   2/2     2            2           14m   app=nodeport-deployment

# We want to note the label for later use. Now we need to create a yaml file for our service
vi svc.yaml

# Use the kubernetes docs to get the yaml for creating a NodePort service
apiVersion: v1
kind: Service
metadata:
  name: nodeport-service
  namespace: relative
spec:
  type: NodePort
  selector:
    app: nodeport-deployment
  ports:
    - port: 80
      protocol: TCP
      targetPort: 80
      nodePort: 30080
# Apply the yaml file and check the service is running
k apply -f svc.yaml
k describe svc -n relative nodeport-service

# We need to verify the service is running as expected, we know the nodeport is 30080. We need to get the IP of
# the node the deployment is running on and check it using a curl command
k get nodes -owide # Get the node IP x.x.x.x

curl http://x.x.x.x:30080

#Output we should see
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

# As we have used the selector label from the deployment which exists
# on both pods we have exposed the individual pods