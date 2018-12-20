#!/bin/bash
# Modify the SSH welcome message
rm -f /etc/motd
cat >> /etc/motd << EOF

Welcome to the CentOS Docker-Linux !

Author : Thomas Senay <tomgva@me.com>

Linux Version : $(cat /etc/redhat-release)
Kernel Version : $(uname -r)
Hostname : $(uname -n)

Enjoy your Docker-Linux Node !

EOF
echo "Start Success !"
/usr/sbin/sshd -D
