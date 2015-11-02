#!/bin/sh
# Purpose: Auto hibernates after a period of sleep
# Edit the "autohibernate" variable below to set the number of seconds to sleep.
lockfile=/var/run/systemd/rtchibernate.lock
curtime=$(date +%s)
# 30 min
autohibernate=1800

case $1/$2 in
  pre/suspend)
    # Suspending. Record current time, and set a wake up timer.
    echo "Suspending until" `date -d "$autohibernate seconds"`
    echo "$curtime" > $lockfile
    rtcwake -m no -s $autohibernate
    ;;
  post/suspend)
    # Coming out of sleep
    sustime=$(cat $lockfile)
    echo -n "Back from suspend... "
    rm $lockfile
    # Did we wake up due to the rtc timer above?
    if [ $(($curtime - $sustime)) -ge $autohibernate ]
    then
        # Then hibernate
        echo "hibernate"
        systemctl hibernate
    else
        echo "wake-up"
        # Otherwise cancel the rtc timer and wake up normally.
        rtcwake -m disable
    fi
    ;;
esac
