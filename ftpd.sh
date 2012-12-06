#!/bin/zsh -f
#
#	Author:		Timothy J. Luoma
#	Email:		luomat at gmail dot com
#	Date:		2011-09-28
#
#	Purpose: 	enable / disable ftpd on Lion
#
#	URL:		https://github.com/tjluoma/ftpd/
#
# 	Thanks to:	http://www.landofdaniel.com/blog/2011/07/22/starting-ftp-server-in-os-x-lion/
#				(although I don't know why he suggests `-s` as a separate line)

# customize this if you wish, or just remove it… you won't normally need it
PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

# same as `basename $0`
NAME="$0:t"

	# this script needs to be run as root, so if it isn't run as root, try again using 'sudo' automatically
if [ "`id -u`" != "0" ]
then
		exec sudo "$0" $@
fi

# this is where Lion keeps the plist
PLIST='/System/Library/LaunchDaemons/ftp.plist'

if [[ ! -e "$PLIST" ]]
then
		# this should never happen, but just in case...
		echo "$NAME: cannot find $PLIST"
		exit 2
fi

# function to turn ftpd-on
ftp-on ()
{
	CURRENT=`status`

	if [ "$CURRENT" = "on" ]
	then
		echo "$NAME: ftp is already ON"
		exit 0
	else
		# load the plist
		launchctl   load -w "${PLIST}" && echo "$NAME: ftpd is now loaded [enabled/ready]" && exit 0
	fi
}

# function to turn ftpd-off
ftp-off ()
{
	CURRENT=`status`

	if [ "$CURRENT" = "off" ]
	then
		echo "$NAME: ftp is already OFF"
		exit 0
	else
		# unload the plist
		launchctl unload -w "${PLIST}" && echo "$NAME: ftpd is now unloaded [disabled]" && exit 0
	fi
}

# function to check status
status ()
{
	STATUS=`launchctl list | fgrep -i com.apple.ftpd`

	if [ "$STATUS" = "" ]
	then
			STATUS=off
	else
			STATUS=on
	fi

	echo "$STATUS"
}


#########################################################################################
#
#
# if the argument has the word "on" 	or "enable"		or "load" 		then turn it on
# if the argument has the word "off"	or "disable" 	or "unload" 	then turn it off
#
# otherwise, just show the current status


case "$1" in
	*on*|*ON*|*enable*|*ENABLE*|load|LOAD)
						ftp-on
						exit
	;;

	*off*|*OF*|*disable*|*DISABLE*|unload|UNLOAD)
						ftp-off
						exit
	;;

esac


status


#########################################################################################

exit 0
#EOF
