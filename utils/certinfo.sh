#!/bin/bash

SERVERNAME=$1
PORT=$2
PARAMS=""

print_help(){
cat << EOF
  Script that fetches SSL certificate information from remote server and prints out certificate fields.
  Can be used for certificate expiration date monitoring.

  Usage: certinfo.sh hostname.or.ip.address port [parameters]

  Parameters:

  --issuer      - Certificate issuer
  --subject     - Subject
  --serial      - Serial
  --email       - Email
  --start-date  - Certificate start date
  --end-date    - Certificate end date
  --expires-in  - Expiration in days
  --purpose     - Certificate purposes
  --dates       - Both start and end dates
  --fingerprint - Certificate fingerprint
  --alias       - Certificate aliases
  --modulus     - Modulus
  --pubkey      - Public key
  --all         - Full certificate information (the same as without any parameters)
  --help        - This help
EOF
exit 0
}

expires_in(){
    EXP_DATE=$( 
    echo "" | openssl s_client -connect ${SERVERNAME}:${PORT} 2>/dev/null \
    | sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' \
    | openssl x509 -in - -enddate \
    | sed '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/d' \
    | sed 's/notAfter=//' 
)
    DAYS_LEFT=$(( ($(date -d "$EXP_DATE" +%s) - $(date -d "now" +%s) ) / 86400 ))
    echo $DAYS_LEFT days
    exit
}

shift 2
while [ "$1" != "" ]
do
    case "$1" in
	--issuer) PARAMS+="-issuer " ;;
	--subject) PARAMS+="-subject " ;;
	--serial) PARAMS+="-serial " ;;
	--email) PARAMS+="-email " ;;
	--start-date) PARAMS+="-startdate " ;;
	--end-date) PARAMS+="-enddate " ;;
	--purpose) PARAMS+="-purpose " ;;
	--dates) PARAMS+="-dates " ;;
	--fingerprint) PARAMS+="-fingerprint " ;;
	--alias) PARAMS+="-alias " ;;
	--modulus) PARAMS+="-modulus " ;;
	--pubkey) PARAMS+="-pubkey " ;;
	--all) PARAMS+="-text " ;;
	--help) print_help ;;
	--expires-in) expires_in ;;
	*) ;;
    esac
    shift
done

PARAMS=${PARAMS:-"-text "}

echo "" | openssl s_client -connect ${SERVERNAME}:${PORT} 2>/dev/null \
| sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' \
| openssl x509 -in - $PARAMS \
| sed '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/d'
