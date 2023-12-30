#!/bin/sh
echo  "Starting script"
apk update
echo "Installing OpenSSH"
apk add openssh
rc-update add sshd
service sshd start
echo "Installing Nano"
apk add nano
echo "Installing Docker"
apk add docker docker-compose
rc-update add docker default
/etc/init.d/docker start
echo "Changing MOTD"
file_url="https://raw.githubusercontent.com/GonzaloLombardi/scripts/main/ssh/motd"
wget "$file_url" -O /tmp/motd
rm /etc/motd
mv /tmp/motd /etc/
