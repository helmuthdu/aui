#!/bin/bash
#-------------------------------------------------------------------------------
#Created by helmuthdu mailto: helmuthdu[at]gmail[dot]com
#Inspired by Andreas Freitag, aka nexxx script
#-------------------------------------------------------------------------------
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Run this script after your first boot with archlinux (as root)

GNOME=0
ARCHI=`uname -m`

# Automatically detects the system language based on your rc.conf
LOCATION=`cat /etc/rc.conf | sed -n '/LOCALE=/p' | sed '1!d' | cut -c9-13`
LOCATION_KDE=`echo $LOCATION | tr '[:upper:]' '[:lower:]'`
LOCATION_GNOME=`echo $LOCATION | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
LOCATION_LO=`echo $LOCATION | sed 's/_/-/'`

function question_for_answer(){ #{{{
	read -p "$1 [y][n]: " OPTION
	echo ""
} #}}}
function install_status(){ #{{{
	if [ $? -ne 0 ] ; then
		CURRENT_STATUS=-1
	else
		CURRENT_STATUS=1
	fi
} #}}}
function print_line(){ #{{{
	printf "%$(tput cols)s\n"|tr ' ' '-'
} #}}}
function print_title (){ #{{{
	clear
	printf "%$(tput cols)s\n"|tr ' ' '-'
	echo -e "# $1"
	printf "%$(tput cols)s\n"|tr ' ' '-'
	echo ""
} #}}}
function add_new_daemon(){ #{{{
	remove_daemon "$1"
	sed -i '/DAEMONS[=]/s/\(.*\)\>/& '"$1"'/' /etc/rc.conf
} #}}}
function remove_daemon(){ #{{{
	sed -i '/DAEMONS[=]/s/'"$1"' //' /etc/rc.conf
} #}}}
function add_new_module(){ #{{{
	remove_module "$1"
	sed -i '/MODULES[=]/s/\(.*\)\>/& '"$1"'/' /etc/rc.conf
	#sed -i '/MODULES[=]/s/^[^ ]*\>/& '"$1"'/' /etc/rc.conf
} #}}}
function remove_module(){ #{{{
	sed -i '/MODULES[=]/s/'"$1"' //' /etc/rc.conf
} #}}}
function aurhelper_install(){ #{{{
		su -l $USERNAME --command="$AURHELPER -S --noconfirm $1"
} #}}}
function finish_function(){ #{{{
	print_line
	echo "Continue with RETURN"
	read
	clear
} #}}}
function sumary(){ #{{{
	case $CURRENT_STATUS in
		0)
			print_line
			echo "$1 not successfull (Canceled)"
			;;
		-1)
			print_line
			echo "$1 not successfull (Error)"
			;;
		1)
			print_line
			echo "$1 successfull"
			;;
		*)
			print_line
			echo "WRONG ARG GIVEN"
			;;
	esac
} #}}}

#START {{{
	clear
	echo "Welcome to the Ultimate Archlinux install script by helmuthdu"
	echo "Inspired by freitag archlinux helper script install"
	print_line
	echo "Requirements:"
	echo "-> Archlinux installation"
	echo "-> Run script as root user"
	echo "-> Working internet connection"
	print_line
	echo "Script can be canceled all the time with CTRL+C"
	print_line
	echo "OPEN THIS SCRIPTS AND READ ALL OPTIONS BEFORE USE IT"
	echo "Not recommended use this script more then 1 time (create duplicate values)"
	echo "This version is still in BETA. Send bugreports to: "
	echo "helmuthdu at gmail dot com"
	finish_function
#}}}
#LANGUAGE SELECTOR {{{
	print_title "LANGUAGE - https://wiki.archlinux.org/index.php/Locale"
	question_for_answer "Default system language: \"$LOCATION\""
	case "$OPTION" in
		"n")
			read -p "New system language [ex: en_US]: " LOCATION
			LOCATION_KDE=`echo $LOCATION | tr '[:upper:]' '[:lower:]'`
			LOCATION_GNOME=`echo $LOCATION | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
			LOCATION_LO=`echo $LOCATION | sed 's/_/-/'`
			;;
		*)
			;;
	esac
	finish_function
#}}}
#CUSTOM REPOSITORIES {{{
	print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
	question_for_answer "Add custom repositories"
	case "$OPTION" in
		"y")
		#CUSTOM REPOSITORIES {{{
			LOOP=1
			while [ "$LOOP" -ne 0 ]
			do
				print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
				echo "[1] Ayatana"
				echo "[2] Archlinuxfr"
				echo "[3] Add my own custom repo"
				echo ""
				echo "[q] QUIT"
				echo ""
				read -p "Option: " OPTION
				case "$OPTION" in
					1)
						echo -e '[ayatana]\nServer = http://repo.ayatana.info/' >> /etc/pacman.conf
						finish_function
						;;
					2)
						echo -e '\n[archlinuxfr]\nServer = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf
						finish_function
						;;
					3)
						read -p "Repository Name [ex: custom]: " REPONAME
						read -p "Repository Address [ex: file:///media/backup/Archlinux/]: " REPOADDRESS
						echo -e '\n['"$REPONAME"']\nServer = '"$REPOADDRESS"'$arch' >> /etc/pacman.conf
						finish_function
						;;
					*)
						LOOP=0
						;;
				esac
			done
			install_status
			;;
		#}}}
		*)
			CURRENT_STATUS=0
			;;
	esac
	sumary "Custom repositories installation"
	finish_function
#}}}
#RANKMIRROR {{{
	print_title "RANKMIRROR - https://wiki.archlinux.org/index.php/Improve_Pacman_Performance"
	question_for_answer "Choosing the fastest mirror using rankmirror (this can take a while)"
	case "$OPTION" in
		"y")
			cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
			sed -i '/^#\S/ s|#||' /etc/pacman.d/mirrorlist.backup
			rankmirrors -n 5 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
			install_status
			;;
		*)
			CURRENT_STATUS=0
			;;
	esac
	sumary "New mirrorlist creation"
	finish_function
#}}}
#SYSTEM UPDATE {{{
	print_title "UPDATING YOUR SYSTEM"
	pacman -Syu
	read -p "Reboot your system [y][n]: " OPTION
	if [ $OPTION = "y" ]; then
		reboot
		exit 0
	fi
#}}}
#CREATE A NEW USER {{{
	print_title "CREATE USER ACCOUNT"
	read -p "New user name: " USERNAME
	useradd -m -g users -G users,audio,lp,optical,storage,video,wheel,games,power,scanner,network -s /bin/bash $USERNAME
	passwd $USERNAME
	#SET USER AS SUDO #{{{
		pacman -S --noconfirm sudo
		## Uncomment to allow members of group wheel to execute any command
		sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
		## Same thing without a password (not secure)
		#sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//' /etc/sudoers
	#}}}
