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
PATH=${URL/$PROTOCOL/}
PATH=${PATH/$HOST/}
PATH=${PATH/$FILENAME/}
PORT=80
HEADERS="HTTP/1.1\r\nHost: $HOST\r\nConnection: close\r\nContent-Length: 0\r\n\r\n"

exec 3<>/dev/tcp/$HOST/$PORT
echo -e "GET $PATH$FILENAME $HEADERS" >&3
/bin/cat <&3 > $SAVENAME

/bin/sed -i $SAVENAME -e '1,/^\r$/d'
