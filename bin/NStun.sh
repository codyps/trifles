#!/bin/sh
#############################################################################
## Small script to automate the task of correctly setting up a DNS tunnel
## client.  This must be run as root.  This script is public domain.
## This file should have chmod 500 and chown root
## http://www.doeshosting.com/code/NStun.sh is always most up to date.
## Wassup to the IRCpimps
## Please someone get tuntap working on the iphone!
## UPDATE! Thank you Friedrich Schoeller for your creative solution 
## for iphone-tun with tunemu
## Thank you to Bjorn Andersson and Erik Ekman for making iodine
##
## Bugs: -If you have 2 default routes it shouldnt know which to pick, but I
##        have a hard time picturing someone using a NS tunnel when using 2
##        default routes. 
##
## -krzee           email:  username=krzee  domain=ircpimps.org
#############################################################################


#### EDIT HERE ####

# Path to your iodine executable
IOD="/usr/local/sbin/iodine"

# Your top domain
IOTD="example.ircpimps.org"

# You may choose to store the password in this script or enter it every time
#IOPASS="your iodine password"

# You might need to change this if you use linux, or already have 
# tunnels running.  In linux iodine uses dnsX and fbsd/osX use tunX
# X represents how many tunnel interfaces exist, starting at 0
IODEV="tun0"

# The IP your iodined server uses inside the tunnel
# The man page calls this tunnel_ip
IOIP="10.7.0.1"


#### STOP EDITING ####

NS=`awk '/nameserver/ { print $2 }' /etc/resolv.conf | head -1`
GW=`netstat -rn|grep -v Gateway|grep G|awk '{print $2}'|head -1`
OS=`uname`
[ -z $IOPASS ] && echo "Enter your iodine password"
[ -z $IOPASS ] && $IOD $NS $IOTD
[ -n $IOPASS ] && $IOD -P "${IOPASS}" $NS $IOTD
if ps auxw|grep iodine|grep -v grep
 then
        case "$OS" in
        Darwin|*BSD)
		route delete default
		route add $NS -gateway $GW
		route add default -gateway $IOIP
		;;
	Linux)
		route del default
		route add $NS gw $GW
		route add default gw $IOIP $IODEV
		;;
	*)
		echo "Your OS is not osX, BSD, or Linux."
		echo "I don't know how to add routes on ${OS}."
		echo "Email krzee and tell him the syntax."
		;;
	esac
 echo "Press enter when you are done with iodine"
 echo "and you want your routes back to normal"
 read yourmind
 kill -9 `ps auxw|grep iodine|grep -v grep|awk '{print $2}'`
         case "$OS" in
        Darwin|*BSD)
                route delete default
                route delete $NS
                route add default -gateway $GW
                ;;
        Linux)
                route del default
                route delete $NS
                route add default gw $GW
                ;;
        *)
                echo "Your OS is not osX, BSD, or Linux."
                echo "I don't know how to add routes on ${OS}."
                echo "Email krzee and tell him the syntax."
                ;;
        esac
 else echo there was a problem starting iodine
 echo try running it manually to troubleshoot
fi
exit
