#!/bin/bash

if [ "$1" == "" ] 
then
    echo "usage: $0 URL"
    exit 0
fi

URL=$1
PROTOCOL=${URL%%/*}//
HOST=${URL/$PROTOCOL/}
HOST=${HOST%%/*}
FILENAME=${URL##*/}
SAVENAME=${FILENAME:-result}
URLPATH=${URL/$PROTOCOL/}
URLPATH=${URLPATH/$HOST/}
URLPATH=${URLPATH/$FILENAME/}
PORT=80
HEADERS="HTTP/1.1\r\nHost: $HOST\r\nConnection: close\r\nContent-Length: 0\r\n\r\n"

exec 3<>/dev/tcp/$HOST/$PORT
echo -e "GET $URLPATH$FILENAME $HEADERS" >&3
cat <&3 > $SAVENAME

sed -i $SAVENAME -e '1,/^\r$/d'
