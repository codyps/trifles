#!/bin/sh

led_com="setleds -L"

led_set () {
	local led=$1
	local level=$2

	case $level in
	+|high)
		$led_com +$led
		;;
	-|low)
		$led_com -L -$led
		;;
	esac
}


while true; do
	x=$RANDOM

	if [ $x -gt 16000 ]; then
		led_set caps -
	else
		led_set caps +
	fi

	sleep 1

done
