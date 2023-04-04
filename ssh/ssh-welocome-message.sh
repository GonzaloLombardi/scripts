#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi
file_url="https://raw.githubusercontent.com/GonzaloLombardi/scripts/main/ssh/motd"
wget "$file_url" -O /tmp/motd
mv /tmp/motd /etc/
rm -rf /etc/update-motd.d/*
reboot
