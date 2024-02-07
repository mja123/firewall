#! /bin/bash


iptables -F

iptables -P OUTPUT DROP
iptables -P INPUT DROP

iptables -A OUTPUT -d 8.8.8.8 -s 192.168.100.248/6 -p udp --dport 53 -j ACCEPT
iptables -A INPUT  -s 8.8.8.8 -d 192.168.100.248/6 -p udp --sport 53 -j ACCEPT
