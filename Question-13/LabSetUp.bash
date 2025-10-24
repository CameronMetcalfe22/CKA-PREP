#!/bin/bash
set -e

# Download CRI Dockerd Debian package
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.20/cri-dockerd_0.3.20.3-0.debian-bullseye_amd64.deb -O /tmp/cri-dockerd.deb

echo "CRI Dockerd package downloaded to /tmp/cri-dockerd.deb"

