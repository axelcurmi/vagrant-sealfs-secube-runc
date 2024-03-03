# Runtime Verification for Trustworthy Computing

## Pre-requisites
1. VirtualBox + VirtualBox Extension Pack installed
2. SSH key set with GitHub account and private key copied to `data/dot-ssh` directory
3. Access to the following repositories:
    - https://github.com/axelcurmi/sealfs-fork
    - https://github.com/robert-abela/GKE

## Useful commands
```bash
vagrant up      # to create VM
vagrant ssh     # to SSH into the VM using the user 'vagrant'
vagrant destroy # to destroy the VM

# Once inside the VM
/data/bootstrap.sh      # a sets up the whole setup (i.e., SealFS, GKE via runc)
/data/mount-secube.sh   # mounts the SEcube into '/media/SECube'
/data/umount-secube.sh  # unmounts the SECube
/data/prep-sealfs.sh    # executes the 'prep' tool from the SealFS toolkit (keystream size needs to be provided as argument)
/data/verify-sealfs.sh  # executes the 'verify' tool from the SealFS toolit
/data/mount-sealfs.sh   # mounts the SealFS into '/var/log/GKE'
/data/umount-sealfs.sh  # unmounts the SealFS

# SealFS
# by default the VM will be prepared with SealFS keys; however, these were not generated via the SECube
sudo rm /var/lib/SealFS/keys/{k1,k2} # to remove the keys
sudo /home/vagrant/sealfs/tools/prep /var/lib/SealFS/logs/.SEALFS.LOG /var/lib/SealFS/keys/k1 /var/lib/SealFS/keys/k2 $KEYSTREAM_SIZE # to regenerate the SealFS keys via SECube hardware randomness
sudo /home/vagrant/sealfs/tools/verify /var/lib/SealFS/logs /var/lib/SealFS/keys/k1 /var/lib/SealFS/keys/k2 # to verify the hooked logs (need to umount the SealFS directory first)

# Running the GKE runc container
(cd /home/vagrant/GKE/runc)
ip a # and take note of the VM's IP
sudo runc run gke

# Once inside the runc container
./chat_hooked --id <ID> --repeater <IP> --pin <PIN> # to run the hooked chat application with SECube
```

## Setup command order
```bash
vagrant up
vagrant ssh

# Once inside the VM
/data/bootstrap.sh
/data/mount-secube.sh
/data/prep-sealfs.sh 100000
/data/mount-sealfs.sh

cd ~/GKE/runc
sudo runc run gke

# Once inside the runc
./chat_hooked --id 1 --repeater 10.0.2.15 --pin test

# ... perform chat operations ...

/data/umount-sealfs.sh
/data/umount-secube.sh
/data/verify-sealfs.sh
```
