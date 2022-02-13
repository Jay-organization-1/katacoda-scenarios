#!/bin/sh

echo
echo "	Note that root user will be disabled, only sanovi user will be allowed !!"
echo 
echo "	press 'y' to  Continue, any other key to exit"
echo "        "
read x
if [[ $x != 'y' ]]; then
exit 0;
fi

spaceLine()
{
echo >>/opt/serverHardening.log
}

mkdir -p /etc/backup-itcs/

spaceLine
echo "Date" >> /opt/serverHardening.log
date >>/opt/serverHardening.log
spaceLine
echo "If NTP server not configured, please request it to be configured at /etc/ntp.conf" >> /opt/serverHardening.log
spaceLine
echo "Taking backup of /etc/motd, in case if its defined already ... " >> /opt/serverHardening.log
scp /etc/motd /etc/backup-itcs/motd.$$
echo "Business Use Notice, updating message of the day" >> /opt/serverHardening.log
echo "Please enter Customer Name"
read custName
echo "$custName's internal systems must only be used for conducting $custName's business or for purposes authorized by $custName management" > "/etc/motd"


mkdir -p /etc/tonic/remind/
searchCommentLine()
{
searchString=$1
fileName=$2
sed -i "/$searchString/ s@^@#@g" $fileName
}

searchUnCommentLine()
{
searchString=$1
fileName=$2
sed -i "/$searchString/ s@^@@g" $fileName
}


searchRemoveLine()
{
searchString=$1
fileName=$2
sed -i "/$searchString.*/d" $fileName
}


searchReplaceLine()
{
searchString=$1
replaceString=$2
fileName=$3

sed -i "/$searchString.*/s/^#//g" $fileName

if grep -q "$searchString" $fileName ; then
    echo "$searchString found so replacing line $replaceString" >> /opt/serverHardening.log
    sed -i "s@$searchString.*@$replaceString@" $fileName
else
    echo "$searchString not found so adding" >> /opt/serverHardening.log
    echo "$replaceString" >> $fileName
fi
}

searchReplaceStringIgnoreCase()
{
searchString=$1
replaceString=$2
fileName=$3
sed -i "s@$searchString@$replaceString@Ig" $fileName
}

searchReplaceimmediateString()
{
searchString=$1
replaceString=$2
fileName=$3
sed -i "s/$searchString [0-9]\+/$replaceString/Ig" $fileName
}
logRotateContent()
{
echo "
# see "man logrotate" for details
# rotate log files weekly
weekly

# keep 4 weeks worth of backlogs
rotate 13

# create new (empty) log files after rotating old ones
create

# use date as a suffix of the rotated file
dateext

# uncomment this if you want your log files compressed
#compress

# RPM packages drop log rotation information into this directory
include /etc/logrotate.d

# no packages own wtmp and btmp -- we'll rotate them here
/var/log/wtmp {
    monthly
    create 0664 root utmp
        minsize 1M
    rotate 4
}

/var/log/btmp {
    missingok
    monthly
    create 0600 root utmp
    rotate 1
}

# system-specific logs may be also be configured here.
" > /etc/logrotate.conf
}
echo "Remove users from passwd files" >> /opt/serverHardening.log
spaceLine
echo "Taking backup of /etc/passwd as /etc/backup-itcs/passwd.save1.$$"  >> /opt/serverHardening.log
scp /etc/passwd /etc/backup-itcs/etcpasswd.save1.$$
searchRemoveLine "adm:"  "/etc/passwd"
searchRemoveLine "lp:"  "/etc/passwd"
searchRemoveLine "sync:"  "/etc/passwd"
searchRemoveLine "shutdown:"  "/etc/passwd"
searchRemoveLine "halt:"  "/etc/passwd"
searchRemoveLine "uucp:"  "/etc/passwd"
searchRemoveLine "operator:"  "/etc/passwd"
searchRemoveLine "games:"  "/etc/passwd"
searchRemoveLine "gopher:" "/etc/passwd"
searchRemoveLine "ftp:" "/etc/passwd"
searchRemoveLine "nobody:" "/etc/passwd"
searchRemoveLine "nscd:" "/etc/passwd"
searchRemoveLine "oprofile:" "/etc/passwd"
spaceLine
echo "Remove users from shadow files" >> /opt/serverHardening.log
spaceLine
echo "Taking backup of /etc/shadow as /etc/backup-itcs/shadow.save1.$$"  >> /opt/serverHardening.log
scp /etc/shadow /etc/backup-itcs/shadow.save1.$$
searchRemoveLine "adm:"  "/etc/shadow"
searchRemoveLine "lp:"  "/etc/shadow"
searchRemoveLine "sync:"  "/etc/shadow"
searchRemoveLine "shutdown:"  "/etc/shadow"
searchRemoveLine "halt;"  "/etc/shadow"
searchRemoveLine "uucp:"  "/etc/shadow"
searchRemoveLine "operator:"  "/etc/shadow"
searchRemoveLine "games:"  "/etc/shadow"
searchRemoveLine "gopher:" "/etc/shadow"
searchRemoveLine "ftp:" "/etc/shadow"
searchRemoveLine "nobody:" "/etc/shadow"
searchRemoveLine "nscd:" "/etc/shadow"
searchRemoveLine "oprofile:" "/etc/shadow"

