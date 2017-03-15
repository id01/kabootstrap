#!/bin/bash

# Configs!!! YAY!!! :D
ARCH=i386
VERSION=jessie
APTPATH=/etc/apt/sources.list

# Error messages
if [ "$0" != "./installkalichroot.sh" ]; then
	echo "You need to run this script from the directory of the script."
	echo "Like this: ./installkalichroot.sh"
fi
if [ "$1" != "" ]; then
	echo "This script does not take arguments."
fi

# If they have run it before, this script will fail. Which is a very, very good thing.
set -e
echo "This script creates a kali chroot user."
echo "This script must be run as root."
echo "This script will take a while."
echo "This script will make you bored."
echo "This script will fail if you ran it before."
useradd kali
echo "Added user kali. Starting setup process..."
mkdir /home/kali
mkdir /home/kali/kaliroot
set +e
# Install debootstrap if they haven't already, create the chroot
apt-get -y install debootstrap
debootstrap --arch $ARCH $VERSION /home/kali/kaliroot http://deb.debian.org/debian
# Add kali repos and install kali base system
echo "# Kali repositories" >> "/home/kali/kaliroot/$APTPATH"
echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" >> "/home/kali/kaliroot/$APTPATH"
set -e
chroot /home/kali/kaliroot sh -c 'apt-get update && apt-get --force-yes -y install kali-archive-keyring && apt-get update'
set +e
chroot /home/kali/kaliroot sh -c 'apt-get -y install sudo kali-linux' # Install kali base system
chroot /home/kali/kaliroot sh -c 'apt-get -y install kali-linux' # Install twice, just in case...
# Create bootkali and modify user to chroot
rm /tmp/bootkali_tmp.c
echo "#define chrootpath \"`which chroot`\"" > /tmp/bootkali_tmp.c
echo "int kaliuid = `sudo -u kali id -u`;" >> /tmp/bootkali_tmp.c
cat bootkali.c >> /tmp/bootkali_tmp.c
gcc /tmp/bootkali_tmp.c -o /home/kali/bootkali
chmod 4755 /home/kali/bootkali
rm /tmp/bootkali_tmp.c
usermod -s /bin/bash kali
echo "exec /home/kali/bootkali" > /home/kali/.bashrc
# Final message
echo "Done. Use sudo su kali to chroot into kali"
echo "Note: Setting a password for the kali user is not a good idea."
