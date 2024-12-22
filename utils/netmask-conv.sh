#!/bin/bash

# This script converts IP address and netmask from a network interface (e.g. 192.168.1.123 255.255.255.0)
# to a network address (e.g. 192.168.1.0/24) in pure bash without external programs.

if [ -z $1 ] || [ -z $2 ]; then echo -e "Usage: $0 <IP> <long-mask>\nExample: $0 192.168.1.14 255.255.255.0"; exit 1; fi

BARRAY=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})

BINARY_IP_ADDRESS=$(for octet in ${1//./ }; do echo -n ${BARRAY[octet]}; done)
BINARY_NETMASK=$(for octet in ${2//./ }; do echo -n ${BARRAY[octet]}; done)
BITS=${BINARY_NETMASK%%0*}
BITS_COUNT=${#BITS}

NETWORK_ADDRESS=${BINARY_IP_ADDRESS:0:BITS_COUNT}${BINARY_NETMASK:BITS_COUNT}

NEW_ADDRESS="${NETWORK_ADDRESS:0:8} ${NETWORK_ADDRESS:8:8} ${NETWORK_ADDRESS:16:8} ${NETWORK_ADDRESS:24:8}"

DECIMAL_ADDRESS=`echo $(for octet in $NEW_ADDRESS; do echo $((2#$octet)); done)`
DECIMAL_ADDRESS=${DECIMAL_ADDRESS// /.}

echo $DECIMAL_ADDRESS/$BITS_COUNT
