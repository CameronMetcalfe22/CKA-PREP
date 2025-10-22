# Step 1
# The key defining factor in the criteria is network policies, Flannel doesn't support network policies,
# Calico does. We can confirm this by running the following
curl -sL https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml | grep network
# We see nothing relating to networks in the flannel yaml, now lets try Calico
curl -sL https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
# We see several references to networks and network policies, therefore we know Calico is the choice

# Step 2
# We need to apply the Calico file
k create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml

# Step 3 check everything has been deployed
k get all -n tigera-operator
# We should see pods, deployments and replicasets