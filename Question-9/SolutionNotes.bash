# Step 1 Inspect file one
cat /root/network-policies/network-policy-1.yaml
# We can see file one allows all ingress traffic which is too permissive

#Step 2 Inspect file 2
cat /root/network-policies/network-policy-2.yaml
# We can see this has the correct namespace selector but it also allows an additional IP which
# Wasn't mentioned in the question so that is too permissive

# Step 3 Inspect file 3
cat /root/network-policies/network-policy-2.yaml
# File three only allows frontend traffic from the frontend namespace and pods labelled front end. We
# need to check the labels on the frontend deployment pods
k get po -n frontend --show-labels
# We can see they have the label app=frontend which means network-policy-3 is the least permissive and allows
# the traffic we want

# Step 4 Apply the file
k apply -f /root/network-policies/network-policy3.yaml