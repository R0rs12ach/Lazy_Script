#! /bin/bash -
################################################################
# File Name: ez_pip_setup.sh 
# Author: R0rs12ach
# Mail: R0rs12ach@gmail.com
# Created Time: Wed 29 June 2016 03:46:23 PM CST
# Usage: sh ez_pip_setup.sh 
# Description: auto install easy_install & pip 
################################################################
python -V
if [ $?-eq0 ]
then
  wget -q https://raw.githubusercontent.com/R0rs12ach/Lazy_Script/master/easy_install_pip_setup/ez_setup.py
  python ez_setup.py
  wget --no-check-certificate https://raw.githubusercontent.com/R0rs12ach/Lazy_Script/master/easy_install_pip_setup/1.5.5.tar.gz
  tar zvxf 1.5.5.tar.gz
  cd pip-1.5.5/
  python setup.py install
else
  echo "Python 尚未正确安装"
  exit
fi
