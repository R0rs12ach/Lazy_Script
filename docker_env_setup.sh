#! /bin/bash -
#########################################################################
# File Name: docker_env_setup.sh 
# Author: R0rs12ach
# Mail: R0rs12ach@gmail.com
# Created Time: Wed 14 July 2016 03:46:23 PM CST
# Usage: sh docker_env_setup.sh 
# Description: auto install docker develop enviroment
# Attention: just install docker for CentOS7 
#########################################################################
curl sSL https://get.daocloud.io/docker | sh
sudo chkconfig docker on
sudo systemctl start docker
if [$? -eq 0]
then
	echo "docker has been running, you can check it by 'sudo systemctl status docker'"
else
	echo "docker can't running correctly, please check what's happening"
fi
