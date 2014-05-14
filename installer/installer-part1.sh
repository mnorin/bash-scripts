#!/bin/bash

echo -n "This will install pixmaps. Are you sure you want to install? [y/n]: "
while true
do
    read -n 1
    case $REPLY in
	y|Y) break
	;;
	n|N) exit
	;;
	*) echo "Answer only y/n, please"
	;;
    esac
done

# We need to get the installation path here

echo -ne "\nEnter the path you want to install [/home/$USER/pixmaps]: "
read -n 1
INSTALLATION_PATH=$REPLY
if [ "$INSTALLATION_PATH" == "" ]
then
    INSTALLATION_PATH="/home/$USER/pixmaps"
fi
mkdir -p $INSTALLATION_PATH

# Extract base file from script

cat > /tmp/archive.base << EOF 
