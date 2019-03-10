#!/bin/bash
set -euo pipefail

# Author: Jens Willemsens <jens@jensw.be>
# Purpose: Get HANA XE quickly running on a VPS

# Settings
export NEW_USER=jens
export NETWORK_IF=eth0
export HANA_IMAGE="store/saplabs/hanaexpress:2.00.036.00.20190223.1"
export HANA_PW="<CHANGE ME>"
export HANA_VOLUME="/opt/hana"

# Create new user and disable root
adduser --gecos "" ${NEW_USER}
addgroup ${NEW_USER} sudo
passwd -ld root

# Update system
apt update
apt dist-upgrade -y

# Install firewall
apt install ufw
ufw allow SSH
ufw allow 39013
ufw allow 39017
ufw allow 39041
ufw enable

# Install docker
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt install -y docker-ce docker-ce-cli containerd.io
addgroup ${NEW_USER} docker

# Set sysctl params
echo "fs.file-max=20000000
fs.aio-max-nr=262144
vm.memory_failure_early_kill=1
vm.max_map_count=135217728
net.ipv4.ip_local_port_range=40000 60999" >> /etc/sysctl.conf
sysctl -p

# Add host to hosts file
IP_ADDR=$(ip -f inet addr show ${NETWORK_IF} | grep -Po 'inet \K[\d.]+')
echo -e "${IP_ADDR}\thxehost" >> /etc/hosts

# Make HANA dir and provide credentials
mkdir -p ${HANA_VOLUME}
chown 12000:79 ${HANA_VOLUME}
echo "{\"master_password\" : \"${HANA_PW}\"}" > "/home/${NEW_USER}/creds.json"
chmod 600 "/home/${NEW_USER}/creds.json"
chown 12000:79 "/home/${NEW_USER}/creds.json"
cp -a "/home/${NEW_USER}/creds.json" "${HANA_VOLUME}/"

# Copy createHANA.sh
echo "docker run -d \\
-h hxehost \\
--network host \\
 -v ${HANA_VOLUME}:/hana/mounts \\
--ulimit nofile=1048576:1048576 \\
--sysctl kernel.shmmax=1073741824 \\
--sysctl net.ipv4.ip_local_port_range='40000 60999' \\
--sysctl kernel.shmmni=524288 \\
--sysctl kernel.shmall=8388608 \\
--name hana \\
${HANA_IMAGE} \\
--passwords-url file:///hana/mounts/creds.json \\
--agree-to-sap-license" > "/home/${NEW_USER}/createHANA.sh"
chown ${NEW_USER}:${NEW_USER} "/home/${NEW_USER}/createHANA.sh"
chmod +x "/home/${NEW_USER}/createHANA.sh"

# Copy cleanHANA.sh
echo "sudo docker stop hana
sudo docker rm hana
sudo rm -rf ${HANA_VOLUME}/*
sudo cp -a creds.json ${HANA_VOLUME}/" > "/home/${NEW_USER}/cleanHANA.sh"
chown ${NEW_USER}:${NEW_USER} "/home/${NEW_USER}/cleanHANA.sh"
chmod +x "/home/${NEW_USER}/cleanHANA.sh"

# Install HANA XE
sudo -u ${NEW_USER} docker login

# Start HANA install
sudo -u ${NEW_USER} /home/${NEW_USER}/createHANA.sh
sudo -u ${NEW_USER} docker logs -f hana