#SSH-2.2.1: Private Key Encryption
#  * SSH private keys must not give any access to non-owner.
 #   - /etc/ssh/ssh_host_ecdsa_key gives some access to group/other (change permissions to 0600)
 #   - /etc/ssh/ssh_host_ed25519_key gives some access to group/other (change permissions to 0600)
 #   - /etc/ssh/ssh_host_rsa_key gives some access to group/other (change permissions to 0600)
 #   - /etc/ssh/ssh_host_ecdsa_key gives some access to group/other (change permissions to 0600)

echo "SSH-2.2.1 taking backup  /etc/ssh/ssh* /etc/backup-itcs/" >>/opt/serverHardening.log
scp -p /etc/ssh/ssh_host_ecdsa_key /etc/backup-itcs/ssh_host_ecdsa_key.$$
scp -p /etc/ssh/ssh_host_ed25519_key /etc/backup-itcs/ssh_host_ed25519_key.$$
scp -p /etc/ssh/ssh_host_rsa_key /etc/backup-itcs/ssh_host_rsa_key.$$
scp -p /etc/ssh/ssh_host_ecdsa_key /etc/backup-itcs/ssh_host_ecdsa_key.$$

echo "Changing permission for the ssh_host files to 0600 
chmod 0600 /etc/ssh/ssh_host_rsa_key
chmod 0600 /etc/ssh/ssh_host_rsa_key
chmod 0600 /etc/ssh/ssh_host_ed25519_key 
chmod 0600 /etc/ssh/ssh_host_ecdsa_key
" >> /opt/serverHardening.log
chmod 0600 /etc/ssh/ssh_host_rsa_key
chmod 0600 /etc/ssh/ssh_host_rsa_key
chmod 0600 /etc/ssh/ssh_host_ed25519_key
chmod 0600 /etc/ssh/ssh_host_ecdsa_key
 
echo "3. SSH-5.2.2:  SSH Security and System Administrative Authority" >> /opt/serverHardening.log
echo "Taking backup of /etc/ssh/sshd_config as /etc/backup-itcs/sshd_config.save1.$$" >>  /opt/serverHardening.log
scp /etc/ssh/sshd_config  /etc/backup-itcs/sshd_config.save1.$$

if ! grep -q "PermitRootLogin" "/etc/ssh/sshd_config"
then
echo "PermitRootLogin no" >>  "/etc/ssh/sshd_config"
else
searchReplaceLine "PermitRootLogin yes" "PermitRootLogin no" "/etc/ssh/sshd_config"
fi

spaceLine
echo "4. SSH-5.7.8: SSH Service Availability Management" >> /opt/serverHardening.log
searchReplaceLine "MaxAuthTries" "MaxAuthTries 5" "/etc/ssh/sshd_config"
spaceLine
echo "5. SSH-6.1: SSH Activity Auditing" >> /opt/serverHardening.log
searchReplaceLine "LogLevel" "LogLevel INFO" "/etc/ssh/sshd_config"
spaceLine
echo "Taking backup of /etc/sudoers as /etc/backup-itcs/sudoers.save1.$$" >>/opt/serverHardening.log
scp /etc/sudoers /etc/backup-itcs/sudoers.save1.$$

echo "6. Sudo-5.2.2: Sudo Access Validation" >> /opt/serverHardening.log
searchReplaceLine "sanovi  ALL=" "sanovi  ALL=(ALL)       NOPASSWD: ALL, !/bin/su" /etc/sudoers
touch "/etc/tonic/remind/Sudo_access_revalidated"

#Sudo-6.3: Sudo Secondary Logging
#  * You must confirm that secondary logging is enabled for sudo or that access to run sudo su is not permitted
    touch /etc/tonic/remind/Sudo_Secondary_Logging_revalidated


spaceLine
echo "7. Sudo Secondary Logging.... Please verify that /var/log/secure file does contain sudo operations for sanovi user" >> /opt/serverHardening.log
echo
echo "Please verify that /var/log/secure file does contain sudo operations for sanovi user"
touch /etc/tonic/remind/Sudo_access_revalidated
spaceLine

