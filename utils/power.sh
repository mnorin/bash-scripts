#!/bin/bash

COMMAND="dbus-send --system --print-reply --dest="org.freedesktop.Hal" /org/freedesktop/Hal/devices/computer org.freedesktop.Hal.Device.SystemPowerManagement"
case "$1" in
    shutdown)$COMMAND.Shutdown;;
    reboot)$COMMAND.Reboot;;
    hibernate)$COMMAND.Hibernate;;
    suspend)$COMMAND.Suspend int32:0;;
    *)echo "Usage: $0 shutdown|reboot|hibernate|suspend";;
esac
