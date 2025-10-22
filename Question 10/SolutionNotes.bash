# Step 1 Verify the deployment
k get deployments.apps -n autoscale
# You should see the apache-deployment, check the pod(s) exist
k get po -n autoscale
# You should see apache-deployment-xxxxx-xxx

# Step 2 Create the HPA
# Use the Kubernetes docs (https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/)
# Edit the template to suit your requirements
vi hpa.yaml
# yaml file
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: apache-server
  namespace: autoscale
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: apache-deployment
  minReplicas: 1
  maxReplicas: 4
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  behavior:                               # This config can be found at
    scaleDown:                            # https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
      stabilizationWindowSeconds: 30
# Apply the file
k apply -f hpa.yaml

# Step 3 Check the HPA is working
k get hpa -n autoscale
# We should see the reference is Deployment/apache-deployment
# After a small amount of time we should see the CPU targets with values e.g. CPU: 1%/50%