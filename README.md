## Kabootstrap
This is a simple script to install a kali chroot on a laptop or PC  
(it's actually a debian chroot, with Kali tools)  

## Usage
To install:
```
sudo ./installkalichroot.sh # Then wait... For a very, long time.
```
To start kali chroot:
```
sudo su kali
```

If this script detects X access control on, it will do some extra stuff to get X to work in the chroot.  
If you don't want this, simply delete the line that says 'echo "#define usesxhost $?" >> /tmp/bootkali_tmp.c' in the installkalichroot.sh script