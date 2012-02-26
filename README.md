# Archlinux Ultimate Install Script

Install and configure archlinux has never been easier!

You can try it first with a `virtualbox`

## Prerequisites

- You need to have Archlinux (`base` + `base_devel`) already installed and rebooted
- Git
- A working internet connection
- Logged in as 'root'

## How to use

### With git
- Install git: `pacman -Sy git`
- get the script: `git clone git://github.com/helmuthdu/aui.git`
- run the script: `./aui`

### Without git
- get the script: ` wget --no-check-certificate https://github.com/helmuthdu/aui/tarball/master -O - | tar xz`
- run the script: `./aui`

## What does the script do?

- Automatic configure rc.conf
- Install additional repositories
- Configure rankmirror
- System upgrade
- Create and configure new user
- Install and configure sudo
- Configure pacman package signing
- Install an AUR Helper [yaourt, packer]
- Install base system
- Install Xorg
- Install GPU Drivers
- Install CUPS
- Install Additional wireless/bluetooth firmwares
- Ensuring access to GIT through a firewall
- Install a Desktop Environment [GNOME, KDE, XFCE, LXDE, OpenBox]
- Install Developement tools [Vim, Emacs, Eclipse...]
- Install/Remove Office apps [LibreOffice, GNOME-Office, Latex...]
- Install/Remove System tools [Wine, Virtualbox, Grsync, Htop]
- Install/Remove Graphics apps [Inkscape, Gimp, Blender, MComix]
- Install/Remove Internet apps [Firefox, Google-Chrome, Jdownloader...]
- Install/Remove and configure LAMP Server
- Install/Remove Multimedia apps [Rhythmbox, Clementine, Codecs...]
- Install/Remove Games [HoN, World of Padman, Wesnoth...]
- Install/Remove Fonts [Liberation, MS-Fonts, Google-webfonts...]
- Many More...
