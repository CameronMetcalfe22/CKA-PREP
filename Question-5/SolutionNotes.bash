# Step 1 Create the storage class
vi sc.yaml
# Use the docs to create the yaml as per your spec
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
  annotations:
    storageclass.kubernetes.io/is-default-class: "false"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
# apply
k apply -f sc.yaml
# Check
k get sc
# You should see your SC there and it isn't the default class

# Step 2 patch your SC
# Check where we need to patch by using
k get sc local-storage -oyaml
# Find the default setting
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
  ....
    storageclass.kubernetes.io/is-default-class: "false" # This is what we want to change to true
# We can see this is under metadata.annotations.storageclass.kubernetes.io/is-default-class we can
# now build our patch command
k patch storageclasses.storage.k8s.io local-storage -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
# Check
k get sc
# We should see our sc is now labelled as default

# Step 3 remove other default
# We can also see the local-path SC is labelled as default, we don't want two defaults so we need to remove this
# Use the command we built above to remove this editing it for the local-path SC and setting default to false
k patch storageclasses.storage.k8s.io local-path -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
# Check
k get sc
# We should now only see local-storage as the default