# Archlinux Ultimate Install Script

This script is currently in a beta phase, may be instable and kill your cat!

## Prerequisites

- You need to have Archlinux (`base` + `base_devel`) already installed and rebooted
- Git
- A working internet connection
- Logged in as 'root'

## How to use

- Install git `pacman -S git`
- get the script `git clone git://github.com/helmuthdu/aui.git`
- run the script `./aui.sh`

## Changelog

[changelog][changelog.md]

## What does the script do?


- check current language
- Install custom repositories
- Use rankmirror
- Do a system upgrade
- Create a new user
- Install and configure sudo
- Install a AUR Helper [yaourt, packer]
- Install base system
- Install Xorg
- Install GPU Driver
- Install CUPS
- Install Additional wireless/bluetooth firmwares
- Ensuring access to GIT through a firewall
- Install a Desktop Environment [GNOME, KDE, XFCE, LXDE]
- Install Developement tools [Vim, Emacs, Eclipse...]
- Install Office apps [LibreOffice, GNOME-Office, Latex...]
- Install System tools [Wine, Virtualbox, Grsync, Htop]
- Install Graphics apps [Inkscape, Gimp, Blender, MComix]
- Install Internet apps [Firefox, Google-Chrome, Jdownloader...]
- Install and configure LAMP Server
- Install Multimedia apps [Rhythmbox, Clementine, Codecs...]
- Install Games [HoN, World of Padman, Wesnoth...]
- Install Fonts [Liberation, MS-Fonts, Google-webfonts...]
- Automatic configure rc.conf
