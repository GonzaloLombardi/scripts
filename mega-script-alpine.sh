#!/bin/sh
echo  "Starting script"
apk update
apk add openssh
rc-update add sshd
service sshd start
apk add nano
apk add docker docker-compose
rc-update add docker default
/etc/init.d/docker start
file_url="https://raw.githubusercontent.com/GonzaloLombardi/scripts/main/ssh/motd"
wget "$file_url" -O /tmp/motd
rm /etc/motd
mv /tmp/motd /etc/
