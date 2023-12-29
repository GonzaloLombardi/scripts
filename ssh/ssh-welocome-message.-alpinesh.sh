#!/bin/sh
if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi
file_url="https://raw.githubusercontent.com/GonzaloLombardi/scripts/main/ssh/motd"
wget "$file_url" -O /tmp/motd
rm /etc/motd
mv /tmp/motd /etc/
