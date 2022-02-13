#!/bin/bash
FiRE_WALL=/sbin/firewalld

echo "checking  $FIRE_WALL  tool installation status"
if [  ! -f $FiRE_WALL ]; then
        echo "$FiRE_WALL tool not installed"
        echo "Install the $FiRE_WALL tool first to start the test"
exit 0;

else
echo "checking the status of the firewall"
systemctl status firewalld


echo "If firewall is enabled - check the ports which are already configured"
echo "Listing the ports which are configured"
firewall-cmd --list-all

echo "Disbling the ports which are not required"
echo "Add code to disable the PORTS..............................." 
echo "Disabling all the ports first and then adding the required ports only....."
firewall-cmd --zone=public --remove-port=22/tcp --permanent
firewall-cmd --zone=public --remove-port=42443/tcp --permanent
firewall-cmd --zone=public --remove-port=43443/tcp --permanent
firewall-cmd --zone=public --remove-port=45443/tcp --permanent
firewall-cmd --zone=public --remove-port=8443/tcp --permanent
firewall-cmd --zone=public --remove-port=8083/tcp --permanent
firewall-cmd --zone=public --remove-port=8082/tcp --permanent
firewall-cmd --zone=public --remove-port=5800/tcp --permanent
firewall-cmd --zone=public --remove-port=5900/tcp --permanent
firewall-cmd --zone=public --remove-port=5901/tcp --permanent
firewall-cmd --zone=public --remove-port=5902/tcp --permanent
firewall-cmd --zone=public --remove-port=8081/tcp --permanent
firewall-cmd --zone=public --remove-port=3306/tcp --permanent
firewall-cmd --zone=public --remove-port=5500/tcp --permanent
firewall-cmd --zone=public --remove-port=443/tcp --permanent
firewall-cmd --zone=public --remove-port=45445/tcp --permanent
firewall-cmd --zone=public --remove-port=8982/tcp --permanent


echo "allowing only 45443,42443  ports in SC server for the firewall" 
firewall-cmd --zone=public --add-port=45443/tcp --permanent
firewall-cmd --zone=public --add-port=42443/tcp --permanent

echo "Making the added ports active..............................."
firewall-cmd --reload

echo "After ativation checking the ports status..................."
echo "Listing the ports which are configured"
firewall-cmd --list-all
fi