#echo "8. non-ITCS NoNull: Prevent services from accepting empty passwords" >> /opt/serverHardening.log

#echo "Taking backup of  /etc/pam.d/password-auth-ac,system-auth at /etc/backup-itcs/system-auth-ac " >>/opt/serverHardening.log
#scp /etc/pam.d/password-auth-ac /etc/backup-itcs/password-auth-ac.save1.$$
#scp /etc/pam.d/system-auth-ac /etc/backup-itcs/system-auth-ac.save1.$$

#searchReplaceStringIgnoreCase "nullok" "" "/etc/pam.d/password-auth-ac"
#searchReplaceStringIgnoreCase "nullok" "" "/etc/pam.d/system-auth"
#searchReplaceStringIgnoreCase "nullok" "" "/etc/pam.d/system-auth-ac"

if [ -f /etc/pam.d/vmtoolsd ]; then
searchReplaceStringIgnoreCase "nullok" "" /etc/pam.d/vmtoolsd
fi

spaceLine
echo "9 non-ITCS PAM: All PAM modules that are used must be installed" >> /opt/serverHardening.log
echo "Taking backup of /etc/pam.d/passwd as /etc/backup-itcs/passwd.save1.$$" >> /opt/serverHardening.log
scp /etc/pam.d/passwd /etc/backup-itcs/passwd.save1.$$
#echo "Taking backup of /etc/pam.d/smartcard-auth-ac as /etc/backup-itcs/smartcard-auth-ac.save1.$$" >> /opt/serverHardening.log
#scp /etc/pam.d/smartcard-auth-ac /etc/backup-itcs/smartcard-auth-ac.save1.$$

#searchCommentLine "pam_pkcs11[.]so" "/etc/pam.d/smartcard-auth-ac"
searchCommentLine "pam_gnome_keyring.so" "/etc/pam.d/passwd"
#searchCommentLine "pam_pkcs11[.]so" "/etc/pam.d/system-auth-ac"
spaceLine
echo "10 a. required value auth include system-auth" >> /opt/serverHardening.log
echo "Taking backup of /etc/pam.d/sshd ... /etc/backup-itcs/sshd.save1.$$" >> /opt/serverHardening.log
scp /etc/pam.d/sshd /etc/backup-itcs/sshd.save1.$$
searchReplaceLine "auth       include      password-auth" "auth       include      system-auth" "/etc/pam.d/sshd"
searchReplaceLine "account    include      password-auth" "account    include      system-auth" "/etc/pam.d/sshd"
searchReplaceLine "password   include      password-auth" "password   include      system-auth" "/etc/pam.d/sshd"
spaceLine
#echo "10. b password system auth update" >> /opt/serverHardening.log
#searchReplaceLine "password    sufficient    pam_unix[.]so sha512" "password    sufficient    pam_unix.so sha512 shadow try_first_pass use_authtok remember=7" "/etc/pam.d/system-auth-ac"
#spaceLine
#searchReplaceLine "password    sufficient    pam_unix[.]so sha512" "password    sufficient    pam_unix.so sha512 shadow try_first_pass use_authtok remember=7" "/etc/pam.d/password-auth-ac"

spaceLine
#echo "10. d "
searchReplaceLine "password   include      system-auth" "password   include      system-auth" "/etc/pam.d/passwd"

spaceLine
echo "11. Maximum Password Age" >> /opt/serverHardening.log
passwd -x 90 sanovi >> /opt/serverHardening.log 
passwd -x 90 root >> /opt/serverHardening.log
spaceLine
echo "12. Password Strength, Minimum Password Age " >> /opt/serverHardening.log
#searchReplaceLine "password    requisite     pam_crackli.*" "password    requisite     pam_cracklib.so try_first_pass retry=3 type= dcredit=-1 lcredit=-1 minlen=8 ocredit=0 reject_username ucredit=0" "/etc/pam.d/system-auth-ac"

