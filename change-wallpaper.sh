#!/bin/bash
scriptdir=$(dirname $0)

# Export environment variable; necessary for cron to run successfully
PID=$(pidof cinnamon) #TO DO: Find more generic process so this will be more distro-agnostic.
DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)
export DBUS_SESSION_BUS_ADDRESS

# Change wallpaper
gsettings set org.cinnamon.desktop.background picture-uri "file:////$1"
