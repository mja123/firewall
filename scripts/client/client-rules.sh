#! /bin/bash

set -x

FIREWALL_IP=$(host firewall-router | grep -Eo "[0-9\.]+")

iptables -t nat -A OUTPUT -j DNAT --to "$FIREWALL_IP"
