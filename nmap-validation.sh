#!/bin/bash

NMAP_FILE=/usr/bin/nmap

echo "checking  nmap tool installation status"
if [  ! -f $NMAP_FILE ]; then
	echo "$NMAP_FILE utility not installed"
	echo "Install the namp tool first"
exit 0;

else
echo "$NMAP_FILE tool installed on the system"
echo "Running $NMAP_FILE to check for ciphers on the Server..........."
echo "Make sure that nmap utility get installed on RO and SC...."
echo "Running the script and check for - No CBC Ciphers listed in the report....."


echo "-------------Getting the server IP address---------------------------------------"
hostname=`ifconfig | grep -i inet | grep -i broadcast | awk '{print $2}'`
echo $hostname

echo "Runnig nmap tool to check for ciphers...."
echo "-------------Running nmap utility-------------------------------------------------"
/usr/bin/nmap -sV  -p 45443 -Pn --script ssl-enum-ciphers $hostname > nmap-log
echo "----------------------------------------------------------------------------------"
cat nmap-log
grep -i "CBC" nmap-log && echo "nmap validation is not fine - CBC ciphers are found"  || echo "nmap validation fine - CBC ciphers are are not found"
echo "----------------------------------------------------------------------------------"

fi


