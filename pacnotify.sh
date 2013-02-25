#!/bin/bash
#
#Setting standards
sleeptime=1h
expiretime=600000
globalconf=/etc/pacnotify.conf
userconf=/home/$USER/.config/pacnotify.conf
icon=$PWD/logo32.png
tmpfile=/tmp/pacnotify.qqu
#that was all about config
#lets start by getting the .conf
#case [ -z $1 ]
if [ -f $userconf ];
	then
		. $userconf
		initmsg=1
	elif [ -f $globalconf ];
		then
			. $globalconf
			initmsg=2
		else
			initmsg=3
fi

# see if its already running
if [ -f $tmpfile ];
	then
		initmsg=4
fi

case $initmsg in
	1) notify-send Pacnotify "Starting up and setting defaults from userconf.\n<b>Sleep: </b>$sleeptime \n<b>Show: </b>$expiretime ms" -t 60000 -i $icon ;;
	2) notify-send Pacnotify "Starting up and setting defaults from globalconf.\n<b>Sleep: </b>$sleeptime \n<b>Show: </b>$expiretime ms" -t 60000 -i $icon ;;
	3) notify-send Pacnotify "Starting up and setting defaults.\n<b>Sleep: </b>$sleeptime \n<b>Show: </b>$expiretime ms" -t 60000 -i $icon ;;
	4) notify-send Pacnotify "Seems that pacnotify is already running. If not delete $tmpfile." && exit;;
esac
while [ true ]
 do
  sleep $sleeptime && /usr/bin/pacman -Qqu > $tmpfile && notify-send "Updates" "<b>Anzahl: `grep -c [a-z] $tmpfile`</b>\n`cat -b $tmpfile` " -t $expiretime
 done
