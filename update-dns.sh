#!/bin/bash
echo  "Starting script"
if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi
dns="DNS=192.168.4.1"
sed -i '$s/.$//' "/etc/systemd/resolved.conf"
echo "$dns" >> "/etc/systemd/resolved.conf"
resolvectl flush-caches
service systemd-resolved restart
