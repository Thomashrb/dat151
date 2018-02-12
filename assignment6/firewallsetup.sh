#!/usr/bin/env bash
#run as sudo
sudo systemctl start firewalld
sudo systemctl enable firewalld

## Policies
# Drop all incoming
iptables -P INPUT DROP
# Drop all forwards
iptables -P FORWARD DROP
# Allow outgoing
iptables -P OUTPUT ACCEPT

# Accept on localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established sessions to receive traffic
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

sudo iptables -A INPUT -p tcp -s YOUR.IP.HERE --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j DROP