#}}}
#AUR HELPER {{{
	LOOP=1
	while [ "$LOOP" -ne 0 ]
	do
		print_title "AUR HELPER - https://wiki.archlinux.org/index.php/AUR_Helpers"
		echo "Choose your default AUR helper to install"
		echo "[1] Yaourt"
		echo "[2] Packer"
		echo ""
		read -p "Option: " OPTION
		case "$OPTION" in
			1)
				pacman -S --noconfirm base-devel yajl
				su -l $USERNAME --command="
					wget http://aur.archlinux.org/packages/package-query/package-query.tar.gz;
					tar zxvf package-query.tar.gz;
					cd package-query;
					makepkg --noconfirm -si;
					cd ..;
					rm -fr package-query*
				"
				su -l $USERNAME --command="
					wget http://aur.archlinux.org/packages/yaourt/yaourt.tar.gz;
					tar zxvf yaourt.tar.gz;
					cd yaourt;
					makepkg --noconfirm -si;
					cd ..;
					rm -fr yaourt*
				"
				install_status
				AURHELPER="yaourt"
				LOOP=0
				;;
			2)
				su -l $USERNAME --command="
					wget http://aur.archlinux.org/packages/pa/packer/packer.tar.gz;
					tar zxvf packer.tar.gz;
					cd packer;
					makepkg --noconfirm -si;
					cd ..;
					rm -fr packer*
				"
				su -l $USERNAME --command="
					wget http://aur.archlinux.org/packages/pa/packer/packer.tar.gz;
					tar zxvf packer.tar.gz;
					cd packer;
					makepkg --noconfirm -si;
					cd ..;
					rm -fr packer*
				"
				install_status
				AURHELPER="packer"
				LOOP=0
				;;
			*)
				echo "Wrong option"
				finish_function
				LOOP=1
				;;
		esac
	done
	sumary "AUR Helper installation"
	finish_function
#}}}
#BASE SYSTEM {{{
	print_title "BASH TOOLS - https://wiki.archlinux.org/index.php/Bash"
	pacman -S --noconfirm curl bc rsync mlocate bash-completion vim
	print_title "(UN)COMPRESS TOOLS - https://wiki.archlinux.org/index.php/P7zip"
	pacman -S --noconfirm tar gzip bzip2 unzip unrar p7zip
	print_title "DBUS - https://wiki.archlinux.org/index.php/D-Bus"
	pacman -S --noconfirm dbus
	add_new_daemon "dbus"
	print_title "ACPI - https://wiki.archlinux.org/index.php/ACPI_modules"
	pacman -S --noconfirm acpi acpid
	add_new_daemon "acpid"
	#TLP #{{{
	print_title "TLP - https://wiki.archlinux.org/index.php/TLP"
	question_for_answer "Install TLP (great battery improvement on laptops)"
	case "$OPTION" in
		"y")
			app_install "tlp"
			pacman -S --noconfirm upower
			add_new_daemon "@tlp"
			install_status
			;;
		*)
			CURRENT_STATUS=0
			;;
	esac
	sumary "TLP installation"
	finish_function
	#}}}
	print_title "NTFS/FAT - https://wiki.archlinux.org/index.php/Ntfs"
	pacman -S --noconfirm ntfs-3g ntfsprogs dosfstools
	print_title "SSH - https://wiki.archlinux.org/index.php/Ssh"
	pacman -S --noconfirm rssh openssh
	add_new_daemon "@sshd"
	#configure ssh #{{{
		echo -e "sshd: ALL\n# End of file" > /etc/hosts.allow
		echo -e "ALL: ALL: DENY\n# End of file" > /etc/hosts.deny
		#ssh_conf #{{{
			sed -i '/ListenAddress/s/^#//' /etc/ssh/sshd_config
			sed -i '/SyslogFacility/s/^#//' /etc/ssh/sshd_config
			sed -i '/LogLevel/s/^#//' /etc/ssh/sshd_config
			sed -i '/LoginGraceTime/s/^#//' /etc/ssh/sshd_config
			sed -i '/PermitRootLogin/s/^#//' /etc/ssh/sshd_config
			sed -i '/StrictModes/s/^#//' /etc/ssh/sshd_config
			sed -i '/RSAAuthentication/s/^#//' /etc/ssh/sshd_config
			sed -i '/PubkeyAuthentication/s/^#//' /etc/ssh/sshd_config
			sed -i '/IgnoreRhosts/s/^#//' /etc/ssh/sshd_config
			sed -i '/PermitEmptyPasswords/s/^#//' /etc/ssh/sshd_config
			sed -i '/X11Forwarding/s/^#//' /etc/ssh/sshd_config
			sed -i '/X11Forwarding/s/no/yes/' /etc/ssh/sshd_config
			sed -i '/X11DisplayOffset/s/^#//' /etc/ssh/sshd_config
			sed -i '/X11UseLocalhost/s/^#//' /etc/ssh/sshd_config
			sed -i '/PrintMotd/s/^#//' /etc/ssh/sshd_config
			sed -i '/PrintMotd/s/yes/no/' /etc/ssh/sshd_config
			sed -i '/PrintLastLog/s/^#//' /etc/ssh/sshd_config
			sed -i '/TCPKeepAlive/s/^#//' /etc/ssh/sshd_config
			sed -i '/the setting of/s/^/#/' /etc/ssh/sshd_config
			sed -i '/RhostsRSAAuthentication and HostbasedAuthentication/s/^/#/' /etc/ssh/sshd_config
			sed -i 's/ListenAddress ::/s/^/#/' /etc/ssh/sshd_config
		#}}}
	#}}}
	print_title "SAMBA - https://wiki.archlinux.org/index.php/Samba"
	pacman -S --noconfirm samba
	cp /etc/samba/smb.conf.default /etc/samba/smb.conf
	add_new_daemon "@samba"
	print_title "ALSA - https://wiki.archlinux.org/index.php/Alsa"
	pacman -S --noconfirm alsa-utils alsa-plugins
	sed -i '/MODULES[=]/s/snd-usb-audio//' /etc/rc.conf
	sed -i '/MODULES[=]/s/MODULES[=](/&snd-usb-audio/' /etc/rc.conf
	add_new_daemon "@alsa"
#}}}
#XORG {{{
	print_title "XORG - https://wiki.archlinux.org/index.php/Xorg"
	echo "Installing X-Server (req. for Desktopenvironment, GPU Drivers, Keyboardlayout,...)"
	pacman -S --noconfirm xorg-server xorg-xinit xorg-xkill
	pacman -S --noconfirm xf86-input-evdev xf86-input-synaptics xf86-input-mouse xf86-input-keyboard
	pacman -S --noconfirm mesa
	pacman -S --noconfirm gamin
