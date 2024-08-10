#! /usr/bin/env bash
set -euf -o pipefail

echo "# table: nat"
for chain in PREROUTING INPUT OUTPUT POSTROUTING; do
   echo "# chain: $chain"
   # scan for rules pointing to tables with "CILIUM" or "KUBE" in the name
   dct=0
   iptables -t nat -L "$chain" -n --line-numbers | awk '
   	BEGIN { dct=0 }
	/CILIUM|KUBE/ {
		dl=$1-dct
		print "removing: " $0
		cmd="iptables -t nat -D '"$chain"' " dl
		print "running: " cmd
		system(cmd)
		dct++
	}
	'
done

# Delete chains with CILIUM or KUBE in their name
iptables -t nat -L -n | awk '
	/Chain (CILIUM|KUBE)/ {
		cmd1="iptables -t nat -F " $2
		cmd2="iptables -t nat -X " $2
		print "running: " cmd1
		system(cmd1)
		print "running: " cmd2
		system(cmd2)
	}
	'

echo "# table: filter"
for chain in INPUT FORWARD OUTPUT; do
   echo "# chain: $chain"
   # scan for rules pointing to tables with "CILIUM" or "KUBE" in the name
   iptables -L "$chain" -n --line-numbers | awk '
   	BEGIN { dct=0 }
	/CILIUM|KUBE/ {
		dl=$1-dct
		print "removing: " $0
		cmd="iptables -D '"$chain"' " dl
		print "running: " cmd
		system(cmd)
		dct++
	}
	'
done

# Delete chains with CILIUM or KUBE in their name
iptables -L -n | awk '
	/Chain (CILIUM|KUBE)/ {
		cmd1="iptables -F " $2
		cmd2="iptables -X " $2
		print "running: " cmd1
		system(cmd1)
		print "running: " cmd2
		system(cmd2)
	}
	'
