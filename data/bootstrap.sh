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
sudo apt-get -y install curl git vim build-essential libssl-dev libseccomp-dev pkg-config docker.io

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

# Cloning all repos
echo_info "[+] START Cloning repositories"
git clone https://github.com/axelcurmi/SEcube-Samples.git /home/vagrant/SEcube-Samples
git clone https://gitlab.eif.urjc.es/esoriano/sealfs.git /home/vagrant/sealfs
git clone git@github.com:robert-abela/GKE.git /home/vagrant/GKE
echo_info "[+] END Cloning repositories"

# Setting up GKE
echo_info "[+] START Setting up GKE with runc"
cd /home/vagrant/GKE
git checkout add-runc # Switch to 'add-runc' branch; eventually this line will be removed once the branch is merged into master

sudo mkdir /var/log/GKE
sudo chown vagrant:vagrant /var/log/GKE

sudo docker build -f Dockerfile.ChatApp -t gke .
mkdir -p runc/rootfs
cp /data/runc/config.json runc/config.json

cd runc
container_id=$(sudo docker create gke)
sudo docker export ${container_id} | tar -C rootfs -xf -
sudo docker rm ${container_id}
echo_info "[+] END Setting up GKE with runc"

# Setting up GKE repeater
echo_info "[+] START Setting up GKE repeater"
cd /home/vagrant/GKE
sudo docker build -f Dockerfile.Repeater -t repeater .
sudo docker run -d -p 8888:8888 repeater
echo_info "[+] END Setting up GKE repeater"

# Setting up SealFS (TODO: Update this section to make use of my own sealfs fork)

echo_info "[+] END UMVBox bootstrap"
