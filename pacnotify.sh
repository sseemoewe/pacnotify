#!/bin/sh
. /etc/pacnotify.conf
. /home/$USER/.config/pacnotify
while [ true ]
 do
  sleep $updateinterval && /usr/bin/pkgfile gedit > /tmp/qqu && notify-send "Updates" "<b>Anzahl: `grep -c [a-z] /tmp/qqu`</b>\n`cat -b /tmp/qqu` " -t $showinterval
 done
