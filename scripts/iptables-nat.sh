#! /bin/bash

# Clean up rules
iptables -t nat -F

# Mascarading traffic
iptables -t nat -A POSTROUTING -p tcp --dport 80 -j MASQUERADE
iptables -t nat -A POSTROUTING -p tcp --dport 443 -j MASQUERADE


