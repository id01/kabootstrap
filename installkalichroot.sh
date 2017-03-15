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

# Update Locales
chroot /home/kali/kaliroot sh -c 'locale-gen "en_US.UTF-8"; echo "LANG=en_US.UTF-8" >> /etc/default/locale'

# Create bootkali and modify user to chroot
rm /tmp/bootkali_tmp.c
echo "#define chrootcommand \"sh -c '`which chroot` /home/kali/kaliroot'\"" > /tmp/bootkali_tmp.c
xhost | grep "access control disabled" 2>&1 >/dev/null
echo "#define usesxhost $?" >> /tmp/bootkali_tmp.c
echo "int kaliuid = `sudo -u kali id -u`;" >> /tmp/bootkali_tmp.c
cat bootkali.c >> /tmp/bootkali_tmp.c
gcc /tmp/bootkali_tmp.c -o /home/kali/bootkali
chmod 4755 /home/kali/bootkali
rm /tmp/bootkali_tmp.c
usermod -s /bin/bash kali
echo "exec /home/kali/bootkali" > /home/kali/.bashrc

# Update /etc/fstab
echo -e "\n" >> /etc/fstab
echo "# Kali" >> /etc/fstab
echo -e "/proc\t/home/kali/kaliroot/proc none defaults,bind 0 0" >> /etc/fstab
echo -e "/sys\t/home/kali/kaliroot/sys none defaults,bind 0 0" >> /etc/fstab

# Final message
echo "Done. Use sudo su kali to chroot into kali"
echo "Note: Setting a password for the kali user is not a good idea."
