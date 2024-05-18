#! /usr/bin/env bash
set -euf -o pipefail
set -x

echo "# table: nat"
for chain in PREROUTING INPUT OUTPUT POSTROUTING; do
   echo "# chain: $chain"
   # scan for rules pointing to tables with "CILIUM" or "KUBE" in the name
   dct=0
   iptables -t nat -L "$chain" -n --line-numbers | grep -E 'CILIUM|KUBE' | awk '{print $1}' | while read -r line; do
      # delete the rule
      dl=$((line - dct))
      echo iptables -t nat -D "$chain" $dl
      dct=$((dct + 1))
   done
done

echo "# table: filter"
for chain in INPUT FORWARD OUTPUT; do
   echo "# chain: $chain"
   # scan for rules pointing to tables with "CILIUM" or "KUBE" in the name
   dct=0
   iptables -L "$chain" -n --line-numbers | grep -E 'CILIUM|KUBE' | awk '{print $1}' | while read -r line; do
      # delete the rule
      dl=$((line - dct))
      echo iptables -D "$chain" $dl
      dct=$((dct + 1))
   done
done

# Flush all chains with CILIUM or KUBE in their name
echo iptables -t nat -F $(iptables -t nat -L -n | grep -E 'CILIUM|KUBE' | awk '{print $2}')
echo iptables -F $(iptables -L -n | grep -E 'CILIUM|KUBE' | awk '{print $2}')
echo iptables -t nat -X $(iptables -t nat -L -n | grep -E 'CILIUM|KUBE' | awk '{print $2}')
echo iptables -X $(iptables -L -n | grep -E 'CILIUM|KUBE' | awk '{print $2}')
