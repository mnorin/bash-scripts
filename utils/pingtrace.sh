#!/bin/bash
REMOTE_HOST=$1
REMOTE_HOST_2=`host $1 | grep 'has address' | awk '{printf $4}'`
TARGET_HOST="_"
TARGET_TTL=1

echo Tracing host $REMOTE_HOST\($REMOTE_HOST_2\)

while [ "$REMOTE_HOST" != "$TARGET_HOST" -a "$REMOTE_HOST_2" != "$TARGET_HOST" ]
do
    TARGET_HOST=`ping -c 1 -t $TARGET_TTL $REMOTE_HOST | grep 'exceeded' | awk '{printf $2}'`
    if [ "$TARGET_HOST" != "" ]
    then
	echo $TARGET_HOST, TTL=$TARGET_TTL
	TARGET_TTL=$(($TARGET_TTL+1))
    else
	echo $REMOTE_HOST, TTL=$TARGET_TTL
	exit
    fi
done
