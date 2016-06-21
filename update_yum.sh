#! /bin/bash -
##########################################################
# File Name: update_yum.sh
# Author: R0rs12ach
# Mail: R0rs12ach@gmail.com
# Create Time: Tue 21 June 2016 08:00:00 PM CST
# Usage: sh update_yum.sh
# Description: auto replace yum source with 163_yum_source
# Attention: just for CentOS7
##########################################################

# 判断是否已经存在CentOS-Base.repo文件
Base_Source=/etc/yum.repos.d/CentOS-Base.repo
if [ ! -f $Base_Source ]
then
  echo '当前系统不存在CentOS-Base.repo文件，系统正在创建……'
else
  mv $Base_Source /etc/yum.repos.d/CentOS-Base-Backup.repo
 fi

# 下载网易提供的yum源到指定位置
curl -o $Base_Source http://mirrors.163.com/.help/CentOS7-Base-163.repo

# 下载完成之后更新yum配置
yum makecache

# 提示用户完成更新，可以开始下载需要的包
if [ ! $? -eq 0 ]
then
  echo '更新失败，请检查网络'
else
  echo '恭喜您，更新完成，可以开始下载和更新软件包了！'
fi

