# Step one
# Check the deployment and edit it
k get deployments
k edit deployment wordpress
# We need to add the volume for the sidecar and container

volumes:
      - emptyDir: {}
        name: log
# Mount the volume to the existing container
containers:
      - command:
        - /bin/sh
        - -c
        - while true; do echo 'WordPress is running...' >> /var/log/wordpress.log;
          sleep 5; done
        image: wordpress:php8.2-apache
        imagePullPolicy: IfNotPresent
        name: wordpress
        ports:
        - containerPort: 80
          protocol: TCP
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/log
          name: log
# Create the sidecar deployment with the mounted volume
      - command:
        - /bin/sh
        - -c
        - tail -f /var/log/wordpress.log
        image: busybox:stable
        name: sidecar
        volumeMounts:
        - mountPath: /var/log
          name: log
# Write and Quit the edit

# Step 2 Check the deployment has the sidecar include
k describe deployment
# Also check the pod and describe that to see both containers and volume mounts
k describe po wordpress-xxxxx-xxx


