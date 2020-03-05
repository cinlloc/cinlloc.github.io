# Linux's notes
## Fedora
### Can't boot into Fedora: SELinux errors
#### Context
Lost user password on a Fedora installation. Boot on live USB stick and chroot to change password. Changed also groups created a new user.   
#### Description
A bunch of error occurs during boot phase, e.g. `Failed to start Load Kernel Modules.`, and a huge amount of files cannot be read because of SELinux erros: `audit[744]: AVC avc:  denied  { read } for  pid=744 comm="alsactl" name="ld.so.cache" dev="nvme0n1p3" ino=10487091 sconte...`.
#### Root cause
Modifying `/etc/passwd`, `/etc/shadow`, `/etc/group` from a chrooted context changed SELinux labelling?
#### Solution
Force SELinux relabel:
1. Boot without SELinux: on Grub menu, type `e` then add `selinux=0` to `linux...` kernel line
2. Once booted, reboot: relabelling will occur
## Manjaro
### Can’t boot into Manjaro: File ‘/vmlinuz-4.14’ not found.
#### Context
Occurred after an hibernation during a system update.
#### Description
After grub loaded, boot fails with message `Can’t boot into Manjaro: File ‘/vmlinuz-4.14’ not found`.
#### Root cause
Kernel file was accidentally deleted during hibernation.
#### Solution
Re-install kernel:
1. Boot with [manjaro live-usb stick](https://manjaro.org/download/)
2. Chroot on manjaro which is on disk:
* Use [these instructions](https://wiki.manjaro.org/index.php/Restore_the_GRUB_Bootloader) (stop before "Restore Grub" section). In a nutshell:
  * `sudo manjaro-chroot -a`
  * identify manjaro's partition with `lsblk -f`
  * `mount /dev/[partition used for Manjaro system] /mnt`
  * `cd /mnt`
  * Mount a bunch of stuff: 
```
mount -t proc proc /mnt/proc
mount -t sysfs sys /mnt/sys
mount -o bind /dev /mnt/dev
mount --bind /etc/resolv.conf /mnt/etc/resolv.conf
mount -t devpts pts /mnt/dev/pts/
chroot /mnt
```
(if `resolv.conf` mount doesn't work, copy-paste the content from host's file to chrooted one's)

3. `pacman -S linuxXYZ` where XYZ is your kernel version (e.g. `pacman -S linux414`)
4. Reboot
#### Sources
* https://forum.manjaro.org/t/boot-vmlinuz-not-found-after-hibernation/111409
* https://wiki.manjaro.org/index.php/Restore_the_GRUB_Bootloader
* https://superuser.com/questions/1329646/why-do-i-have-to-specify-dns-when-using-chroot
