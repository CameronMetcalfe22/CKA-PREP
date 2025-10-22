# Step 1
# Check the deployment and scale it down to 0
k get deployments
# Scale it down
k scale deployment wordpress --replicas 0
# Check it has scaled
k get deployments
# Should see 0 replicas

# Step 2
# Find the allocatable CPU and memory on the node and decide how to split it between the 3 pods
k describe node node01
# Look at the memory and CPU that is allocatable (I will be using example numbers here, yours will be different)
cpu: 1
memory: 1846652Ki
# Firstly we want memory in Mi so divide the Ki by 1024
expr 1846652 / 1024
1803
# Next we want to look at memory already in use
k describe node node01
# Look in the Memory Requests Column
  kube-system                 canal-tqknq                   25m (2%)      0 (0%)      0 (0%)           0 (0%)         2d23h
  kube-system                 coredns-6ff97d97f9-h59nk      50m (5%)      0 (0%)      50Mi (2%)        170Mi (9%)     2d23h
  kube-system                 coredns-6ff97d97f9-rpmqd      50m (5%)      0 (0%)      50Mi (2%)        170Mi (9%)     2d23h
# We have 100Mi already requested so we need to take this out of our calculation
1803 - 100
1703
# We now need to leave ~ 10% Head room
1703 - 170
1533
# We now need to share this between 3 pods
1533 / 3
511Mi
# Looking at this a 500Mi request looks reasonable with a 600Mi limit

# We now need to do the same for CPU
1 CPU = 1000m
# Check CPU usage from the table we see it is 125m
1000 - 125
875
# Get ~10% headroom
875 - 87
788
# Share this between 3 pods
788 / 3
~ 262
# Looking at this a 250m request with a 300m limit looks reasonable

# Step 3
# Edit the deployment with the new requests and limits
k edit deployment wordpress
# ensure you add the limits to containers AND init containers
        resources:
          limits:
            cpu: 300m
            memory: 600Mi
          requests:
            cpu: 250m
            memory: 500Mi

# Step 4 Scale Up
# Scale the deployment back to 3 replicas
k scale deployment wordpress --replicas 3
# Describe the deployment and ensure you see the requests/limits there
k describe deployment wordpress
# Once the pods are up and running describe one of the pods and make sure you see the requests/limits there
k describe pod wordpress-xxx-xxx-xxx