#! /bin/bash
################################################################################
# File Name: mongodb_env_setup.sh
# Author: R0rs12ach
# Mail: R0rs12ach@gmail.com
# Created Time: Mon 20 June 2016 03:00:00 PM CST
# Usage: sh mongodb_env_setup.sh
# Description: auto install mongodb on platform of centos
# Attention: just install 64-bit version
################################################################################

# 我使用rpm安装，那么首先需要创建一个repo文件在/etc/yum.repos.d/下
mongodb_rpm=/etc/yum.repos.d/mongodb-org-3.2.repo
if [ ! -f $mongodb_rpm ]
    then
        touch $mongodb_rpm
    else
	rm -fr $mongodb_rpm
	touch $mongodb_rpm
fi

# 改变mongodb-org-3.2的文件内容
echo '[mongodb-org-2.6]' >> $mongodb_rpm
echo 'name=MongoDB Repository' >> $mongodb_rpm
echo 'baseurl=http://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/' >> $mongodb_rpm
echo 'gpgcheck=1' >> $mongodb_rpm
echo 'enabled=1' >> $mongodb_rpm
echo 'gpgkey=http://www.mongodb.org/static/pgp/server-3.2.asc' >> $mongodb_rpm

# 提示用户开始安装, 注意stty的用法，配合-echo来增强交互性，stty -echo表示关闭自动打印用户输入到当前ERPL
echo '一切就绪，是否安装？输入y开始安装，输入n取消安装:'
stty -echo
read choice < /dev/tty
stty echo

if [ $choice != 'y' ]
    then
	echo '安装被您取消！'
    else
	echo '开始安装……'
	yum install -y mongodb-org
fi
