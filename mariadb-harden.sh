#!/bin/sh

# Securing mysql wiht inbuilt script
# Provide the inputs accordingly

sudo /usr/bin/mysql_secure_installation

# Droping test database ; 
# 
echo
echo Droping test database
echo
mysql -uroot -p <<EOF

drop database test;
delete from mysql.user where user="";

EOF

echo
if [ ! -f /etc/my.cnf ]; then
echo "Creating /etc/my.cnf and adding required entries as there is no file,and restarting mariadb services"
sudo echo "
#
# This group is read both both by the client and the server
# use it for options that affect everything
#
[client-server]
#
# include all files from the config directory
#
!includedir /etc/my.cnf.d
[mysqld]
bind-address=127.0.0.1 #Enabling this panaces services started,but later latest build installed on 8.0 panaces did not start, if fails to start, you can disable this
local-infile=0
skip-show-database
sql_mode="NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
innodb_log_buffer_size=8M
innodb_flush_log_at_trx_commit=1
innodb_print_all_deadlocks = 1
innodb_file_io_threads=4
max_binlog_size=20M
max_allowed_packet=16M
max_connections=500
#log_bin=panacespri_binlog
#binlog-do-db=panaces
#binlog-do-db=pfr
#server-id=1
#binlog-format=MIXED
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
log_warnings=1
query_cache_limit=4194304
query_cache_size=33554432
tmp_table_size=268435456
max_heap_table_size=268435456
innodb_buffer_pool_size=1024M
thread_cache_size=16
slow_query_log = 1
slow_query_log_file = /var/lib/mysql/Mysql_SlowQuery.log
#skip-name-resolve
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
" > /etc/my.cnf

else
	echo
	echo " Updating /etc/my.cnf with hardening entries...  and restarting mariadb services"
	echo
	sudo sed '/^max_allowed_packet=.*/a bind-address=127.0.0.1 #Enabling this worked,but later latest build installed on 8.0 panaces did not start, if fails to start, you can disable this.' /etc/my.cnf > /tmp/new

	sudo sed '/^max_allowed_packet=.*/a local-infile=0' /tmp/new > /tmp/new1

	sudo sed '/^max_allowed_packet=.*/a skip-show-database' /tmp/new1 > /tmp/new2
        sudo sed '/^max_allowed_packet.*/a slow_query_log_file = /var/lib/mysql/Mysql_SlowQuery.log' /tmp/new2 > /tmp/new3
        sudo sed '/^max_allowed_packet.*/a slow_query_log = 1' /tmp/new3 > /tmp/new4
        sudo sed '/^max_allowed_packet.*/a max_connections=500' /tmp/new4 > /tmp/new5
        sudo scp /etc/my.cnf /etc/my.cnf.$$
        sudo scp /tmp/new5 /etc/my.cnf

fi
	# Remote tmp files
	sudo rm -f /tmp/new /tmp/new1 /tmp/new2 /tmp/new3 /tmp/new5
sleep 10
# Clear MySQL-History

sudo rm -f /root/.mysql_history
sudo ln -s /dev/null /root/.mysql_history
# Restarting mysql
echo
echo 
sudo service mysql restart


#end of script
