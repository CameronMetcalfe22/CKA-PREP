# Question Ingress

# Task
# 1. Create a new ingress resource named echo in the echo-sound namespace
# 2. Expose the existing deployment with a service called echo-service on http://example.org/echo
# using Service Port 8080 type=NodePort
# 3. The availability of the Service echo-service can be checked using the following command
curl NODEIP:NODEPORT/echo

# In the exam it may give you a command like curl -o /dev/null -s -w "%{http_code}\n" http://example.org/echo
# This requires an ingress controller, to get this to work ensure your /etc/hosts file has an entry for your NodeIP
# pointing to example.org