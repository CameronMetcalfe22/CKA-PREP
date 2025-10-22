# Step 1 list the cert-manager CRDs
k get crd | grep cert-manager
# Check the list you get and then output it to the file location
k get crd | grep cert-manager > /root/resources.yaml
# Check the file matches your first list
cat /root/resources.yaml

# Step 2 extract the doc for subject spec, for this we want to use explain
k explain certificate.spec.subject
# We should see the doc output for the subject spec of certificates, we now want output it to the file
k explain certificate.spec.subject > /root/subject.yaml
# Check the file matches the explain command output
cat /root/subject.yaml
