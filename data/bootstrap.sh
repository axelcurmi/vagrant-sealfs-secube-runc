#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function echo_info {
    echo -e "${GREEN}${1}${NC}"
}

echo_info "[+] START UMVBox bootstrap"

# Copying SSH key
echo_info "[+] START Copying SSH key"
cp /data/dot-ssh/* /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/*
echo_info "[+] END Copying SSH key"

# Installing packages
echo_info "[+] START Installing packages"
sudo apt-get -y update
sudo apt-get -y install curl git vim build-essential cmake gdb unzip libboost-all-dev libreadline-dev libssl-dev libseccomp-dev pkg-config docker.io python3 python3-pip
pip3 install frida frida-tools distorm3

sudo usermod -aG docker vagrant
echo_info "[+] END Installing packages"

# Installing Go
GO_VERSION=1.22.0
echo_info "[+] START Installing Go v${GO_VERSION}"
wget -O /tmp/go${GO_VERSION}.linux-amd64.tar.gz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo tar -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz -C /usr/local
rm /tmp/go${GO_VERSION}.linux-amd64.tar.gz

mkdir -p /home/vagrant/go/src

export PATH=$PATH:/usr/local/go/bin
export GOPATH=/home/vagrant/go
echo_info "[+] END Installing Go v${GO_VERSION}"

# Installing runc
echo_info "[+] START Installing runc"
mkdir -p $GOPATH/src/github.com/opencontainers
git clone https://github.com/opencontainers/runc $GOPATH/src/github.com/opencontainer

cd $GOPATH/src/github.com/opencontainers
make
sudo make install
export PATH=$PATH:$GOPATH/src/github.com/opencontainers
echo_info "[+] END Installing runc"

# Installing funchook
echo_info "[+] START Installing funchook"
cd /home/vagrant

wget -O /tmp/funchook-1.1.2.zip https://github.com/kubo/funchook/releases/download/v1.1.2/funchook-1.1.2.zip
unzip /tmp/funchook-1.1.2.zip
rm /tmp/funchook-1.1.2.zip

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local funchook-1.1.2
sudo bash -c "make && make install"
sudo ldconfig
echo_info "[+] END Installing funchook"

# Cloning all repos
echo_info "[+] START Cloning repositories"
git clone https://github.com/axelcurmi/SEcube-Samples.git /home/vagrant/SEcube-Samples
git clone git@github.com:axelcurmi/sealfs-fork.git /home/vagrant/sealfs
git clone git@github.com:robert-abela/GKE.git /home/vagrant/GKE
echo_info "[+] END Cloning repositories"

# Setting up GKE
echo_info "[+] START Setting up GKE with runc"
cd /home/vagrant/GKE

sudo mkdir /var/log/GKE
sudo chown vagrant:vagrant /var/log/GKE

sudo docker build -f Dockerfile.ChatApp -t gke .
mkdir -p runc/rootfs
cp /data/runc/config.json runc/config.json

cd runc
container_id=$(sudo docker create gke)
sudo docker export ${container_id} | tar -C rootfs -xf -
sudo docker rm ${container_id}

cp -r /home/vagrant/SEcube-Samples GKE/runc/rootfs/root/

cd /home/vagrant/GKE/GKE
./compile.sh
echo_info "[+] END Setting up GKE with runc"

# Setting up GKE repeater
echo_info "[+] START Setting up GKE repeater"
cd /home/vagrant/GKE
sudo docker build -f Dockerfile.Repeater -t repeater .
sudo docker run -d -p 8888:8888 repeater
echo_info "[+] END Setting up GKE repeater"

# Setting up SealFS (TODO: Update this section to make use of my own sealfs fork)
KEYSTREAM_SIZE=100000000
echo_info "[+] START Setting up SealFS"
cd /home/vagrant/sealfs
git checkout secube

sudo bash -c "cd module && make"
sudo bash -c "cd tools && make"

sudo insmod module/sealfs.ko
sudo mkdir -p /var/lib/SealFS/{keys,logs}
echo_info "[+] END Setting up SealFS"

ip a

echo_info "[+] END UMVBox bootstrap"
