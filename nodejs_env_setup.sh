#! /bin/bash -
#########################################################################
# File Name: nodjs_env_setup.sh 
# Author: R0rs12ach
# Mail: R0rs12ach@gmail.com
# Created Time: Wed 15 June 2016 03:46:23 PM CST
# Usage: sh nodejs_env_setup.sh version_num
# Description: auto install nodejs develop enviroment
# Attention: just install 64-bit version
#########################################################################

# 判断用户有没有自行指定nodejs版本号，如果没有，就使用固定的4.4.5
arg=$1
VERSION=${arg:=4.4.5}

echo "System will installing v$VERSION of NodeJS in 1 second later"
sleep 1

NODE_VERSION=node-v$VERSION
NODE_TAR=${NODE_VERSION}.tar
DOWNLOAD_HOME=/usr/local

# 判断/usr/local路径是否存在，不存在则创建一个
if [ ! -d $DOWNLOAD_HOME ]
then
        echo 'Can not found /usr/local directory, System will create it'
        mkdir -p $DOWNLOAD_HOME
else
        echo 'System will download nodejs installation package into ${DOWNLOAD_HOME}'
fi

# 切换到/usr/local目录，下载解压安装包
cd $DOWNLOAD_HOME
if [ ! -f $NODE_TAR ]
then
        echo 'Download is begining'
else
        rm -fr $NODE_TAR
fi

if [ ! -d $NODE_VERSION ]
then
        echo 'Please wait for a few minutes ...'
else
        rm -fr $NODE_VERSION
fi

curl -o $NODE_TAR http://nodejs.org/dist/v${VERSION}/${NODE_VERSION}-linux-x64.tar.xz
tar -xf $NODE_TAR

if [ $? -eq 0 ]
then
        mv -f ${NODE_VERSION}-linux-x64 ${NODE_VERSION}
else
        echo 'Download failed, please check your network'
        echo 'Or make sure the version which you want to download already exsit'
        exit 1
fi

# 配置环境变量
echo "export PATH=\$PATH:/usr/local/${NODE_VERSION}/bin" >> /etc/profile
source /etc/profile

if [ $? -eq 0 ]
then
        echo 'Congratulations, NodeJS Develop Enviorment Have Successfully Installed'
        echo 'Please check via "node -v"'
else
        echo 'Sorry, Installing Failed'
fi