#}}}
#GRAPHIC CARDS {{{
	print_title "GRAPHIC CARD"
	echo "Select your GPU:"
	echo "[1] Intel"
	echo "[2] ATI"
	echo "[3] nVidia"
	echo "[4] Nouveau"
	echo "[5] Virtualbox"
	echo "[6] Vesa"
	echo ""
	echo "[q] QUIT"
	echo ""
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
			pacman -S --noconfirm libgl xf86-video-intel
			install_status
			sumary "Intel GPU driver installation"
			;;
		2)
			echo "
			[catalyst]
			Server = http://catalyst.apocalypsus.net/repo/catalyst/\$arch" >> /etc/pacman.conf
			pacman -Sy
			pacman -S  --noconfirm catalyst catalyst-utils
			install_status
			sumary "ATI GPU driver installation"
			;;
		3)
			pacman -Rdd --noconfirm libgl
			pacman -S --noconfirm nvidia nvidia-utils
			install_status
			sumary "nVidia GPU driver installation"
			;;
		4)
			pacman -S --noconfirm libgl xf86-video-nouveau nouveau-dri
			modprobe nouveau
			add_new_module "nouveau"
			install_status
			sumary "Nouveau GPU driver installation"
			;;
		5)
			pacman -S --noconfirm virtualbox-archlinux-additions
			modprobe -a vboxguest vboxsf vboxvideo
			add_new_module "vboxguest vboxsf vboxvideo"
			groupadd vboxsf
			gpasswd -a $USERNAME vboxsf
			install_status
			sumary "Virtualbox guest additions (incl. video drivers) installation"
			;;
		6)
			pacman -S --noconfirm xf86-video-vesa
			install_status
			sumary "Vesa GPU driver installation"
			;;
		*)
			CURRENT_STATUS=0
			sumary "GPU drivers installation"
			;;
	esac
	finish_function
#}}}
#CUPS {{{
	print_title "CUPS - https://wiki.archlinux.org/index.php/Cups"
	pacman -S --noconfirm cups ghostscript gsfonts
	pacman -S --noconfirm gutenprint foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-filters hplip splix cups-pdf
	add_new_daemon "@cupsd"
#}}}
#ADDITIONAL FIRMWARE {{{
	print_title "WIRELESS/BLUETOOTH ADDITIONAL DRIVERS - https://wiki.archlinux.org/index.php/Wireless_Setup"
	question_for_answer "Install additional wireless/bluetooth firmwares"
	case "$OPTION" in
		"y")
		#ADDITIONAL FIRMWARE {{{
			LOOP=1
			while [ "$LOOP" -ne 0 ]
			do
				print_title "WIRELESS/BLUETOOTH ADDITIONAL DRIVERS"
				echo "[1] ipw2100"
				echo "[2] ipw2200"
				echo "[3] b43"
				echo "[4] b43legacy"
				echo "[5] broadcom-wl"
				echo "[6] bluez-firmware"
				echo "[7] Tools"
				echo ""
				echo "[q] QUIT"
				echo ""
				read -p "Option: " OPTION
				case "$OPTION" in
					1)
						app_install "ipw2100-fw"
						;;
					2)
						app_install "ipw2200-fw"
						;;
					3)
						app_install "b43-firmware"
						;;
					4)
						app_install "b43-firmware-legacy"
						;;
					5)
						app_install "broadcom-wl"
						;;
					6)
						app_install "bluez-firmware"
						;;
					7)
						app_install "wireless-regdb rfkill crda wpa_supplicant"
						;;
					*)
						LOOP=0
						;;
				esac
			done
			install_status
			;;
		#}}}
		*)
			CURRENT_STATUS=0
			;;
	esac
	sumary "Additional Firmware"
	finish_function
#}}}
#GIT ACCESS THRU A FIREWALL {{{
	print_title "GIT-TOR - https://wiki.archlinux.org/index.php/Tor"
	question_for_answer "Ensuring access to GIT through a firewall (bypass college firewall)"
	case "$OPTION" in
		"y")
			aurhelper_install "gtk-doc openbsd-netcat vidalia privoxy git"
			if [ ! -f /usr/bin/proxy-wrapper ]; then
				echo 'forward-socks5   /               127.0.0.1:9050 .' >> /etc/privoxy/config
				echo -e '#!/bin/bash\nnc.openbsd -xlocalhost:9050 -X5 $*' > /usr/bin/proxy-wrapper
				chmod +x /usr/bin/proxy-wrapper
				echo -e '\nexport GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"' >> /etc/bash.bashrc
				export GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"
				su -l $USERNAME --command="export GIT_PROXY_COMMAND=\"/usr/bin/proxy-wrapper\""
			fi
			pacman -S --noconfirm tor privoxy
			rc.d start tor privoxy
			su -l $USERNAME --command="sudo /etc/rc.d/tor restart"
			su -l $USERNAME --command="sudo /etc/rc.d/privoxy restart"
			add_new_daemon "@tor @privoxy"
			install_status
			;;
		*)
			CURRENT_STATUS=0
			;;
	esac
	sumary "GIT-TOR installation"
	finish_function
