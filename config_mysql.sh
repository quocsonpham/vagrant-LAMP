#!/bin/bash
DBHOST=localhost
DBUSER=dbuser
DBPASSWD=root

mysql -uroot -p$DBPASSWD -e "CREATE USER 'dbuser'@'localhost' IDENTIFIED BY '123456'" >> /vagrant/vm_build.log 2>&1
mysql -uroot -p$DBPASSWD -e "grant all privileges on *.* to '$DBUSER'@'localhost' WITH GRANT OPTION" > /vagrant/vm_build.log 2>&1

mysql -uroot -p$DBPASSWD -e "CREATE USER 'dbuser'@'%' IDENTIFIED BY '123456'" >> /vagrant/vm_build.log 2>&1
mysql -uroot -p$DBPASSWD -e "grant all privileges on *.* to '$DBUSER'@'%' WITH GRANT OPTION" > /vagrant/vm_build.log 2>&1