#! /bin/sh

name=REDSOCKS
tcp_port=12345
udp_port=12345

# Create new chain
iptables -t nat -N "$name"

# Ignore LANs and some other reserved addresses.
# See Wikipedia and RFC5735 for full list of reserved networks.
iptables -t nat -A "$name" -d 0.0.0.0/8 -j RETURN
iptables -t nat -A "$name" -d 10.0.0.0/8 -j RETURN
iptables -t nat -A "$name" -d 127.0.0.0/8 -j RETURN
iptables -t nat -A "$name" -d 169.254.0.0/16 -j RETURN
iptables -t nat -A "$name" -d 172.16.0.0/12 -j RETURN
iptables -t nat -A "$name" -d 192.168.0.0/16 -j RETURN
iptables -t nat -A "$name" -d 224.0.0.0/4 -j RETURN
iptables -t nat -A "$name" -d 240.0.0.0/4 -j RETURN

iptables -t nat -A "$name" -p tcp -j REDIRECT --to-ports "$tcp_port"
iptables -t nat -A "$name" -p udp -j REDIRECT --to-ports "$udp_port"

