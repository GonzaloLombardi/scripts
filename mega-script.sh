#!/bin/bash
echo  "Starting script"
if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi
echo "Set up the repository"
apt-get update
apt-get install ca-certificates curl gnupg
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "Install Docker Engine"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "Linux post-installation steps for Docker Engine"
usermod -aG docker $SUDO_USER
apt install qemu-guest-agent -y
file_url="https://raw.githubusercontent.com/GonzaloLombardi/scripts/main/ssh/motd"
wget "$file_url" -O /tmp/motd
mv /tmp/motd /etc/
rm -rf /etc/update-motd.d/*
apt-get install nano
nameservers="            nameservers:
              addresses: [1.1.1.1, 1.0.0.1]
"
sed -i '$s/.$//' "/etc/netplan/50-cloud-init.yaml"
echo "$nameservers" >> "/etc/netplan/50-cloud-init.yaml"
content="network: {config: disabled}"
path="/etc/cloud/cloud.cfg.d/99-custom-networking.cfg"
echo "$content" > "$path"
netplan apply
resolvectl status
rm "$0"
reboot
