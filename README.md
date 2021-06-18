### Project only accepting patches
This project is not actively developed but *will* accept Pull Requests.

<h1 align="center">
  <a href=https://www.archlinux.org/>Archlinux</a> Ultimate Installer
</h1>
<h4 align="center">Installation & Configuration of archlinux has never been much easier!</h4>

<p align="center">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-green?style=for-the-badge">
  <img src="https://img.shields.io/github/license/helmuthdu/aui?style=for-the-badge">
  <img src="https://img.shields.io/github/issues/helmuthdu/aui?color=violet&style=for-the-badge">
  <img src="https://img.shields.io/github/stars/helmuthdu/aui?style=for-the-badge">
  <img src="https://img.shields.io/github/forks/helmuthdu/aui?color=teal&style=for-the-badge">
</p>

## Note
* You can first try it in a `VirtualMachine`

## Prerequisites

- A working internet connection
- Logged in as 'root'

## Obtaining The Repository
### With git
- Increase cowspace partition: `mount -o remount,size=2G /run/archiso/cowspace`
- Get list of packages and install git: `pacman -Sy git`
- Get the script: `git clone https://github.com/schmetzyannick/aui-no-x.git`

### Without git
- Increase cowspace partition: `mount -o remount,size=2G /run/archiso/cowspace`
- Get the script: ` wget https://github.com/schmetzyannick/aui-no-x/tarball/master -O - | tar xz`
    - an alternate URL (for less typing) is ` wget https://bit.ly/2U4sTRg -O - | tar xz`

## How to use
- FIFO [System Base]: `cd aui-no-x ; ./fifo`
- LILO [The Rest]: `cd aui-no-x ; ./lilo`

## Features
### FIFO SCRIPT
- Configure keymap
- Select editor
- Automatic configure mirrorlist
- Create partition
- Format device
- Install system base
- Configure fstab
- Configure hostname
- Configure timezone
- Configure hardware clock
- Configure locale
- Configure mkinitcpio
- Install/Configure bootloader
- Configure mirrorlist
- Configure root password

### LILO SCRIPT
- Backup all modified files
- Install additional repositories
- Create and configure new user
- Install and configure sudo
- Automatic enable services in systemd
- Install an AUR Helper [trizen, yay...]
- Install Base System
- Install systemd
- Install Preload
- Install Zram
- Install Xorg
- Install GPU Drivers
- Install CUPS
- Install Additional wireless/bluetooth firmwares
- Ensuring access to GIT through a firewall
- Install DE or WM [Cinnamon, Enlightenment, FluxBox, GNOME, i3, KDE, LXDE, OpenBox, XFCE...]
- Install Developement tools [Vim, Emacs, Eclipse...]
- Install Office apps [LibreOffice, GNOME-Office, Latex...]
- Install System tools [Wine, Virtualbox, Grsync, Htop...]
- Install Graphics apps [Inkscape, Gimp, Blender, MComix...]
- Install Internet apps [Firefox, Google-Chrome, Jdownloader...]
- Install Multimedia apps [Rhythmbox, Clementine, Codecs...]
- Install Games [Desura, PlayOnLinux, Steam, Minecraft...]
- Install Fonts [Liberation, MS-Fonts, Google-webfonts...]
- Install and configure Web Servers
- And Many More...


## Thank helmuthdu
If you like my work, please consider a small Paypal donation at helmuthdu@gmail.com :)

## License :scroll:
This project is licenced under the GNU General Public License V3. For more information, see the `LICENSE` file or visit https://www.gnu.org/licenses/gpl-3.0.en.html.
