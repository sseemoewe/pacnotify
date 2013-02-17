#!/bin/bash
#
#Setting standards
sleeptime=1h
expiretime=600000
globalconf=/etc/pacnotify.conf
userconf=/home/$USER/.config/pacnotify.conf
icon=$PWD/logo32.png
#that was all about config
#lets start

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

case $initmsg in
	1) notify-send Pacnotify "Starting up and setting defaults from userconf.\n<b>Sleep: </b>$sleeptime \n<b>Show: </b>$expiretime ms" -t 60000 -i $icon ;;
	2) notify-send Pacnotify "Starting up and setting defaults from globalconf.\n<b>Sleep: </b>$sleeptime \n<b>Show: </b>$expiretime ms" -t 60000 -i $icon ;;
	3) notify-send Pacnotify "Starting up and setting defaults.\n<b>Sleep: </b>$sleeptime \n<b>Show: </b>$expiretime ms" -t 60000 -i $icon ;;
esac
while [ true ]
 do
  sleep $sleeptime && /usr/bin/pacman -Qqu > /tmp/qqu && notify-send "Updates" "<b>Anzahl: `grep -c [a-z] /tmp/qqu`</b>\n`cat -b /tmp/qqu` " -t $expiretime
 done
