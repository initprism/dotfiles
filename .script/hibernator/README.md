# hibernator
Script to automate hibenation setup on archlinux based systems.

<b>make sure you first install the package update-grub.</b>  

```
chmod +x hibernator

sudo systemctl hibernate
```

before running the script We need to determine where to perform disk pauses swap partitions or swap files.   
The current script cannot handle hibernation of the BTRFS partition to the swapfile.  

If a swap file is required, the script can create it and specify the size of the swap file.   

If you want a swap partition, make sure that it is already in place and that /etc/fstab already references it  

All you have to do is run the script with sudo when you're ready.  
This script updates the GRUB command line with the resume option and the resume hook for /etc/mkinitcpio.conf.  
Finally, update the GRUB configuration (you must preinstall this package using update-grub).  

Before rebooting, you can verify that the `GRUB_CMDLINE_LINUX_DEFAULT` variable in /etc/default/grub is set to a valid resume entry.  

If/etc/fstab relies on the appropriately specified swap partition, you must include a reference to the UUID of the swap partition.  

```
GRUB_CMDLINE_LINUX_DEFAULT="... resume=/dev/disk/by-uuid/<our swap partition>"
```
