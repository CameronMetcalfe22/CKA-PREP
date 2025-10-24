# Step 1 install and start cri-dockerd
# First we need to use dpkg to install the package
dpkg -i cri-dockerd.deb

# Now we need to enable the service
sudo systemctl enable --now cri-docker.service

# Now we start the service
sudo systemctl start cri-docker.service

# Verify the service is running
sudo systemctl status cri-docker.service
# It should show as active

#Step 2 set the system parameters
# Run the following commands to set the parameters
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.netfilter.nf_conntrack_max=131072
# This isn't persistent however so would be lost on reboot, to make it persistent
vi /etc/sysctl.d/kube.conf
# add the config
net.bridge.bridge-nf-call-iptables=1
net.ipv6.conf.all.forwarding=1
net.ipv4.ip_forward=1
net.netfilter.nf_conntrack_max=131072

# Check the output and ensure it is correct
sudo sysctl --system

# You may need to add/edit files in the /etc/sysctl.d directory, if you create a file and there are still
# overrides check to see if there re additional conf files there. You can give your config a lexically
# later name e.g. zz-cridocker.conf so it is ran last or you can edit those values in the other files.