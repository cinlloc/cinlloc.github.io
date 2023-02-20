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
  * identify manjaro's partition with `lsblk -f`
  * `mount /dev/[partition used for Manjaro system] /mnt`
  * Mount a bunch of stuff: 
```
mount -t proc proc /mnt/proc
mount -t sysfs sys /mnt/sys
mount -o bind /dev /mnt/dev
mount --bind /etc/resolv.conf /mnt/etc/resolv.conf
mount -t devpts pts /mnt/dev/pts/
```
(if `resolv.conf` mount doesn't work, copy-paste the content from host's file to chrooted one's)

  * Eventually, chroot: `chroot /mnt`
  * Note: `manjaro-chroot -a` can help

3. `pacman -Sy linux-latest` (install latest kernel) or `pacman -Syyu` (resume a failed update process)
4. Reboot
#### Sources
* https://forum.manjaro.org/t/boot-vmlinuz-not-found-after-hibernation/111409
* https://wiki.manjaro.org/index.php/Restore_the_GRUB_Bootloader
* https://superuser.com/questions/1329646/why-do-i-have-to-specify-dns-when-using-chroot
* https://webcache.googleusercontent.com/search?q=cache:LmTwqggwd_QJ:https://forum.manjaro.org/t/error-file-boot-vmlinuz-not-found/148554+&cd=1&hl=fr&ct=clnk&gl=fr&client=firefox-b-d

## Ubuntu
### The upgrade needs a total of xxx M free space on disk `/boot`.
#### Context
Occurred when trying to update kernel.
#### Description
When running software updater, have following error:
```
The upgrade needs a total of 25.3 M free space on disk `/boot`.
Please free at least an additional 25.3 M of disk space on `/boot`.
Empty your trash and remove temporary packages of former installations 
using `sudo apt-get clean`.
```
#### Root cause
`/boot` partition full of old kernel configuration files. (can check with `df -h | grep boot`)
#### Solution
Remove uninstalled package files by running: `dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge`
Then restart.
If not sufficient, change initramfs compression: cf. https://bugs.launchpad.net/ubuntu/+source/ubuntu-release-upgrader/+bug/1988299
