#!/bin/bash

# Clean standard filter rules
iptables -F INPUT 
iptables -F OUTPUT
iptables -F FORWARD

# Restart packet counter in standard filter rules
iptables -Z INPUT
iptables -Z OUTPUT
iptables -Z FORWARD

# Dropping by default all packets in standard filter rules
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allowing packages for already stablished connections
# This makes filter table stateful, so we don't need to manage responses rules
iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED -j ACCEPT

# Allowing packets flow in loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allowing ssh connections
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allowing DNS connections
iptables -A FORWARD -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT # TEST

# Allowing HTTP and HTTPS
iptables -A FORWARD -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT # TEST

