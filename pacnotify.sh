#!/bin/bash
#
#Setting standards
sleeptime=1h
expiretime=600000
conffile1=/etc/pacnotify.conf
conffile2=/home/$USER/.config/pacnotify.conf
#that was all about config
#lets start
notify-send Pacnotify "Starting up and setting defaults.\n<b>Sleep: </b>$sleeptime \n<b>Show: </b>$expiretime ms" -t 600000
if [ -f $conffile1 ];
	then
		. $conffile1
		notify-send Pacnotify "found: global conffile \n<b>Sleep: </b>$sleeptime \n<b>Notify: </b>$expiretime ms" -t 600000
	else
		notify-send Pacnotify "global conffile not found. \n<b>Sleep: </b>$sleeptime \n<b>Notify: </b>$expiretime ms" -t 600000
fi

if [ -f $conffile2 ];
	then
		. $conffile2
		notify-send Pacnotify "found: $USER\'s conffile \n<b>Sleep: </b>$sleeptime \n<b>Notify: </b>$expiretime ms \n 	… going background" -t 600000
	else
		notify-send Pacnotify "$USER\'s confile not found. \n<b>Sleep: </b>$sleeptime \n<b>Notify: </b>$expiretime" -t 600000
fi
while [ true ]
 do
  sleep $sleeptime && /usr/bin/pacman -Qqu > /tmp/qqu && notify-send "Updates" "<b>Anzahl: `grep -c [a-z] /tmp/qqu`</b>\n`cat -b /tmp/qqu` " -t $expiretime
 done
