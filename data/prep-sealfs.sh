#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "usage: $0 keysize secube[0/1]";
    exit 1;
fi

KEYSIZE=$1
USE_SECUBE=$2

sudo /home/vagrant/sealfs/tools/prep /var/lib/SealFS/logs/.SEALFS.LOG /var/lib/SealFS/keys/k1 /var/lib/SealFS/keys/k2 $KEYSIZE $USE_SECUBE
ls -alR /var/lib/SealFS
