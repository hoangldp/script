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
sudo docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
