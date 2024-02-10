#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function echo_info {
    echo -e "${GREEN}${1}${NC}"
}

echo_info "[+] START SealFS mount"
sudo mount -o kpath=/var/lib/SealFS/keys/k1,nratchet=2048 -t sealfs /var/lib/SealFS/logs /var/log/GKE
echo_info "[+] END SealFS mount"