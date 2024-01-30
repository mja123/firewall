#! /bin/bash

set -x

# Save current iptables config
iptables-save > "$HOME"/iptables.backup

./iptables-filter.sh
./iptables-nat.sh