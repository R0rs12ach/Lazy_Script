#! /bin/bash -
#########################################################################
# File Name: lamp_env_setup.sh 
# Author: R0rs12ach
# Mail: R0rs12ach@gmail.com
# Created Time: Wed 13 July 2016 03:46:23 PM CST
# Usage: sh lamp_env_setup.sh 
# Description: auto install apache php mysql develop enviroment for wordpress
# Attention: the best way to do this job is docker
#########################################################################

#首先安装apache
sudo yum install httpd -y
sudo service httpd start

#然后安装mysql，centos7和centos6的mysql安装有差异，所以需要做个判断
cat /etc/redhat-release | grep 'CentOS Linux release 7'

if [ $?-eq0 ]
#说明是centos7
then
	wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
	sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
	rm -fr mysql-community-release-el7-5.noarch.rpm
else
	echo "We found you were centos 6.x, we will install mysql-server for you"
fi

sudo yum install mysql-server -y
sudo service mysqld start

#最后安装php
sudo yum install php php-mysql -y
sudo yum install php-gd php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc -y

#默认开机自启动apache和mysql
sudo chkconfig httpd on
sudo chkconfig mysqld on

#测试是否安装成功
touch /var/www/html/info.php
echo "<?php phpinfo(); ?>" >> !$
