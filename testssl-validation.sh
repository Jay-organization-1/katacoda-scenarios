#!/bin/bash

TESTSSL_FILE=/usr/bin/testssl

echo "checking...  $TESTSSL_FILE tool installation status"
if [ ! -f $TESTSSL_FILE ]; then
        echo "$TESTSSL_FILE utility not installed"
	echo "Make sure that testssl utility get installed on the server before running the test...."
exit 0;
else
	echo "Make sure that testssl utility get installed on the server before running........."
	echo "-------------Getting RO server IP address-----------------------------------------"
	hostname=`ifconfig | grep -i inet | grep -i broadcast | awk '{print $2}'`
	echo $hostname

	echo "Runnig testssl on the server to check for any vulnarabilities on the system"
	$TESTSSL_FILE -L  $hostname:8443 > testssl-log
	cat testssl-log
	echo ""
	grep -i "not vulnerable" testssl-log && echo "testssl validation is fine - No vulnerabilities are reported"  || echo "testssl validation is not fine - Vulnerabilities are reported"
fi