spaceLine
echo "13/14. Issue: Users should change their passwords every 90 days" >> /opt/serverHardening.log
echo "Taking backup of /etc/login.defs as /etc/backup-itcs/login.defs.save1.$$" >> /opt/serverHardening.log
scp /etc/login.defs /etc/backup-itcs/login.defs.save1.$$
searchReplaceLine "PASS_WARN_AGE" "PASS_WARN_AGE   7" "/etc/login.defs"
searchReplaceLine "PASS_MIN_LEN" "PASS_MIN_LEN    8" "/etc/login.defs"
searchReplaceLine "PASS_MAX_DAYS" "PASS_MAX_DAYS   45" "/etc/login.defs"
searchReplaceLine "PASS_MIN_DAYS" "PASS_MIN_DAYS   7" "/etc/login.defs"
#searchReplaceLine "PASS_WARN" "PASS_WARN       14" "/etc/login.defs"
searchReplaceLine "FAILLOG_ENAB" "FAILLOG_ENAB    yes" "/etc/login.defs"
spaceLine
echo "15. Minimum Password Age" >> /opt/serverHardening.log
passwd -n 1 root >> /opt/serverHardening.log
passwd -n 1 sanovi >> /opt/serverHardening.log

spaceLine
#echo "16. " 

echo "18. Business Use Notice"  >> /opt/serverHardening.log
#if ! grep -q "IBM" "/etc/motd" ; then
#echo "IBM's internal systems must only be used for conducting IBM's business or for purposes authorized by IBM management" >> "/etc/motd"
#fi
spaceLine

echo "19/20. umask User Resources" >> /opt/serverHardening.log
echo "Taking backup if already exist for files /etc/profile.d/IBMsinit.csh & /etc/profile.d/IBMsinit.sh at /etc/backup-itcs/" >> /opt/serverHardening.log
touch /etc/profile.d/IBMsinit.csh
touch /etc/profile.d/IBMsinit.sh
scp /etc/profile.d/IBMsinit.csh /etc/backup-itcs/IBMsinit.csh.save1.$$
scp /etc/profile.d/IBMsinit.sh /etc/backup-itcs/IBMsinit.sh.save1.$$ 

echo -en "if [ "$'\x24'""UID" -gt 199 ]; then\numask 077\nfi\n" > "/etc/profile.d/IBMsinit.csh"

echo -en "if [ "$'\x24'""UID" -gt 199 ]; then\numask 077\nfi\n" > "/etc/profile.d/IBMsinit.sh"

chmod 0755 /etc/profile.d/IBMsinit.csh
chmod 0755 /etc/profile.d/IBMsinit.sh
touch /etc/tonic/remind/User_Resource_Requirements

spaceLine
echo "21. Recursive permissions test for $EAMSROOT and $TOMCAT_HOME"  >> /opt/serverHardening.log

#chown -R root:root $EAMSROOT
#chown -R root:root $TOMCAT_HOME
#chown -R root:root /opt/jboss-ews-2.0/tomcat7


sudo  mkdir -p /etc/tonic/remind/
sudo touch /etc/tonic/remind/Extra_Privileged_Users

# for $EAMSROOT/lib/SanoviHostServerStartup.sh has recursive permissions, setting root permissions
#sudo chown root:root $EAMSROOT/lib/SanoviHostServerStartup.sh

# for $EAMSROOT/lib has recursive permissions, so declaring the privilege
echo panacesusergroup > /etc/tonic/remind/Extra_Privileged_Groups
echo panacesuser > /etc/tonic/remind/Extra_Privileged_Users

# Insecure consoles are defined in /etc/securetty ,comment them
#echo "Taking backup of /etc/securetty as  /etc/backup-itcs/securetty.save1.$$" >> /opt/serverHardening.log
#scp /etc/securetty /etc/backup-itcs/securetty.save1.$$

#searchCommentLine ttysclp0 /etc/securetty
#searchCommentLine sclp_line0 /etc/securetty
#searchCommentLine "3270\/tty1"  /etc/securetty
#searchCommentLine xvc0 /etc/securetty


spaceLine
echo "22. Non-absolute path to executable detected" >> /opt/serverHardening.log
echo "Taking backup of /etc/cron.d/0hourly as /etc/backup-itcs/0hourly.save1.$$" >> /opt/serverHardening.log
scp /etc/cron.d/0hourly /etc/backup-itcs/0hourly.save1.$$
searchCommentLine "root run-parts" "/etc/cron.d/0hourly"

echo "23. Root Access from Secure Terminal" >> /opt/serverHardening.log

echo "Taking backup of /etc/pam.d/login as  /etc/backup-itcs/login.save1.$$" >> /opt/serverHardening.log
scp /etc/pam.d/login /etc/backup-itcs/login.save1.$$
#echo "auth required pam_securetty.so" >> /etc/pam.d/login
spaceLine
echo "Adding line "auth       include     system-auth" at /etc/pam.d/login " >> /opt/serverHardening.log
#sudo echo "auth       include     system-auth" >> /etc/pam.d/login
searchReplaceLine "auth       include     system-auth" "auth       include     system-auth" /etc/pam.d/login

spaceLine
echo "24. Enforce a default no access policy" >> /opt/serverHardening.log