#}}}
#DESKTOP ENVIRONMENT {{{
	print_title "DESKTOP ENVIRONMENT - https://wiki.archlinux.org/index.php/Desktop_Environment"
	echo "Choose your desktop-environment:"
	echo "[1] GNOME"
	echo "[2] KDE"
	echo "[3] XFCE"
	echo "[4] LXDE"
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
			#GNOME {{{
			print_title "GNOME - https://wiki.archlinux.org/index.php/GNOME"
			pacman -S --noconfirm gnome gnome-extra
			pacman -S --noconfirm gedit-plugins pulseaudio-gnome gnome-tweak-tool telepathy deja-dup
			pacman -S --noconfirm system-config-printer-gnome
			aurhelper_install "automounter"
			aurhelper_install "nautilus-open-terminal gnome-defaults-list"
			pacman -Rdd --noconfirm sushi
			aurhelper_install "gloobus-sushi-bzr"
			pacman -S --noconfirm gksu gvfs-smb xdg-user-dirs
			#GNOME FAVORITE APPS {{{
			LOOP=1
			while [ "$LOOP" -ne 0 ]
			do
				print_title "FAVORITE GNOME APPS"
				echo "[1] GnomeShell Themes [eOS, Nord, Faience, Dark Shine]"
				echo "[2] GNOME Icons [Faience, Faenza, Elementary]"
				echo "[3] Themes [Zukitwo, Zukini, eGTK, Light, Aldabra]"
				echo "[4] GnomeShell Extensions"
				echo "[5] GNOME Activity Journal"
				echo "[6] Conky + CONKY-colors"
				echo "[7] Hotot"
				echo "[8] Openshot"
				echo "[9] PDFMod"
				echo "[10] Shotwell"
				echo "[11] Guake"
				echo "[12] X-Chat"
				echo "[13] Packagekit"
				echo ""
				echo "[a] ALL"
				echo "[q] QUIT"
				echo ""
				read -p "Option: " OPTION
				case "$OPTION" in
					1)
						aurhelper_install "gnome-shell-theme-faience gnome-shell-theme-nord gnome-shell-theme-eos gnome-shell-theme-dark-shine"
						;;
					2)
						aurhelper_install "faience-icon-theme faenza-cupertino-icon-theme elementary-icons"
						;;
					3)
						aurhelper_install "egtk-bzr"
						aurhelper_install "zukitwo-themes zukini-theme light-themes-bzr gtk-theme-aldabra"
						;;
					4)
						aurhelper_install "gpaste gnome-shell-system-monitor-applet-git gnome-shell-extension-noa11y-git gnome-shell-extension-weather-git gnome-shell-extension-user-theme gnome-shell-extension-workspace-indicator gnome-shell-extension-places-menu gnome-shell-extension-dock gnome-shell-extension-pomodoro gnome-shell-extension-mediaplayer-git"
						;;
					5)
						aurhelper_install "gnome-activity-journal libzeitgeist zeitgeist-datahub zeitgeist-extensions"
						;;
					6)
						aurhelper_install "conky conky-colors"
						add_new_module "coretemp it87 acpi-cpufreq"
						;;
					7)
						aurhelper_install "hotot"
						;;
					8)
						pacman -S --noconfirm openshot
						;;
					9)
						aurhelper_install "pdfmod"
						;;
					10)
						pacman -S --noconfirm shotwell
						;;
					11)
						pacman -S --noconfirm guake
						;;
					12)
						pacman -S --noconfirm xchat
						;;
					13)
						pacman -S --noconfirm gnome-packagekit gnome-settings-daemon-updates
						;;
					"a")
						aurhelper_install "gnome-shell-theme-faience gnome-shell-theme-nord gnome-shell-theme-eos"
						aurhelper_install "faience-icon-theme faenza-cupertino-icon-theme elementary-icons"
						aurhelper_install "egtk-bzr zukitwo-themes zukini-theme light-themes-bzr gtk-theme-aldabra"
						aurhelper_install "gpaste gnome-shell-system-monitor-applet-git gnome-shell-extension-noa11y-git gnome-shell-extension-weather-git gnome-shell-extension-user-theme gnome-shell-extension-workspace-indicator gnome-shell-extension-places-menu gnome-shell-extension-dock gnome-shell-extension-pomodoro gnome-shell-extension-mediaplayer-git"
						aurhelper_install "gnome-activity-journal libzeitgeist zeitgeist-datahub zeitgeist-extensions"
						aurhelper_install "pdfmod"
						aurhelper_install "hotot"
						aurhelper_install "conky conky-colors"
						add_new_module "coretemp it87 acpi-cpufreq"
						pacman -S --noconfirm openshot
						pacman -S --noconfirm shotwell
						pacman -S --noconfirm guake
						pacman -S --noconfirm xchat
						pacman -S --noconfirm gnome-packagekit gnome-settings-daemon-updates
						LOOP=0
						;;
					*)
						LOOP=0
						;;
				esac
				finish_function
			done
			#}}}
			GNOME=1
			add_new_daemon "gdm"
			sumary "GNOME installation"
			finish_function
			#}}}
			;;
		2)
			#KDE {{{
			print_title "KDE - https://wiki.archlinux.org/index.php/KDE"
			pacman -S --noconfirm kde kde-l10n-$LOCATION_KDE
			pacman -Rcsn --noconfirm kdemultimedia-kscd kdemultimedia-juk kdemultimedia-dragonplayer
			pacman -S --noconfirm kdeadmin-system-config-printer-kde xdg-user-dirs
			aurhelper_install "chakra-gtk-config"
			aurhelper_install "oxygen-gtk qtcurve-gtk2 qtcurve-kde4 bespin-svn"
			aurhelper_install "kcm-wacomtablet"
			aurhelper_install "quickaccess-plasmoid plasma-icontasks"
			#FAVORITE KDE APPS {{{
			LOOP=1
			while [ "$LOOP" -ne 0 ]
			do
				print_title "FAVORITE KDE APPS"
				echo "[1] Plasma Themes [Caledonia]"
				echo "[2] KDE Icons [KFaenza]"
				#these 2 themes are also mine :)
				echo "[3] QtCurve Themes [Kawai, Sweet]"
				echo "[4] Choqok"
				echo "[5] K3b"
				echo "[6] Apper"
				echo "[7] Minitube"
				echo "[8] Musique"
				echo "[9] Bangarang"
				echo "[10] Rosa Media Player"
				echo "[11] Digikam"
				echo "[12] Yakuake"
				echo "[13] Speedcrunch"
				echo ""
				echo "[a] ALL"
				echo "[q] QUIT"
				echo ""
				read -p "Option: " OPTION
				case "$OPTION" in
					1)
						aurhelper_install "caledonia-bundle"
						;;
					2)
						aurhelper_install "kfaenza-icon-theme"
						;;
					3)
						#QtCurve Themes #{{{
						wget http://kde-look.org/CONTENT/content-files/144205-Sweet.tar.gz
						wget http://kde-look.org/CONTENT/content-files/141920-Kawai.tar.gz
						tar zxvf 144205-Sweet.tar.gz
						tar zxvf 141920-Kawai.tar.gz
						rm 144205-Sweet.tar.gz
						rm 141920-Kawai.tar.gz
						mkdir -p /home/$USERNAME/.kde4/share/apps/color-schemes
						mv Sweet/Sweet.colors /home/$USERNAME/.kde4/share/apps/color-schemes
						mv Kawai/Kawai.colors /home/$USERNAME/.kde4/share/apps/color-schemes
						mkdir -p /home/$USERNAME/.kde4/share/apps/QtCurve
						mv Sweet/Sweet.qtcurve /home/$USERNAME/.kde4/share/apps/QtCurve
						mv Kawai/Kawai.qtcurve /home/$USERNAME/.kde4/share/apps/QtCurve
						chown -R $USERNAME:users /home/$USERNAME/.kde4
						rm -fr Kawai Sweet
						#}}}
						;;
					4)
						pacman -S --noconfirm choqok
						;;
					5)
						pacman -S --noconfirm k3b dvd+rw-tools
						;;
					6)
						aurhelper_install "apper"
						;;
					7)
						aurhelper_install "minitube"
						;;
					8)
						aurhelper_install "musique"
						;;
					9)
						aurhelper_install "bangarang"
						;;
					10)
						aurhelper_install "rosa-media-player"
						;;
					11)
						pacman -S --noconfirm digikam kipi-plugins
						;;
					12)
						pacman -S --noconfirm yakuake
						aurhelper_install "yakuake-skin-plasma-oxygen-panel"
						;;
					13)
						aurhelper_install "speedcrunch"
						;;
					"a")
						aurhelper_install "caledonia-bundle"
						aurhelper_install "kfaenza-icon-theme"
						#QTCURVE THEMES #{{{
						wget http://kde-look.org/CONTENT/content-files/144205-Sweet.tar.gz
						wget http://kde-look.org/CONTENT/content-files/141920-Kawai.tar.gz
						tar zxvf 144205-Sweet.tar.gz
						tar zxvf 141920-Kawai.tar.gz
						rm 144205-Sweet.tar.gz
						rm 141920-Kawai.tar.gz
						mkdir -p /home/$USERNAME/.kde4/share/apps/color-schemes
						mv Sweet/Sweet.colors /home/$USERNAME/.kde4/share/apps/color-schemes
						mv Kawai/Kawai.colors /home/$USERNAME/.kde4/share/apps/color-schemes
						mkdir -p /home/$USERNAME/.kde4/share/apps/QtCurve
						mv Sweet/Sweet.qtcurve /home/$USERNAME/.kde4/share/apps/QtCurve
						mv Kawai/Kawai.qtcurve /home/$USERNAME/.kde4/share/apps/QtCurve
						chown -R $USERNAME:users /home/$USERNAME/.kde4
						rm -fr Kawai Sweet
						#}}}
						pacman -S --noconfirm choqok
						pacman -S --noconfirm k3b dvd+rw-tools
						aurhelper_install "apper"
						aurhelper_install "minitube"
						aurhelper_install "musique"
						aurhelper_install "bangarang"
						aurhelper_install "rosa-media-player"
						pacman -S --noconfirm digikam kipi-plugins
						pacman -S --noconfirm yakuake
						aurhelper_install "yakuake-skin-plasma-oxygen-panel"
						aurhelper_install "speedcrunch"
						LOOP=0
						;;
					*)
						LOOP=0
						;;
				esac
				finish_function
			done
			#}}}
			GNOME=0
			add_new_daemon "kdm"
			sumary "KDE installation"
			finish_function
			#}}}
			;;
		3)
			#XFCE {{{
			print_title "XFCE - https://wiki.archlinux.org/index.php/Xfce"
			pacman -S --noconfirm xfce4 xfce4-goodies
			pacman -S --noconfirm polkit-gnome gvfs-smb xdg-user-dirs
			aurhelper_install "automounter"
			GNOME=1
			sumary "XFCE installation"
			finish_function
			#}}}
			;;
		4)
			#LXDE {{{
			print_title "LXDE - http://wiki.archlinux.org/index.php/lxde"
			pacman -S --noconfirm lxde
			pacman -S --noconfirm polkit-gnome gvfs gvfs-smb xdg-user-dirs
			pacman -S --noconfirm pm-utils upower
			pacman -S --noconfirm leafpad xarchiver obconf epdfview
			pacman -S --noconfirm galculator
			add_new_daemon "lxdm"
			GNOME=1
			sumary "LXDE Installation"
			finish_function
			#}}}
			;;
	esac
	#NETWORKMANAGER/WICD {{{
	print_title "NETWORK CONNECTION MANAGER"
	echo "[1] Networkmanager"
	echo "[2] Wicd"
	echo ""
	echo "[q] QUIT"
	echo ""
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
			print_title "NETWORKMANAGER - https://wiki.archlinux.org/index.php/Networkmanager"
			if [ "$GNOME" -eq 1 ]; then
				pacman -S --noconfirm networkmanager network-manager-applet
			else
				pacman -S --noconfirm networkmanager kdeplasma-applets-networkmanagement
			fi
			groupadd networkmanager
			gpasswd -a $USERNAME networkmanager
			remove_daemon "network"
			add_new_daemon "@networkmanager"
			install_status
			;;
		2)
			print_title "WICD - https://wiki.archlinux.org/index.php/Wicd"
			if [ "$GNOME" -eq 1 ]; then
				pacman -S --noconfirm wicd wicd-gtk
			else
				aurhelper_install "wicd wicd-kde"
			fi
			remove_daemon "network"
			add_new_daemon "@wicd"
			install_status
			;;
		*)
			CURRENT_STATUS=0
			;;
	esac
	sumary "Network Connection Manager installation"
	finish_function
	#}}}
