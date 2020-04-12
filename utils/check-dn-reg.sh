#!/bin/bash
# Bash script how many days are left before the domain expires.
# Скрипт выводит количество дней до окончания регистрации домена.
# Initial source code: https://mnorin.com/monitoring-daty-prodleniya-domennogo-imeni.html

if [ "$1" == "" ]
then
cat << EOF
  Script that monitors how many days left until domain registration ends.
  Usage: $(basename $0) domain.name
EOF
exit
fi

PAIDTILL=$(whois $1 | grep -m 1 'paid-till\|Registrar Registration Expiration Date\|Registry Expiry Date')

if [ -z "$PAIDTILL" ]
then
    echo "Registration end date is not available in whois database"
    exit 1
else
    [[ "$PAIDTILL" =~ "paid-till" ]] && PAIDTILL=${PAIDTILL//./-}
    PAIDTILL=$(echo -e "${PAIDTILL#*:}" | xargs )
    CURRENTDATE=$(date "+%Y-%m-%d %H:%M:%S")
    DAYS_LEFT=$((($(date -d "$PAIDTILL" +%s) - $(date -d "$CURRENTDATE" +%s) ) / 86400 ))
    echo $DAYS_LEFT
fi
