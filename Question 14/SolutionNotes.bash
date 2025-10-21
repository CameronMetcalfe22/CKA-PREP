# On getting on to the node and trying to run kubectl commands we can see that they don't work
# This indicates an issue with the kube api server, we can inspect the logs to see if we can decipher any more information
journalctl | grep kube-apiserver
# We can also go to the following directory for the pod logs
cat /var/log/pods/kube-system_kube-apiserver-controlplane_..../kube-apiserver/x.log
# The pod logs tell us there is an issue connecting to 127.0.0.1:2380
vi /etc/kubernetes/manifests/kube-apiserver.yaml

# Inspect the yaml, we can see there is an issue
--etcd-servers=https://127.0.0.1:2380
# This is the incorrect port of the etcd server it should be
--etcd-servers=https://127.0.0.1:2379
# Update the file and wait for the pods to come up

# There are several issues that could be at play in the exam for this question, the IP could be wrong,
# issues with the location of the certs and keys etc.

# One issue mentioned is that after this the kube-scheduler is down, you may need to inspect the logs for this
k -n kube-system get pods | grep kube-scheduler
k -n kube-system describe pod 'kube-scheduler-pod-name'
k -n kube-system logs 'kube-scheduler-pod-name'
# Usual errors will relate to not being able to connect to the API server or an incorrect config path,
sudo vi /etc/kubernetes/manifests/kube-scheduler.yaml
# Key things to check:
# --kubeconfig points to /etc/kubernetes/scheduler.conf
# No leftover --master flags pointing to old IPs
# Hostname/IP matches current control plane (controlplaneIP:6443)
# Check cert files are correct

