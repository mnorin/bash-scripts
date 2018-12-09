#!/bin/bash

if [ "$1" == "" ]
then
    echo
    echo This script scans TCP opened ports on IP or hostname
    echo Usage : portscan.sh \<ip-or-hostname\> \[start-port\] \[end-port\]
    echo start-port equals to 1 by default
    echo end-port equals 1024 by default
    echo
    exit
fi

START_PORT=${2:-1}
END_PORT=${3:-1024}
echo "Scanning $1 (ports $START_PORT to $END_PORT)"

PORT_PROTOCOL="tcp"

scan_port(){
    PORT_NUMBER=$1
    PORT_SCAN_RESULT=`2>&1 echo "" > /dev/$PORT_PROTOCOL/$TARGET_NAME_OR_IP/$PORT_NUMBER | grep connect`
    [ "$PORT_SCAN_RESULT" == "" ] && echo $PORT_NUMBER\/$PORT_PROTOCOL'	'open'	'`grep $PORT_NUMBER/$PROTOCOL /etc/services | head -n1 | awk '{print $1}'`
}

TARGET_NAME_OR_IP=$1
echo 'PORT	STATE	SERVICE'

for PORT_NUMBER in `seq $START_PORT $END_PORT`
do
    scan_port $PORT_NUMBER
done