#}}}
#DEVELOPEMENT {{{
LOOP=1
while [ "$LOOP" -ne 0 ]
do
	print_title "DEVELOPMENT APPS"
	echo "[1] QT-Creator"
	echo "[2] Gvim"
	echo "[3] Emacs"
	echo "[4] Oracle Java"
	echo "[5] IntelliJ IDEA"
	echo "[6] Aptana Studio"
	echo "[7] Netbeans"
	echo "[8] Eclipse"
	echo "[9] Debugger Tools [Valgrind, Gdb, Splint, Tidyhtml, Pyflakes, Jsl]"
	echo "[10] MySQL Workbench"
	echo "[11] Meld"
	echo "[12] Giggle"
	echo ""
	echo "[q] QUIT"
	echo ""
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
			pacman -S --noconfirm qtcreator qt-doc
			mkdir -p /home/$USERNAME/.config/Nokia/qtcreator/styles
			wget http://angrycoding.googlecode.com/svn/branches/qt-creator-monokai-theme/monokai.xml
			mv monokai.xml /home/$USERNAME/.config/Nokia/qtcreator/styles/
			chown -R $USERNAME:users /home/$USERNAME/.config
			;;
		2)
			pacman -Rdd --noconfirm vim
			pacman -S --noconfirm gvim wmctrl ctags
			aurhelper_install "discount"
			#helmuthdu's vimrc
			git clone git://github.com/helmuthdu/vim.git
			mv vim /home/$USERNAME/.vim
			ln -sf /home/$USERNAME/.vim/vimrc /home/$USERNAME/.vimrc
			chown -R $USERNAME:users /home/$USERNAME/.vim
			chown $USERNAME:users /home/$USERNAME/.vimrc
			sed -i '/Icon/s/gvim/vim/g' /usr/share/applications/gvim.desktop
			;;
		3)
			pacman -S --noconfirm emacs
			;;
		4)
			pacman -Rdd --noconfirm jre7-openjdk
			pacman -Rdd --noconfirm jdk7-openjdk
			aurhelper_install "jdk"
			;;
		5)
			pacman -S --noconfirm intellij-idea-community-edition
			;;
		6)
			aurhelper_install "aptana-studio"
			;;
		7)
			pacman -S --noconfirm netbeans
			;;
		8)
			while [ "$LOOP" -ne 0 ]
			do
				print_title "ECLIPSE - https://wiki.archlinux.org/index.php/Eclipse"
				echo "[1] Eclipse Classic"
				echo "[2] Eclipse IDE for C/C++ Developers "
				echo "[3] Android Development Tools for Eclipse"
				echo "[4] Web Development Tools for Eclipse"
				echo "[5] PHP Development Tools for Eclipse"
				echo "[6] Python Development Tools for Eclipse"
				echo "[7] Aptana Studio plugin for Eclipse"
				echo "[8] Vim-like editing plugin for Eclipse"
				echo "[9] Git support plugin for Eclipse"
				echo ""
				echo "[b] BACK"
				echo ""
				read -p "Option: " OPTION
				case "$OPTION" in
					1)
						pacman -S --noconfirm eclipse
						;;
					2)
						pacman -S --noconfirm eclipse-cdt
						;;
					3)
						aurhelper_install "eclipse-android android-apktool android-sdk android-sdk-platform-tools android-udev"
						;;
					4)
						aurhelper_install "eclipse-wtp-wst"
						;;
					5)
						aurhelper_install "eclipse-pdt"
						;;
					6)
						aurhelper_install "eclipse-pydev"
						;;
					7)
						aurhelper_install "eclipse-aptana"
						;;
					8)
						aurhelper_install "eclipse-vrapper"
						;;
					9)
						aurhelper_install "eclipse-egit"
						;;
					*)
						LOOP=0
						;;
				esac
			done
			LOOP=1
			;;
		9)
			pacman -S --noconfirm valgrind gdb splint tidyhtml pyflakes
			aurhelper_install "jsl"
			;;
		10)
			aurhelper_install "mysql-workbench"
			;;
		11)
			pacman -S --noconfirm meld
			;;
		12)
			pacman -S --noconfirm giggle
			;;
		*)
			LOOP=0
			;;
	esac
	finish_function
