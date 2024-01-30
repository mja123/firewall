#! /bin/bash

set -x

SERVER_IP=$(host server | grep -Eo "[0-9\.]+")
FIREWALL_IP=$(host firewall-router | grep -Eo "[0-9\.]+")
CLIENT_IP=$(host client | grep -Eo "[0-9\.]+")

# Clean up rules
iptables -t nat -F

# Masquerading traffic
iptables -t nat -A PREROUTING -p tcp --dport 80 -d "$FIREWALL_IP" -s "$CLIENT_IP" -j DNAT --to "$SERVER_IP"
iptables -t nat -A POSTROUTING -p tcp --dport 80 -j MASQUERADE
iptables -t nat -A POSTROUTING -p tcp --dport 443 -j MASQUERADE


