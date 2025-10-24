# Step 1 - check the pv exists
k get pv
k describe pv mariadb-pv

# Step 2 - Clear existing claim
# We can see that the PV has a RELEASED status as it has a claim from the previous PVC, we need to
# edit the PV to remove the claim reference. We can also see the PV has an empty storage class which
# we need to keep in mind for creating our PVC
k edit pv mariadb-pv
# We need to remove this section
  claimRef:
    apiVersion: v1
    kind: PersistentVolumeClaim
    name: mariadb
    namespace: mariadb
    resourceVersion: "11228"
    uid: ffa27d96-5199-4785-8ad9-562e8f5d5f53
# Check the PV is now available
k get pv mariadb-pv
# PV should now have status AVAILABLE

# Step 3 Create the PVC (Remember the storage class for the PV is empty)
vi pvc.yaml
# Use the docs
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: mariadb
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
  storageClassName: "" # This will allow it to bind to the existing PV with ono SC
# Apply it
k apply pvc.yaml
# Check it has bound
k get pvc -n mariadb mariadb
# Status should show bound
# Double check it has bound to the PV
k get pv mariadb-pv
# This should show as bound with mariadb claim name

# Step 4 Check the deployment
vi mariadb-deploy.yaml
# Ensure the deployment looks as expected and specifically it uses your PVC
volumes:
        - name: mariadb-storage
          persistentVolumeClaim:
            claimName: mariadb
# Apply it
k apply -f mariadb-deploy.yaml

# Step 5 final checks
k get po -n mariadb
# Pod should be running, we want to check it is using the PVC
k describe po -n mariadb mariadb-xxxxx-xxxxx
# We should see this
Volumes:
  mariadb-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  mariadb