done
#}}}
#OFFICE {{{
LOOP=1
while [ "$LOOP" -ne 0 ]
do
	print_title "OFFICE APPS"
	echo "[1] LibreOffice"
	echo "[2] GNOME-Office [Abiword, Gnumeric]"
	echo "[3] Latex [Texmaker, Lyx]"
	echo "[4] CHM Viewer"
	echo "[5] Xmind"
	echo "[6] Wunderlist"
	echo "[7] GCStar"
	echo "[8] Zathura (Lightweight PDF Viewer)"
	echo ""
	echo "[q] QUIT"
	echo ""
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
			pacman -S --noconfirm libreoffice-$LOCATION_LO libreoffice-{base,calc,draw,impress,math,writer} libreoffice-extension-presenter-screen libreoffice-extension-pdfimport libreoffice-extension-diagram
			aurhelper_install "hunspell-$LOCATION_GNOME"
			if [ "$GNOME" -eq 1 ]; then
				pacman -S --noconfirm libreoffice-gnome
			else
				pacman -S --noconfirm libreoffice-kde4
			fi
			;;
		2)
			pacman -S --noconfirm gnumeric abiword abiword-plugins
			;;
		3)
			pacman -S --noconfirm texlive-latexextra texlive-langextra
			pacman -S --noconfirm lyx texmaker
			aurhelper_install "abntex"
			aurhelper_install "latex-template-springer latex-template-ieee latex-beamer"
			;;
		4)
			if [ "$GNOME" -eq 1 ]; then
				pacman -S --noconfirm chmsee
			else
				pacman -S --noconfirm kchmviewer
			fi
			;;
		5)
			aurhelper_install "xmind"
			;;
		6)
			aurhelper_install "wunderlist"
			;;
		7)
			pacman -S --noconfirm gcstar
			;;
		8)
			pacman -S --noconfirm zathura
			;;
		*)
			LOOP=0
			;;
	esac
	finish_function
done
#}}}
#SYSTEM TOOLS {{{
LOOP=1
while [ "$LOOP" -ne 0 ]
do
	print_title "SYSTEM TOOLS APPS"
	echo "[1] Htop"
	echo "[2] Grsync"
	echo "[3] Wine"
	echo "[4] Virtualbox"
	echo ""
	echo "[a] ALL"
	echo "[q] QUIT"
	echo ""
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
			pacman -S --noconfirm htop
			;;
		2)
			pacman -S --noconfirm grsync
			;;
		3)
			pacman -S --noconfirm wine wine_gecko winetricks
			;;
		4)
			pacman -S --noconfirm virtualbox virtualbox-additions
			aurhelper_install "virtualbox-ext-oracle"
			modprobe vboxdrv
			groupadd vboxusers
			gpasswd -a $USERNAME vboxusers
			add_new_module "vboxdrv"
			;;
		"a")
			pacman -S --noconfirm htop
			pacman -S --noconfirm grsync
			pacman -S --noconfirm wine wine_gecko winetricks
			pacman -S --noconfirm virtualbox virtualbox-additions
			aurhelper_install "virtualbox-ext-oracle"
			modprobe vboxdrv
			groupadd vboxusers
			gpasswd -a $USERNAME vboxusers
			add_new_module "vboxdrv"
			LOOP=0
			;;
		*)
			LOOP=0
			;;
	esac
	finish_function
done
#}}}
#GRAPHICS {{{
LOOP=1
while [ "$LOOP" -ne 0 ]
do
	print_title "GRAPHICS APPS"
	echo "[1] Inkscape"
	echo "[2] Gimp"
	echo "[3] Gimp-plugins"
	echo "[4] Blender"
	echo "[5] MComix"
	echo ""
	echo "[a] ALL"
	echo "[q] QUIT"
	echo ""
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
			pacman -S --noconfirm inkscape uniconvertor python2-numpy python-lxml
			aurhelper_install "sozi"
			;;
		2)
			pacman -S --noconfirm gimp
			;;
		3)
			aurhelper_install "gimp-paint-studio gimp-resynth gimpfx-foundry gimp-plugin-pandora gimp-plugin-saveforweb"
			;;
		4)
			pacman -S --noconfirm blender
			;;
		5)
			pacman -S --noconfirm mcomix
			;;
		"a")
			pacman -S --noconfirm gimp inkscape uniconvertor python2-numpy python-lxml blender mcomix
			aurhelper_install "gimp-paint-studio gimp-resynth gimpfx-foundry gimp-plugin-pandora gimp-plugin-saveforweb sozi"
			LOOP=0
			;;
		*)
			LOOP=0
			;;
	esac
	finish_function