#searchReplaceLine "auth           sufficient      pam_wheel.so" "auth           sufficient      pam_wheel.so trust use_uid" "/etc/pam.d/su"
#searchReplaceLine "auth           required        pam_wheel.so" "auth           required        pam_wheel.so use_uid" "/etc/pam.d/su"

sed -i '1s/^/auth           sufficient      pam_wheel.so trust use_uid \n/' /etc/pam.d/su
sed -i '1s/^/auth           required        pam_wheel.so use_uid \n/' /etc/pam.d/su
touch /etc/tonic/remind/Shared_Root_ID

spaceLine
echo "Adding line "auth include system-auth" at /etc/pam.d/su " >> /opt/serverHardening.log
searchReplaceLine "auth            include         system-auth" "auth            include         system-auth" /etc/pam.d/su
echo "Commenting auth,account,password postlogin include parameters at /etc/pam.d/su, /etc/pam.d/login, /etc/pam.d/sshd  " >> /opt/serverHardening.log

spaceLine
searchCommentLine 	"postlogin" /etc/pam.d/su
#searchCommentLine 	"auth           include         postlogin" /etc/pam.d/su
searchCommentLine	"auth       include      postlogin"	/etc/pam.d/login
searchCommentLine	"password   include      postlogin"	/etc/pam.d/login
searchCommentLine	"account    include      postlogin"	/etc/pam.d/login
searchCommentLine	"auth       include      postlogin"	/etc/pam.d/sshd

spaceLine

echo "Taking backup of /etc/logrotate.conf as  /etc/backup-itcs/logrotate.conf.save1.$$" >> /opt/serverHardening.log
scp /etc/logrotate.conf /etc/backup-itcs/logrotate.conf.save1.$$ 
#searchReplaceimmediateString "rotate" "rotate 13" "/etc/logrotate.conf"
logRotateContent

spaceLine
echo "26. Root Access from Secure Terminal" >> /opt/serverHardening.log
#pam_wheel.so
searchReplaceLine "auth required pam_securett" "auth required pam_securetty.so" "/etc/pam.d/login"

#searchReplaceLine "auth           sufficient      pam_wheel.so" "auth           sufficient      pam_wheel.so trust use_uid" "/etc/pam.d/su"
#searchReplaceLine "auth           required        pam_wheel.so" "auth           required        pam_wheel.so use_uid" "/etc/pam.d/su"
echo "Taking backup of /etc/pam.d/su as /etc/backup-itcs/su" >> /opt/serverHardening.log
scp /etc/pam.d/su /etc/backup-itcs/su

sed -i '1s/^/auth           sufficient      pam_wheel.so trust use_uid \n/' /etc/pam.d/su
sed -i '1s/^/auth           required        pam_wheel.so use_uid \n/' /etc/pam.d/su

spaceLine
echo "Uncommenting or adding below to have su access disabled for any user
auth            sufficient      pam_wheel.so trust use_uid
auth            required        pam_wheel.so use_uid
" >> /opt/serverHardening.log

spaceLine
echo "27. Linux Kernel Denial of Service Prevention" >> /opt/serverHardening.log
echo "Taking backup of /etc/sysctl.conf /etc/backup-itcs/susysctl.conf.save1.$$" >> /opt/serverHardening.log
scp /etc/sysctl.conf /etc/backup-itcs/sysctl.conf.save1.$$
searchReplaceLine "net[.]ipv4[.]conf[.]all[.]accept_redirects" "net.ipv4.conf.all.accept_redirects = 0" "/etc/sysctl.conf"

echo "28. Non-existing user in group" >> /opt/serverHardening.log
echo "Taking backup of /etc/group as /etc/backup-itcs/group.save1.$$" >> /opt/serverHardening.log
scp /etc/group /etc/backup-itcs/group.save1..$$

searchReplaceStringIgnoreCase "bin,adm" "bin" /etc/group
searchReplaceStringIgnoreCase "adm,daemon" "daemon" /etc/group

spaceLine
echo "Update as TCPKeepAlive yes" >> /opt/serverHardening.log
searchUnCommentLine "TCPKeepAlive yes" "/etc/ssh/sshd_config"
searchReplaceLine "TCPKeepAlive" "TCPKeepAlive yes" "/etc/ssh/sshd_config"


spaceLine
echo "Remember that root user loing is disabled now, you are required to login using sanovi" >> /opt/serverHardening.log
echo 
echo "Please reboot the server to have security settings saved."
echo "INFO: reboot the server to have security settings saved" >> /opt/serverHardening.log
echo "Refer security logs for more details at /opt/serverHardening.log"
echo 

