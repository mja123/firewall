#! /bin/bash

# Save current iptables config
iptables-save > "$HOME"/iptables.backup

./iptables-filter.sh
