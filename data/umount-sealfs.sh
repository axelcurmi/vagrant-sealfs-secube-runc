#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function echo_info {
    echo -e "${GREEN}${1}${NC}"
}

echo_info "[+] START SealFS umount"
sudo umount /var/log/GKE
ls -al /var/log/GKE
mount -l | grep /var/log/GKE
echo_info "[+] END SealFS umount"