# Install the extra EPEL repositories from dl.fedoraproject.org
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# ls *.rpm
sudo yum install epel-release-latest-7.noarch.rpm

# update container-selinux
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sudo yum install container-selinux

sudo yum erase ultra-centos-7.4-repo-0.0.3-1.el7.noarch

curl -fsSL https://get.docker.com/ | sh
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

sudo docker volume create portainer_data
sudo docker run -d -p 9000:9000 --name docker_admin -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

# sudo passwd root
# sudo /etc/rc.d/init.d/webmin stop
# sudo systemctl start webmin

# sudo yum install git -y
# git clone https://github.com/jc21/nginx-proxy-manager.git
# sudo yum install docker-compose -y # https://docs.docker.com/compose/install/

# https://github.com/angristan/openvpn-install
# curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
# sh openvpn-install.sh

# https://github.com/kylemanna/docker-openvpn
# OVPN_DATA="ovpn-data-example"
# docker volume create --name $OVPN_DATA
# docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM
# docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn ovpn_initpki
# docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
# docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it kylemanna/openvpn easyrsa build-client-full CLIENTNAME nopass
# docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn
