#!/bin/bash

if [ "$1" == "" ] 
then
    echo "usage: $0 URL"
    exit 0
fi

HOST=`echo $1 | sed 's/http\:\/\///' | sed -r 's/([^/])\/(.*)/\1/'`
FILENAME=`echo "$1" | sed -r 's/(.*)\/(.*)/\2/'`
PATH=`echo "$1" | sed 's/http\:\/\///' | sed -r "s/$HOST//" | sed "s/$FILENAME//"`
PORT=80
HEADERS="HTTP/1.1\r\nHost: $HOST\r\nConnection: close\r\nContent-Length: 0\r\n\r\n"
F="/tmp/dlfile"
exec 3<>/dev/tcp/$HOST/$PORT
echo -e "GET $PATH$FILENAME $HEADERS" >&3
/bin/cat <&3 > $F
/usr/bin/tail $F -n +$((`/bin/sed $F -e '/^\r$/q' | /usr/bin/wc -l`+1)) > $FILENAME
/bin/rm $F
