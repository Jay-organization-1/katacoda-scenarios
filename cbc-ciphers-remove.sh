#!/usr/bin/bash
#RemoveCBC.sh

INIT_FILE=/opt/panaces/bin/panaces_env

panasis_file=$EAMSROOT/installconfig/panaces.properties
tomcat_file=$EAMSROOT/installconfig/tomcat/server.xml

echo "Taking back up of  $panasis_file  file ..."
cp $EAMSROOT/installconfig/panaces.properties $EAMSROOT/installconfig/panaces.properties.bkp

echo "Checking ciphers from $panasis_file  FILE.........................."
TargetFile=$1
G=$(perl -F= -lane 'print if /panaces.acp.communicationTLSCipher/' $panasis_file)
echo "Listing panaces.properties file ciphers before removing"
echo $G
echo
echo "Removing _CBC_ ciphers from $panasis_file file"
M=$(echo $G | perl -F= -lane '$F[1] = join ",", grep { $_ !~ "_CBC_" } split/,/,$F[1]; print join "=", @F')
echo "Listing remaining ciphers after removing _CBC_ ciphers from panaces.properties file"
echo $M
echo
J=$M perl -i -pe 's/panaces.acp.communicationTLSCipher=.*/$ENV{J}/' $panasis_file
echo "-----------------------------------------------------------------------------------------------"
echo
echo "checking ciphers status after removing from $panasis_file file"
result1=(grep -i "_CBC_" $panasis_file)
if [ "$result1" = "0" ]; then
        echo "CBC Ciphers found in $panasis_file"
else
        echo "CBC Ciphers not found in $panasis_file"
fi

echo "----------------------------------------------------------------------------------"
echo "Taking back up of $tomcat_file file  ..."
cp $EAMSROOT/installconfig/tomcat/server.xml $EAMSROOT/installconfig/tomcat/server.xml.bkp

echo "Checking ciphers from $tomcat_file  FILE.........................."
TargetFile=$1
G1=$(perl -F= -lane 'print if /panaces.acp.communicationTLSCipher/' $tomcat_file)
echo "Listing $tomcat_file  file ciphers before removing"
echo $G1
if [ $? = 0 ]; then
	echo "No CBC Ciphers in  $tomcat_file file"
else
	echo "CBC Ciphers exist in  $tomcat_file file"
fi
echo "-----------------------------------------------------------------------------------------------"
echo
#echo "Removing _CBC_ ciphers from $tomcat_file  file-------"
M=$(echo $G1 | perl -F= -lane '$F[1] = join ",", grep { $_ !~ "_CBC_" } split/,/,$F[1]; print join "=", @F')
echo "Listing remaining ciphers after removing _CBC_ ciphers from $tomcat_file file"
echo $M1
echo
J1=$M perl -i -pe 's/panaces.acp.communicationTLSCipher=.*/$ENV{J}/' $tomcat_file
echo "-----------------------------------------------------------------------------------------------"
echo "checking ciphers status after removing from $tomcat_file file
result2=(grep -i "_CBC_" $tomcat_file)
if [ "$result2" = "0" ]; then
        echo "CBC Ciphers found in $tomcat_file"
else
        echo "CBC Ciphers not found in $tomcat_file"
fi

echo "-----------------------------------------------------------------------------------------------"
#echo "CBC ciphers are removed from... $panasis_file"
#echo "CBC ciphers are removed from... $tomcat_file"

echo "-----------------------------------------------------------------------------------------------"
echo "running the SecurityUserInjection.sh to set the standard FILE permissions...."
$EAMSROOT//bin/SecurityUserInjection.sh

echo "-----------------------------------------------------------------------------------------------"
echo "Next restart the panaces services ...."
echo "After panasis restart... run the nmap and testssl validation scripts....."
echo "-----------------------------------------------------------------------------------------------"


#echo "------------After CBC ciphers remove restarting the panaces services--------------"
#$EAMSROOT/bin/panaces status
#$EAMSROOT/bin/panaces stop
sleep 500
#$EAMSROOT/bin/panaces start
#sleep 500
#echo "-----------------------------------------------------------------------------------------------"

