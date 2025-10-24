# Step1 Find the user defined priority classes
k get pc
# User defined PCs are appended with "user", we can see the highest is 1000 so we need to create
# a PC with value 999
k create priorityclass high-priority --value=999 --description="high priority"
# Check to see PC was created
k get pc

# Step 2 Patch the deployment, we need to use the patch command for this for the exam, first we need to figure
# out where we want the priority class name to go.
k get deployments.apps -n priority busybox-logger -oyaml
# We need to add priorityClassName in the following section
...
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: busybox-logger
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: busybox-logger
    spec:
      # We want to add priorityClassName here
      containers:
      - command:
        - sh
        - -c
        - while true; do echo 'logging...'; sleep 5; done
        image: busybox
        imagePullPolicy: Always
        name: busybox
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      priorityClassName: high-priority
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
# From this we can see this is under spec:template:spec so our command will look like this
k patch deployment -n priority busybox-logger -p '{"spec":{"template":{"spec":{"priorityClassName":"high-priority"}}}}'

# Step 3 Check patch has applied successfully
k describe deployment -n priority busybox-logger
# We should see the following
  Priority Class Name:  high-priority