done
#}}}
#INTERNET {{{
LOOP=1
while [ "$LOOP" -ne 0 ]
do
	print_title "INTERNET APPS"
	echo "[1] Firefox"
	echo "[2] Thunderbird"
	echo "[3] Google-Chrome"
	echo "[4] Jdownloader"
	echo "[5] Google Earth"
	echo "[6] Dropbox"
	echo "[7] Teamviewer"
	echo "[8] Trasmission"
	echo ""
	echo "[a] ALL"
	echo "[q] QUIT"
	echo ""
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
			pacman -S --noconfirm firefox firefox-i18n-$LOCATION_GNOME flashplugin
			;;
		2)
			pacman -S --noconfirm thunderbird thunderbird-i18n-$LOCATION_GNOME
			;;
		3)
			pacman -S --noconfirm flashplugin
			aurhelper_install "google-chrome"
			;;
		4)
			aurhelper_install "jdownloader"
			;;
		5)
			aurhelper_install "google-earth"
			;;
		6)
			if [ "$GNOME" -eq 1 ]; then
				aurhelper_install "nautilus-dropbox"
			else
				aurhelper_install "kfilebox"
			fi
			;;
		7)
			aurhelper_install "teamviewer"
			;;
		8)
			if [ "$GNOME" -eq 1 ]; then
				aurhelper_install "transmission-gtk"
			else
				aurhelper_install "transmission-qt"
			fi
			;;
		"a")
			pacman -S --noconfirm firefox firefox-i18n-$LOCATION_GNOME flashplugin
			pacman -S --noconfirm thunderbird thunderbird-i18n-$LOCATION_GNOME
			aurhelper_install "google-chrome"
			aurhelper_install "jdownloader"
			aurhelper_install "google-earth"
			aurhelper_install "teamviewer"
			if [ "$GNOME" -eq 1 ]; then
				aurhelper_install "nautilus-dropbox"
				aurhelper_install "transmission-gtk"
			else
				aurhelper_install "kfilebox"
				aurhelper_install "transmission-qt"
			fi
			LOOP=0
			;;
		*)
			LOOP=0
			;;
	esac
	finish_function
done
#lamp #{{{
print_title "LAMP SERVER - APACHE, MYSQL & PHP + ADMINER\n# https://wiki.archlinux.org/index.php/LAMP"
question_for_answer "Install LAMP"
case "$OPTION" in
	"y")
		pacman -S --noconfirm apache mysql php php-apache php-mcrypt php-gd
		aurhelper_install "adminer"
		rc.d start httpd mysqld
		/usr/bin/mysql_secure_installation
		echo -e '\n# adminer configuration\nInclude conf/extra/httpd-adminer.conf' >> /etc/httpd/conf/httpd.conf
		echo -e 'application/x-httpd-php		php' >> /etc/httpd/conf/mime.types
		sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
		echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\nAddHandler php5-script php' >> /etc/httpd/conf/httpd.conf
		sed -i 's/DirectoryIndex\ index.html/DirectoryIndex\ index.html\ index.php/g' /etc/httpd/conf/httpd.conf
		sed -i 's/public_html/Sites/g' /etc/httpd/conf/extra/httpd-userdir.conf
		sed -i '/mysqli.so/s/^;//' /etc/php/php.ini
		sed -i '/mysql.so/s/^;//' /etc/php/php.ini
		sed -i '/mcrypt.so/s/^;//' /etc/php/php.ini
		sed -i '/gd.so/s/^;//' /etc/php/php.ini
		sed -i '/skip-networking/s/^/#/' /etc/mysql/my.cnf
		su -l $USERNAME --command="mkdir -p ~/Sites"
		su -l $USERNAME --command="chmod 775 ~/ && chmod -R 775 ~/Sites"
		rc.d restart httpd mysqld
		add_new_daemon "httpd @mysqld"
		install_status
		;;
	*)
		CURRENT_STATUS=0
		;;
esac
echo ""
print_line
echo "The folder \"Sites\" has been created in your home"
echo "You can access your projects at \"http://localhost/~username\""
sumary "LAMP installation"
finish_function
#}}}
#}}}
#MULTIMEDIA {{{
LOOP=1
while [ "$LOOP" -ne 0 ]
do
	print_title "MULTIMEDIA APPS"
	echo "[1] Rhythmbox"
	echo "[2] Exaile"
	echo "[3] Banshee"
	echo "[4] Clementine"
	echo "[5] Amarok"
	echo "[6] Beatbox"
	echo "[7] Nuvola"
	echo "[8] Arista"
	echo "[9] Transmageddon"
	echo "[10] XBMC"
	echo "[11] VLC"
	echo "[12] MIDI Support"
	echo "[13] Codecs"
	echo ""
	echo "[q] QUIT"
	echo ""
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
			pacman -S --noconfirm rhythmbox
			;;
		2)
			pacman -S --noconfirm exaile
			;;
		3)
			pacman -S --noconfirm banshee
			;;
		4)
			pacman -S --noconfirm clementine
			;;
		5)
			pacman -S --noconfirm amarok
			;;
		6)
			aurhelper_install "beatbox-bzr"
			;;
		7)
			aurhelper_install "nuvola-bzr-stable"
			;;
		8)
			aurhelper_install "arista-transcoder"
			;;
		9)
			aurhelper_install "transmageddon"
			;;
		10)
			pacman -S --noconfirm xbmc
			;;
		11)
			pacman -S --noconfirm vlc
			if [ "$GNOME" -eq 0 ]; then
				pacman -S --noconfirm phonon-vlc
			fi
			;;
		12)
			aurhelper_install "timidity++ fluidr3"
			echo -e 'soundfont /usr/share/soundfonts/fluidr3/FluidR3GM.SF2' >> /etc/timidity++/timidity.cfg
			;;
		13)
			pacman -S --noconfirm gstreamer0.10-plugins
			aurhelper_install "libquicktime libdvdread libdvdnav libdvdcss cdrdao"
			if [ "$ARCHI" = "i686" ]; then
				aurhelper_install "codecs"
			else
				aurhelper_install "codecs64"
			fi
			;;
		*)
			LOOP=0
			;;
	esac
	finish_function
