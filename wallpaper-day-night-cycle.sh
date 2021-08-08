#!/bin/bash
# Validate wallpaper file
scriptdir=$(realpath "$0")
scriptdir=$(dirname "$scriptdir")
scriptdir=$(printf "%q" "$scriptdir")
#scriptdir=$(dirname $scriptdir)
#scriptdir=$(printf "%q" "$scriptdir")

function filecheck () {
	if [ ! -f "$1" ] ; then
		echo "Error. File not found: $1"
		exit 1
	fi
}
# Validate time
function timecheck () {
	if [[ ! "$1" =~ ^[0-21][0-9]:[0-5][0-9]$ ]] ; then
		echo "Error. Wrong time format."
		exit 1
	fi
}

# Get wallpapers
echo "Path to wallpaper to be used during the day."
read day
filecheck "$day"
day=$(printf "%q" "$day")
echo "Path to wallpaper to be used during the night."
read night
filecheck "$night"
night=$(printf "%q" "$night")

# Get times
echo "Time when the day cycle will begin (24h-format, i.e. \"17:00\" for 5 p.m.):"
read daytime
timecheck "$daytime"
echo "Time when the night cycle will begin (24h-format, i.e. \"17:00\" for 5 p.m.):"
read nighttime
timecheck "$nighttime"

# Process times
IFS=":"
read -a daytime <<< "$daytime"
read -a nighttime <<< "$nighttime"

# Add cronjobs
daycron="${daytime[1]} ${daytime[0]} * * * $scriptdir/change-wallpaper.sh $day"
nightcron="${nighttime[1]} ${nighttime[0]} * * * $scriptdir/change-wallpaper.sh $night"
(crontab -u "$USER" -l; echo "$daycron" ) | crontab -u "$USER" -
(crontab -u "$USER" -l; echo "$nightcron" ) | crontab -u "$USER" -
