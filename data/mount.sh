#!/bin/bash
echo "[+] START SECube mount"

sudo mkdir /media/SECube
sudo mount -t vfat /dev/sdc1 /media/SECube

echo "[+] END SECube mount"