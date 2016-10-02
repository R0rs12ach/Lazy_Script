#! /bin/sh

set -e

if [ -z "$1" ]
then
    echo 'Error: Registry-mirror url required.'
    exit 0
fi

MIRROR_URL=$1
lsb_dist=''
command_exists() {
    command -v "$@" > /dev/null 2>&1
}
if command_exists lsb_release; then
    lsb_dist="$(lsb_release -si)"
    lsb_version="$(lsb_release -rs)"
fi
if [ -z "$lsb_dist" ] && [ -r /etc/lsb-release ]; then
    lsb_dist="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
fi
if [ -z "$lsb_dist" ] && [ -r /etc/debian_version ]; then
    lsb_dist='debian'
fi
if [ -z "$lsb_dist" ] && [ -r /etc/fedora-release ]; then
    lsb_dist='fedora'
fi
if [ -z "$lsb_dist" ] && [ -r /etc/os-release ]; then
    lsb_dist="$(. /etc/os-release && echo "$ID")"
fi
if [ -z "$lsb_dist" ] && [ -r /etc/centos-release ]; then
    lsb_dist="$(cat /etc/*-release | head -n1 | cut -d " " -f1)"
fi
if [ -z "$lsb_dist" ] && [ -r /etc/redhat-release ]; then
    lsb_dist="$(cat /etc/*-release | head -n1 | cut -d " " -f1)"
fi
lsb_dist="$(echo $lsb_dist | cut -d " " -f1)"
docker_version="$(docker -v| cut -d "." -f2)"
lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"
set_mirror(){
	case "$lsb_dist" in
	    centos)
	    if grep "CentOS release 6" /etc/redhat-release > /dev/null
	    then
            if [[ "$docker_version" -lt 8 ]]
            then
                echo "please update your docker to v1.8 or later"
                exit 0
            fi
		sudo sed -i "s|other_args=\"|other_args=\"--registry-mirror='$MIRROR_URL'|g" /etc/sysconfig/docker
		sudo sed -i "s|OPTIONS='|OPTIONS='--registry-mirror='$MIRROR_URL'|g" /etc/sysconfig/docker
        echo "Success."
        echo "You need to restart docker to take effect : sudo service docker restart"
				exit 0
	    fi
	    if grep "CentOS Linux release 7" /etc/redhat-release > /dev/null
	    then
            if [[ "$docker_version" -lt 12 ]]
            then 
		    sudo sed -i "s|\(ExecStart=/usr/bin/docker[^ ]* daemon\)|\1 --registry-mirror="$MIRROR_URL"|g" /lib/systemd/system/docker.service
		        sudo systemctl daemon-reload
		    else
		        sudo sed -i "s|^ExecStart=/usr/bin/dockerd$|ExecStart=/usr/bin/dockerd --registry-mirror="$MIRROR_URL"|g" /lib/systemd/system/docker.service
		        sudo systemctl daemon-reload
            fi
        echo "Success."
        echo "You need to restart docker to take effect : sudo systemctl restart docker "
				exit 0
        else
	        echo "Error: Set mirror failed, please set registry-mirror manually please."
	        exit 1
        fi 
	;;
	    fedora)
	    if grep "Fedora release" /etc/fedora-release > /dev/null
	    then
            if [[ "$docker_version" -lt 12 ]]; then
		    sudo sed -i "s|\(ExecStart=/usr/bin/docker[^ ]* daemon\)|\1 --registry-mirror="$MIRROR_URL"|g" /lib/systemd/system/docker.service
		    sudo systemctl daemon-reload
		    else
		        sudo sed -i "s|^ExecStart=/usr/bin/dockerd$|ExecStart=/usr/bin/dockerd --registry-mirror="$MIRROR_URL"|g" /lib/systemd/system/docker.service
		    sudo systemctl daemon-reload
            fi
        echo "Success."
        echo "You need to restart docker to take effect : sudo systemctl restart docker"
				exit 0
        else
	        echo "Error: Set mirror failed, please set registry-mirror manually please."
	        exit 1
        fi
	;;
	    ubuntu|debian)
        if [ $lsb_version = "16.04" ]; then
            if [ "$docker_version" -lt 12 ]; then
		        sudo sed -i "s|\(ExecStart=/usr/bin/docker[^ ]* daemon -H fd://$\)|\1 --registry-mirror="$MIRROR_URL"|g" /lib/systemd/system/docker.service
		        sudo systemctl daemon-reload
		    else
		        sudo sed -i "s|\(^ExecStart=/usr/bin/dockerd -H fd://$\)|\1 --registry-mirror="$MIRROR_URL"|g" /lib/systemd/system/docker.service
		        sudo systemctl daemon-reload
            fi
        else
	        DOCKER_CONFIG_FILE="/etc/default/docker"
	        if grep "registry-mirror" $DOCKER_CONFIG_FILE > /dev/null
	        then
		        sudo sed -i -u -E "s#--registry-mirror='?((http|https)://)?[a-zA-Z0-9.]+'?#--registry-mirror='$MIRROR_URL'#g" $DOCKER_CONFIG_FILE
	        else
		        echo 'DOCKER_OPTS="$DOCKER_OPTS --registry-mirror='$MIRROR_URL'"' >> $DOCKER_CONFIG_FILE
		        echo $MIRROR_URL
	        fi
        fi
	    echo "Success."
        echo "You need to restart docker to take effect : sudo service docker restart"
	    exit 0
	;;
        arch)
        if grep "Arch Linux" /etc/os-release > /dev/null
	    then
            if [[ "$docker_version" -lt 12 ]]; then
		    sudo sed -i "s|\(ExecStart=/usr/bin/docker[^ ]* daemon -H fd://\)|\1 --registry-mirror="$MIRROR_URL"|g" /lib/systemd/system/docker.service
		    sudo systemctl daemon-reload
		    else
		        sudo sed -i "s|^ExecStart=/usr/bin/dockerd -H fd://$|ExecStart=/usr/bin/dockerd -H fd:// --registry-mirror="$MIRROR_URL"|g" /lib/systemd/system/docker.service
		    sudo systemctl daemon-reload
            fi
        echo "Success."
        echo "You need to restart docker to take effect : sudo systemctl restart docker"
				exit 0
        else
	        echo "Error: Set mirror failed, please set registry-mirror manually please."
	        exit 1
        fi
	;;
        suse)
        if grep "openSUSE Leap" /etc/os-release > /dev/null
        then
            if [[ "$docker_version" -lt 12 ]]; then
		    sudo sed -i "s|\(^ExecStart=/usr/bin/docker daemon -H fd://\)|\1 --registry-mirror="$MIRROR_URL"|g" /usr/lib/systemd/system/docker.service
		    sudo systemctl daemon-reload
		    else
                sudo sed -i "s|\(^ExecStart=/usr/bin/dockerd -H fd://\)|\1 --registry-mirror="$MIRROR_URL"|g" /usr/lib/systemd/system/docker.service
		    sudo systemctl daemon-reload
            fi
        echo "Success."
        echo "You need to restart docker to take effect : sudo systemctl restart docker"
				exit 0
        else
	        echo "Error: Set mirror failed, please set registry-mirror manually please."
	        exit 1
        fi
	esac
	    echo "Error: Unsupported OS, please set registry-mirror manually."
	exit 1
}
set_mirror
