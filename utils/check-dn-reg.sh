#!/bin/bash

if [ "$1" == "" ]
then
cat << EOF

  Script that monitors how many days left until domain registration ends.

  Usage: $(basename $0) domain.name
EOF
exit
fi

PAIDTILL=$(whois $1 | grep 'paid-till\|Registrar Registration Expiration Date\|Registry Expiry Date')

if [ -z "$PAIDTILL" ]
then
    echo "Registration end date is not available in whois database"
    exit 1
else
    [[ "$PAIDTILL" =~ "paid-till" ]] && PAIDTILL=${PAIDTILL//./-}" 00:00:00"
    PAIDTILL=${PAIDTILL#*:}
    CURRENTDATE=$(date "+%Y-%m-%d %H:%M:%S")
    DAYS_LEFT=$(( ($(date -d "$PAIDTILL" +%s) - $(date -d "$CURRENTDATE" +%s) ) / 86400 ))
    echo $DAYS_LEFT days left
fi
