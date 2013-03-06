#!/bin/bash
#
#Setting standards
#Don't change the values here. Create a file in either your global 
#config path, or in /home/YourName/.config/. name it pacnotify.conf 
#and fill in the values you want to override. Notice that Users 
#jconfiguration files always have precedence, then the global one and at 
#last the values set here.
sleeptime=1h
expires=120
globalconf=/etc/pacnotify.conf
userconf=/home/$USER/.config/pacnotify.conf
icon=/usr/share/icons/pacnotify32.png
tmpfile=/tmp/pacnotify.qqu
lines=9
pid=$$
lockfile=/tmp/pacnotify.lock

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

if [ -f $lockfile ];
				then
					initmsg=4
				else
					echo $pid > $lockfile
fi

case $initmsg in
	1) notify-send Pacnotify "Starting up and setting defaults from userconf.\n<b>Sleep: </b>$sleeptime \n<b>Show: </b>$expires s" -t $(($expires * 1000)) -i $icon ;;
	2) notify-send Pacnotify "Starting up and setting defaults from globalconf.\n<b>Sleep: </b>$sleeptime \n<b>Show: </b>$expires s" -t $(($expires * 1000)) -i $icon ;;
	3) notify-send Pacnotify "Starting up and setting defaults.\n<b>Sleep: </b>$sleeptime \n<b>Show: </b>$expires s" -t $(($expires * 1000)) -i $icon ;;
	4) notify-send Pacnotify "Seems that pacnotify is already running. With PID: <b>`cat $lockfile`</b>. If not delete <b>$lockfile</b>.\n" && exit;;
esac
while [ true ]
 do
  /usr/bin/pacman -Qqu > $tmpfile
  x_updates=`grep -c [a-z] $tmpfile`
  x_diff=$(($x_updates - $lines))
  if [ $x_diff -lt 0 ];
	then
		x_diff=0
		more=
	else
		more='\n<b>and '$x_diff' more</b>'
  fi
  pakete=`head -n $lines $tmpfile|cat -b`
  notify-send Pacnotify "<b>$x_updates Updates</b>\n$pakete $more" -t $(($expires * 1000)) -i $icon
  rm $tmpfile
  sleep $sleeptime
 done
