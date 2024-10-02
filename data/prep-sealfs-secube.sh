#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "usage: $0 keysize";
    exit 1;
fi

KEYSIZE=$1

sudo /home/vagrant/sealfs/tools/secube_prep /var/lib/SealFS/logs/.SEALFS.LOG /var/lib/SealFS/keys/k1 /var/lib/SealFS/keys/k2 $KEYSIZE
ls -alR /var/lib/SealFS
