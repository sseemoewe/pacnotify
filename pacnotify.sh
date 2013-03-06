#!/bin/bash
#
#Setting standards
#Don't change the values here. Create a file in either your global 
#config path, or in /home/YourName/.config/. name it pacnotify.conf 
#and fill in the values you want to override. Notice that Users 
#jconfiguration files always have precedence, then the global one and at 
#last the values set here.
sleeptime=1h	# time to wait between notifications
expires=120		# seconds to display the notification
backoff=1		# wait x if pacman is running (in minutes) , start with a small number!
backoff_limit=30 # limit minutes to wait (per try)
delay=5			# add x minutes delay to backoff per try
maxtries=10		# max tries until notification is send anyway, set to 0 to turn waiting off.
lines=9			# lines of packages to display
icon=/usr/share/icons/pacnotify32.png # which icon to use

#next few vars should not be touched
globalconf=/etc/pacnotify.conf
userconf=/home/$USER/.config/pacnotify.conf
tmpfile=/tmp/pacnotify.qqu
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

time=$(($expires * 1000))
case $initmsg in
	1) notify-send Pacnotify "Starting up and setting defaults from userconf.\n<b>Sleep: </b>$sleeptime min \n<b>Show: </b>$expires sec" -t $time -i $icon ;;
	2) notify-send Pacnotify "Starting up and setting defaults from globalconf.\n<b>Sleep: </b>$sleeptime min \n<b>Show: </b>$expires sec" -t $time -i $icon ;;
	3) notify-send Pacnotify "Starting up and setting defaults.\n</b>$sleeptime min \n<b>Show: </b>$expires sec" -t $time -i $icon ;;
	4) notify-send Pacnotify "Seems that pacnotify is already running. With PID: <b>`cat $lockfile`</b>. If not delete <b>$lockfile</b>.\n" -t $time -i $icon 
	exit;;
esac
while [ true ]
	do
		counts=0
		oldbackoff=$backoff
		waited=0
		while [ $counts -lt $maxtries ]
			do
			pacman_pid=`pgrep -f "pacman -S"`
			if [ $pacman_pid != 0 ];
				then
					p_runs_wait='<b>pacman is running (PID: '$pacman_pid')</b>\nnumber of updates may be incorrect. Waiting '$backoff'm for pacman to exit.'
					try=$(($counts + 1))
					notify-send Pacnotify "$p_runs_wait (Try: $try)" -t $time -i $icon
					ptrue=0
				else
					ptrue=1
			fi
			if [ $ptrue -lt 1 ];
				then
					sleep $backoff'm'
					counts=$(( $counts + 1 ))
					waited=$(( $backoff + $waited))
					backoff=$(( $backoff + $delay ))
					if [ $backoff -gt $backoff_limit ];
						then
							backoff=$backoff_limit
					fi
				else
					maxtries=-1
			fi
			if [ $counts == $maxtries ]
				then
					p_runs_skip='<b>pacman was running</b> while checking for updates.\nNumber of updates may be incorrect.\nWaited '$waited'min for pacman to exit. Gave up…\n'
				else
					p_runs_skip=
			fi
		done
	/usr/bin/pacman -Qqu > $tmpfile
	x_updates=`grep -c [a-z] $tmpfile`
	x_diff=$(($x_updates - $lines))
	if [ $x_diff -lt 0 ];
		then
			x_diff=0
		else
			more='\n<b>and '$x_diff' more</b>'
	fi
	pakete=`head -n $lines $tmpfile|cat -b`
	notify-send Pacnotify "$p_runs_skip<b>$x_updates Updates</b>\n$pakete $more" -t $time -i $icon
	rm $tmpfile
	pacman_pid=
	pruns=
	more=
	backoff=$oldbackoff
	sleep $sleeptime
done
