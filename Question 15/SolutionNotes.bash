# Step One
# First thing we need to do is add the taint to node01. You can use
k taint --help

# Which gives you a format to use

# Update node 'foo' with a taint with key 'dedicated' and value 'special-user' and effect 'NoSchedule'
# If a taint with that key and effect already exists, its value is replaced as specified
kubectl taint nodes foo dedicated=special-user:NoSchedule

#For the question we have
k taint nodes node01 PERMISSION=granted:NoSchedule

#Step Two
# We need to create a pod with the appropriate tolerations to be scheduled on node01
vi pod.yaml
#Working yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  tolerations:
  - key: "PERMISSION"
    operator: "Equal"
    value: "granted"
    effect: "NoSchedule"
#apply
k apply -f pod.yaml
#check
k get po
# We should see the pod has created as expected

# Step 3
# To test the taint is working as expected create a pod you know doesn't have the tolerations needed
vi podfailure.yaml
# yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-fail
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  tolerations:
  - key: "example-key"
    operator: "Exists"
    effect: "NoSchedule"
#apply
k apply -f podfailure.yaml
#check
k get po
# We should see this pod in a pending state
k describe po nginx-fail
# We should see the following
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  13s   default-scheduler  0/2 nodes are available: 1 node(s) had untolerated taint {PERMISSION: granted}, 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }. preemption: 0/2 nodes are available: 2 Preemption is not helpful for scheduling.
# delete the test pod
k delete po nginx-fail