#! /bin/bash

# Save current iptables config
sudo iptables-save > "$HOME"/iptables.backup

# Clean standard filter rules
sudo iptables -F INPUT 
sudo iptables -F OUTPUT
sudo iptables -F FORWARD

# Restart packet counter in standard filter rules
sudo iptables -Z INPUT
sudo iptables -Z OUTPUT
sudo iptables -Z FORWARD

# Dropping by default all packets in standard filter rules
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

# Allowing packets flow in loopback
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Allowing ssh connections
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

