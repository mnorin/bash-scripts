#!/bin/bash

# Random Blocker
# Script that blocks/unblocks remote ports randomly on timeout

. `dirname $0`/rb.conf

if [ "$UID" != "0" ]
then
    echo "Sorry, it works under root only"
    exit 1
fi

echo "Press Ctrl+C to terminate."
while true
do
    iptables -F OUTPUT
    for ADDRESS in $BLOCK_LIST
    do
	if [[ "$BLOCK_ALWAYS" =~ "$ADDRESS" ]]
	then
	    BLOCK="1"
	    echo `date "+%Y-%m-%d %H:%M:%S"` "$ADDRESS is set to block constantly"
	else
	    BLOCK=$(( $RANDOM % 2 ))
	fi
	if [ "$BLOCK" == "1" ]
	then
	    IP_ADDR=${ADDRESS%:*}
	    IP_PORT=${ADDRESS#*:}
	    /sbin/iptables -t filter -A OUTPUT -d $IP_ADDR -p tcp --dport $IP_PORT -j DROP
	    echo `date "+%Y-%m-%d %H:%M:%S"` blocked $IP_ADDR:$IP_PORT
	fi
    done
    sleep $BLOCK_TIMEOUT
done