done
#}}}
#GAMES {{{
LOOP=1
while [ "$LOOP" -ne 0 ]
do
	print_title "GAMES - https://wiki.archlinux.org/index.php/Games"
	echo "[1] Action/Adventure"
	echo "[2] Arcade/Platformer"
	echo "[3] Dungeon"
	echo "[4] FPS"
	echo "[5] MMO"
	echo "[6] Puzzle"
	echo "[7] Simulation"
	echo "[8] Strategy"
	echo "[9] Racing"
	echo "[10] RPG"
	echo "[11] Emulators"
	echo ""
	echo "[q] QUIT"
	echo ""
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
		#ACTION/ADVENTURE {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "ACTION AND ADVENTURE"
			echo "[1] Astromenace"
			echo "[2] OpenTyrian"
			echo "[3] M.A.R.S."
			echo "[4] Yo Frankie!"
			echo "[5] Counter-Strike 2D"
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					aurhelper_install "astromenace"
					;;
				2)
					aurhelper_install "opentyrian-hg"
					;;
				3)
					aurhelper_install "mars-shooter"
					;;
				4)
					aurhelper_install "yofrankie"
					;;
				5)
					aurhelper_install "counter-strike-2d"
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		2)
		#ARCADE/PLATFORMER {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "ARCADE AND PLATFORMER"
			echo "[1] Opensonic"
			echo "[2] Frogatto"
			echo "[3] Bomberclone"
			echo "[4] Goonies"
			echo "[5] Neverball"
			echo "[6] Super Mario Chronicles"
			echo "[7] X-Moto"
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					aurhelper_install "opensonic"
					;;
				2)
					pacman -S --noconfirm frogatto
					;;
				3)
					pacman -S --noconfirm bomberclone
					;;
				4)
					aurhelper_install "goonies"
					;;
				5)
					pacman -S --noconfirm neverball
					;;
				6)
					pacman -S --noconfirm smc
					;;
				7)
					pacman -S --noconfirm xmoto
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		3)
		#DUNGEON {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "DUNGEON"
			echo "[1] Tales of Maj'Eyal"
			echo "[2] Lost Labyrinth"
			echo "[3] S.C.O.U.R.G.E."
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					aurhelper_install "tome4"
					;;
				2)
					aurhelper_install "lostlabyrinth"
					;;
				3)
					aurhelper_install "scourge"
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		4)
		#FPS {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "FPS"
			echo "[1] World of Padman"
			echo "[2] Warsow"
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					aurhelper_install "worldofpadman"
					;;
				2)
					pacman -S --noconfirm warsow
					;;
				3)
					pacman -S --noconfirm alienarena
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		5)
		#MMO {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "MMO"
			echo "[1] Heroes of Newerth"
			echo "[2] Spiral Knights"
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					aurhelper_install "hon"
					;;
				2)
					aurhelper_install "spiral-knights"
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		6)
		#PUZZLE {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "PUZZLE"
			echo "[1] Numptyphysics"
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					aurhelper_install "numptyphysics-svn"
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		7)
		#SIMULATION {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "SIMULATION"
			echo "[1] Simultrans"
			echo "[2] Theme Hospital"
			echo "[3] OpenTTD"
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					aurhelper_install "simutrans"
					;;
				2)
					aurhelper_install "corsix-th"
					;;
				3)
					pacman -S --noconfirm openttd
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		8)
		#STRATEGY {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "STRATEGY"
			echo "[1] Wesnoth"
			echo "[3] 0ad"
			echo "[4] Hedgewars"
			echo "[5] Warzone 2100"
			echo "[6] MegaGlest"
			echo "[7] Zod"
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					question_for_answer "Install Devel Version"
					case "$OPTION" in
						"y")
							aurhelper_install "wesnoth-devel"
							;;
						*)
							pacman -S --noconfirm wesnoth
							;;
					esac
					;;
				3)
					aurhelper_install "0ad"
					;;
				4)
					pacman -S --noconfirm hedgewars
					;;
				5)
					pacman -S --noconfirm warzone2100
					;;
				6)
					pacman -S --noconfirm megaglest
					;;
				7)
					aurhelper_install "commander-zod"
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		9)
		#RACING {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "RACING"
			echo "[1] Maniadrive"
			echo "[2] Death Rally"
			echo "[3] SupertuxKart"
			echo "[4] Speed Dreams"
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					aurhelper_install "maniadrive"
					;;
				2)
					aurhelper_install "death-rally"
					;;
				3)
					pacman -S --noconfirm supertuxkart
					;;
				4)
					pacman -S --noconfirm speed-dreams
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		10)
		#RPG {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "RPG"
			echo "[1] Ardentryst"
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					aurhelper_install "ardentryst"
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		11)
		#RPG {{{
		while [ "$LOOP" -ne 0 ]
		do
			print_title "RPG"
			echo "[1] ZSNES"
			echo ""
			echo "[b] BACK"
			echo ""
			read -p "Option: " OPTION
			case "$OPTION" in
				1)
					pacman -S --noconfirm zsnes
					;;
				*)
					LOOP=0
					;;
			esac
		done
		LOOP=1
		;;
		#}}}
		*)
		LOOP=0
		;;
	esac
done
finish_function
#}}}
#FONTS {{{
LOOP=1
while [ "$LOOP" -ne 0 ]
do
	print_title "FONTS - https://wiki.archlinux.org/index.php/Fonts"
	echo "[1] ttf-ms-fonts"
	echo "[2] ttf-dejavu"
	echo "[3] ttf-liberation"
	echo "[4] ttf-kochi-substitute (Japanese Support)"
	echo "[5] ttf-google-webfonts"
	echo "[6] ttf-roboto"
	echo ""
	echo "[a] ALL"
	echo "[q] QUIT"
	echo ""
	read -p "Option: " OPTION
	case "$OPTION" in
		1)
			aurhelper_install "ttf-ms-fonts"
			;;
		2)
			pacman -S --noconfirm ttf-dejavu
			;;
		3)
			pacman -S --noconfirm ttf-liberation
			;;
		4)
			aurhelper_install "ttf-kochi-substitute"
			;;
		5)
			pacman -Rdd --noconfirm ttf-droid
			pacman -Rdd --noconfirm ttf-ubuntu-font-family
			aurhelper_install "ttf-google-webfonts"
			;;
		6)
			aurhelper_install "ttf-roboto"
			;;
		"a")
			pacman -Rdd --noconfirm ttf-droid
			pacman -Rdd --noconfirm ttf-ubuntu-font-family
			aurhelper_install "ttf-ms-fonts ttf-dejavu ttf-liberation ttf-kochi-substitute ttf-roboto ttf-google-webfonts"
			LOOP=0
			;;
		*)
			LOOP=0
			;;
	esac
	finish_function
done
print_title "FONTS CONFIGURATION - https://wiki.archlinux.org/index.php/Font_Configuration"
question_for_answer "Install ubuntu patched (cairo, fontconfig, freetype and libxft) packages"
case "$OPTION" in
	"y")
		pacman -Rdd --noconfirm cairo fontconfig freetype2 libxft
		aurhelper_install "cairo-ubuntu fontconfig-ubuntu freetype2-ubuntu"
		;;
	*)
		CURRENT_STATUS=0
		;;
esac
sumary "Ubuntu Patched Fonts Configuration installation"
finish_function
#}}}
#REBOOT {{{
print_title "INSTALL COMPLETED"
question_for_answer "Reboot now?"
case "$OPTION" in
	"y")
		echo "Thanks for using the Ultimate Arch install script by helmuthdu"
		echo "Your Computer will now restart"
		finish_function
		reboot
		exit 0
		;;
	*)
		echo "Thanks for using the Ultimate Arch install script by helmuthdu"
		exit 0
		;;
esac
#}}}
