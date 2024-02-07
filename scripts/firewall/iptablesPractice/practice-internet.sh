#! /bin/bash

43	## Host must be able to access all of its own applications (localhost)
44	## Host must allow SMTP connections from anywhere
45	## Host must allow SSH access only from the campus network
46	## Host must allow access to to the web server only from the local network
47	## Host must allow access to SNMP only from the local network
48	## All incoming TCP/UDP traffic must be blocked, except for established
49	   connections
50	## ICMP must be rate-limited to 3 packets per second

iptables -F
iptables -Z

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s 192.168.100.248/6 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s 192.168.100.248/6 -j ACCEPT
iptables -A INPUT -p udp --dport 161 -s 192.168.100.248/6 -j ACCEPT
iptables -A INPUT -p tcp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -j DROP
iptables -A INPUT -p udp -j DROP
#iptables -A INPUT -p icmp -m limit --limit 3/s -j ACCEPT
iptables -A INPUT -p icmp -m recent --set
iptables -A INPUT -p icmp -m recent --update --seconds 1 --hitcount 2 -j DROP


