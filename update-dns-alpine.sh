#!/bin/sh

RESOLV_CONF="/etc/resolv.conf"
echo "#!/bin/sh" > /etc/local.d/dns.start
echo "" >> /etc/local.d/dns.start
echo "RESOLV_CONF=\"/etc/resolv.conf\"" >> /etc/local.d/dns.start
echo "> \"\$RESOLV_CONF\"" >> /etc/local.d/dns.start
echo "echo \"nameserver 192.168.4.1\" >> \"\$RESOLV_CONF\"" >> /etc/local.d/dns.start

chmod +x /etc/local.d/dns.start
rc-update add local
