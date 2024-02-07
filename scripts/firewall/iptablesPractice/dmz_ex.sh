#! /bin/bash

iptables -F
iptables -F -t nat

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Lan access to http and dns
iptables -A FORWARD -i eth0 -o eth2 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -p tcp --sport 80 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p udp --dport 53 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -p udp --sport 53 -j ACCEPT
# Lan access to local web server 443
iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -o eth1 -i eth0 -p tcp --sport 443 -j ACCEPT
# Lan access to local SMTP server 25
iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport 25 -j ACCEPT
iptables -A FORWARD -o eth1 -i eth0 -p tcp --sport 25 -j ACCEPT
# Internet access to web sercer 443
iptables -A FORWARD -i eth2 -o eth1 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -o eth1 -i eth2 -p tcp --sport 443 -j ACCEPT
# Lan access via ssh to firewall
iptables -A INPUT -i eth1 -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -o eth1 -p tcp --sport 22 -j ACCEPT

iptables -t nat -A POSTROUTING -o eth2 -p tcp --dport 80 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth2 -p udp --dport 53 -j MASQUERADE

iptables -t nat -A PREROUTING -i eth2 -p tcp --dport 443 -j DNAT --to-destination 198.68.0.1
iptables -t nat -A PREROUTING -i eth2 -p tcp --dport 53 -j DNAT --to-destination 198.68.0.2



