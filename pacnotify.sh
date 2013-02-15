#!/bin/sh
#. /etc/pacnotify.conf
. /home/$USER/.config/pacnotify.conf
while [ true ]
 do
  sleep $sleeptime && /usr/bin/pacman -Qqu > /tmp/qqu && notify-send "Updates" "<b>Anzahl: `grep -c [a-z] /tmp/qqu`</b>\n`cat -b /tmp/qqu` " -t $expiretime
 done
