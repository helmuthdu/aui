#!/bin/bash
#-------------------------------------------------------------------------------
#Created by helmuthdu mailto: helmuthdu[at]gmail[dot]com
#Contribution: flexiondotorg
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

if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi

#ARCHLINUX U INSTALL {{{
#WELCOME {{{
welcome(){
  clear
  echo -e "${Bold}Welcome to the Archlinux U Install script by helmuthdu${White}"
  print_line
  echo "Requirements:"
  echo "-> Archlinux installation"
  echo "-> Run script as root user"
  echo "-> Working internet connection"
  print_line
  echo "Script can be cancelled at any time with CTRL+C"
  print_line
  echo "http://www.github.com/helmuthdu/aui"
  print_line
  echo -e "\nBackups:"
  print_line
  # backup old configs
  [[ ! -f /etc/pacman.conf.aui ]] && cp -v /etc/pacman.conf /etc/pacman.conf.aui || echo "/etc/pacman.conf.aui";
  [[ -f /etc/ssh/sshd_config.aui ]] && echo "/etc/ssh/sshd_conf.aui";
  [[ -f /etc/sudoers.aui ]] && echo "/etc/sudoers.aui";
  pause_function
  echo ""
}
#}}}
#LOCALE SELECTOR {{{
language_selector(){
  #AUTOMATICALLY DETECTS THE SYSTEM LOCALE {{{
  #automatically detects the system language based on your locale
  LOCALE=`locale | grep LANG | sed 's/LANG=//' | cut -c1-5`
  #KDE #{{{
  if [[ $LOCALE == pt_BR || $LOCALE == en_GB || $LOCALE == zh_CN ]]; then
    LOCALE_KDE=`echo $LOCALE | tr '[:upper:]' '[:lower:]'`
  else
    LOCALE_KDE=`echo $LOCALE | cut -d\_ -f1`
  fi
  #}}}
  #FIREFOX #{{{
  if [[ $LOCALE == pt_BR || $LOCALE == pt_PT || $LOCALE == en_GB || $LOCALE == en_US || $LOCALE == es_AR || $LOCALE == es_CL || $LOCALE == es_ES || $LOCALE == zh_CN ]]; then
    LOCALE_FF=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
  else
    LOCALE_FF=`echo $LOCALE | cut -d\_ -f1`
  fi
  #}}}
  #THUNDERBIRD #{{{
  if [[ $LOCALE == pt_BR || $LOCALE == pt_PT || $LOCALE == en_US || $LOCALE == en_GB || $LOCALE == es_AR || $LOCALE == es_ES || $LOCALE == zh_CN ]]; then
    LOCALE_TB=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
  elif [[ $LOCALE == es_CL ]]; then
    LOCALE_TB="es-es"
  else
    LOCALE_TB=`echo $LOCALE | cut -d\_ -f1`
  fi
  #}}}
  #HUNSPELL #{{{
  if [[ $LOCALE == pt_BR ]]; then
    LOCALE_HS=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
  elif [[ $LOCALE == pt_PT ]]; then
    LOCALE_HS="pt_pt"
  else
    LOCALE_HS=`echo $LOCALE | cut -d\_ -f1`
  fi
  #}}}
  #ASPELL #{{{
  LOCALE_AS=`echo $LOCALE | cut -d\_ -f1`
  #}}}
  #LIBREOFFICE #{{{
  if [[ $LOCALE == pt_BR || $LOCALE == en_GB || $LOCALE == en_US || $LOCALE == zh_CN ]]; then
    LOCALE_LO=`echo $LOCALE | sed 's/_/-/'`
  else
    LOCALE_LO=`echo $LOCALE | cut -d\_ -f1`
  fi
  #}}}
  #}}}
  print_title "LOCALE - https://wiki.archlinux.org/index.php/Locale"
  print_info "Locales are used in Linux to define which language the user uses. As the locales define the character sets being used as well, setting up the correct locale is especially important if the language contains non-ASCII characters."
  read -p "Default system language: \"$LOCALE\" [Y/n]: " OPTION
  case "$OPTION" in
    "n")
      while [[ $OPTION != y ]]; do
        setlocale
        read_input_text "Confirm locale ($LOCALE)"
      done
      sed -i '/'${LOCALE}'/s/^#//' /etc/locale.gen
      locale-gen
      localectl set-locale LANG=${LOCALE_UTF8}
      #KDE #{{{
      if [[ $LOCALE == pt_BR || $LOCALE == en_GB || $LOCALE == zh_CN ]]; then
        LOCALE_KDE=`echo $LOCALE | tr '[:upper:]' '[:lower:]'`
      else
        LOCALE_KDE=`echo $LOCALE | cut -d\_ -f1`
      fi
      #}}}
      #FIREFOX #{{{
      if [[ $LOCALE == pt_BR || $LOCALE == pt_PT || $LOCALE == en_GB || $LOCALE == en_US || $LOCALE == es_AR || $LOCALE == es_CL || $LOCALE == es_ES || $LOCALE == zh_CN ]]; then
        LOCALE_FF=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
      else
        LOCALE_FF=`echo $LOCALE | cut -d\_ -f1`
      fi
      #}}}
      #THUNDERBIRD #{{{
      if [[ $LOCALE == pt_BR || $LOCALE == pt_PT || $LOCALE == en_US || $LOCALE == en_GB || $LOCALE == es_AR || $LOCALE == es_ES || $LOCALE == zh_CN ]]; then
        LOCALE_TB=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
      elif [[ $LOCALE == es_CL ]]; then
        LOCALE_TB="es-es"
      else
        LOCALE_TB=`echo $LOCALE | cut -d\_ -f1`
      fi
      #}}}
      #HUNSPELL #{{{
      if [[ $LOCALE == pt_BR ]]; then
        LOCALE_HS=`echo $LOCALE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
      elif [[ $LOCALE == pt_PT ]]; then
        LOCALE_HS="pt_pt"
      else
        LOCALE_HS=`echo $LOCALE | cut -d\_ -f1`
      fi
      #}}}
      #ASPELL #{{{
      LOCALE_AS=`echo $LOCALE | cut -d\_ -f1`
      #}}}
      #LIBREOFFICE #{{{
      if [[ $LOCALE == pt_BR || $LOCALE == en_GB || $LOCALE == en_US || $LOCALE == zh_CN ]]; then
        LOCALE_LO=`echo $LOCALE | sed 's/_/-/'`
      else
        LOCALE_LO=`echo $LOCALE | cut -d\_ -f1`
      fi
      #}}}
      ;;
    *)
      ;;
  esac
}
#}}}
#SELECT/CREATE USER {{{
select_user(){
  #CREATE NEW USER {{{
  create_new_user(){
    read -p "Username: " username
    username=`echo $username | tr '[:upper:]' '[:lower:]'`
    useradd -m -g users -G wheel -s /bin/bash ${username}
    chfn ${username}
    passwd ${username}
    while [[ $? -ne 0 ]]; do
      passwd ${username}
    done
    pause_function
    configure_user_account
  }
  #}}}
  #CONFIGURE USER ACCOUNT {{{
  configure_user_account(){
    #BASHRC {{{
    print_title "BASHRC - https://wiki.archlinux.org/index.php/Bashrc"
    bashrc_list=("Default" "Vanilla" "Get from github");
    PS3="$prompt1"
    echo -e "Choose your .bashrc\n"
    select OPT in "${bashrc_list[@]}"; do
      case "$REPLY" in
        1)
          package_install "git"
          package_install "colordiff"
          git clone https://github.com/helmuthdu/dotfiles
          cp dotfiles/.bashrc dotfiles/.dircolors dotfiles/.dircolors_256 dotfiles/.nanorc dotfiles/.yaourtrc ~/
          cp dotfiles/.bashrc dotfiles/.dircolors dotfiles/.dircolors_256 dotfiles/.nanorc dotfiles/.yaourtrc /home/${username}/
          rm -fr dotfiles
          ;;
        2)
          cp /etc/skel/.bashrc /home/${username}
          ;;
        3)
          package_install "git"
          read -p "Enter your github username [ex: helmuthdu]: " GITHUB_USER
          read -p "Enter your github repository [ex: aui]: " GITHUB_REPO
          git clone https://github.com/$GITHUB_USER/$GITHUB_REPO
          cp -R $GITHUB_REPO/.* /home/${username}/
          rm -fr $GITHUB_REPO
          ;;
        *)
          invalid_option
          ;;
      esac
      [[ -n $OPT ]] && break
    done
    #}}}
    #EDITOR {{{
    print_title "DEFAULT EDITOR"
    editors_list=("emacs" "nano" "vi" "vim" "neovim" "zile");
    PS3="$prompt1"
    echo -e "Select editor\n"
    select EDITOR in "${editors_list[@]}"; do
      if contains_element "$EDITOR" "${editors_list[@]}"; then
        if [[ $EDITOR == vim || $EDITOR == neovim ]]; then
          [[ $EDITOR == vim ]] && (! is_package_installed "gvim" && package_install "vim ctags") || package_install "neovim python2-neovim python-neovim"
          #VIMRC {{{
          if [[ ! -f /home/${username}/.vimrc ]]; then
            vimrc_list=("Default" "Vanilla" "Get from github");
            PS3="$prompt1"
            echo -e "Choose your .vimrc\n"
            select OPT in "${vimrc_list[@]}"; do
              case "$REPLY" in
                1)
                  package_install "git"
                  git clone https://github.com/helmuthdu/vim /home/${username}/.vim
                  ln -sf /home/${username}/.vim/vimrc /home/${username}/.vimrc
                  cp -R vim /home/${username}/.vim/fonts /home/${username}/.fonts
                  GRUVBOX_NEEDED=1
                  ;;
                3)
                  package_install "git"
                  read -p "Enter your github username [ex: helmuthdu]: " GITHUB_USER
                  read -p "Enter your github repository [ex: vim]: " GITHUB_REPO
                  git clone https://github.com/$GITHUB_USER/$GITHUB_REPO
                  cp -R $GITHUB_REPO/.vim /home/${username}/
                  if [[ -f $GITHUB_REPO/vimrc ]]; then
                    ln -sf /home/${username}/.vim/vimrc /home/${username}/.vimrc
                  else
                    ln -sf /home/${username}/.vim/.vimrc /home/${username}/.vimrc
                  fi
                  rm -fr $GITHUB_REPO
                  ;;
                2)
                  echo "Nothing to do..."
                  ;;
                *)
                  invalid_option
                  ;;
              esac
              [[ -n $OPT ]] && break
            done
          fi
          if [[ $EDITOR == neovim  && ! -f /home/${username}/.config/nvim ]]; then
            mkdir ~/.config
            ln -s ~/.vim ~/.config/nvim
            ln -s ~/.vimrc ~/.config/nvim/init.vim
          fi
          #}}}
        else
          package_install "$EDITOR"
        fi
        break
      else
        invalid_option
      fi
    done
    #}}}
    chown -R ${username}:users /home/${username}
  }
  #}}}
  print_title "SELECT/CREATE USER - https://wiki.archlinux.org/index.php/Users_and_Groups"
  users_list=(`cat /etc/passwd | grep "/home" | cut -d: -f1`);
  PS3="$prompt1"
  echo "Avaliable Users:"
  if [[ $(( ${#users_list[@]} )) -gt 0 ]]; then
    print_warning "WARNING: THE SELECTED USER MUST HAVE SUDO PRIVILEGES"
  else
    echo ""
  fi
  select OPT in "${users_list[@]}" "Create new user"; do
    if [[ $OPT == "Create new user" ]]; then
      create_new_user
    elif contains_element "$OPT" "${users_list[@]}"; then
      username=$OPT
    else
      invalid_option
    fi
    [[ -n $OPT ]] && break
  done
  [[ ! -f /home/${username}/.bashrc ]] && configure_user_account;
  if [[ -n "$http_proxy" ]]; then
      echo "proxy = $http_proxy" > /home/${username}/.curlrc
      chown ${username}:users /home/${username}/.curlrc
  fi
}
#}}}
#CONFIGURE SUDO {{{
configure_sudo(){
  if ! is_package_installed "sudo" ; then
    print_title "SUDO - https://wiki.archlinux.org/index.php/Sudo"
    package_install "sudo"
  fi
  #CONFIGURE SUDOERS {{{
  if [[ ! -f  /etc/sudoers.aui ]]; then
    cp -v /etc/sudoers /etc/sudoers.aui
    ## Uncomment to allow members of group wheel to execute any command
    sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers
    ## Same thing without a password (not secure)
    #sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//' /etc/sudoers

    #This config is especially helpful for those using terminal multiplexers like screen, tmux, or ratpoison, and those using sudo from scripts/cronjobs:
    echo "" >> /etc/sudoers
    echo 'Defaults !requiretty, !tty_tickets, !umask' >> /etc/sudoers
    echo 'Defaults visiblepw, path_info, insults, lecture=always' >> /etc/sudoers
    echo 'Defaults loglinelen=0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth' >> /etc/sudoers
    echo 'Defaults passwd_tries=3, passwd_timeout=1' >> /etc/sudoers
    echo 'Defaults env_reset, always_set_home, set_home, set_logname' >> /etc/sudoers
    echo 'Defaults !env_editor, editor="/usr/bin/vim:/usr/bin/vi:/usr/bin/nano"' >> /etc/sudoers
    echo 'Defaults timestamp_timeout=15' >> /etc/sudoers
    echo 'Defaults passprompt="[sudo] password for %u: "' >> /etc/sudoers
    echo 'Defaults lecture=never' >> /etc/sudoers
  fi
  #}}}
}
#}}}
#AUR HELPER {{{
choose_aurhelper(){
  print_title "AUR HELPER - https://wiki.archlinux.org/index.php/AUR_Helpers"
  print_info "AUR Helpers are written to make using the Arch User Repository more comfortable."
  print_warning "\tNone of these tools are officially supported by Arch devs."
  aurhelper=("yaourt" "apacman" "pacaur")
  PS3="$prompt1"
  echo -e "Choose your default AUR helper to install\n"
  select OPT in "${aurhelper[@]}"; do
    case "$REPLY" in
      1)
        print_title "YAOURT - https://wiki.archlinux.org/index.php/Yaourt"
        print_info "Yaourt (Yet AnOther User Repository Tool) is a community-contributed wrapper for pacman which adds seamless access to the AUR, allowing and automating package compilation and installation from your choice of the thousands of PKGBUILDs in the AUR, in addition to the many thousands of available Arch Linux binary packages."
        if ! is_package_installed "yaourt" ; then
          package_install "base-devel yajl namcap"
          pacman -D --asdeps yajl namcap
          aui_download_packages "package-query yaourt"
          pacman -D --asdeps package-query
          if ! is_package_installed "yaourt" ; then
            echo "Yaourt not installed. EXIT now"
            pause_function
            exit 0
          fi
        fi
        AUR_PKG_MANAGER="yaourt --tmp /var/tmp/"
        ;;
      2)
        if ! is_package_installed "apacman" ; then
          package_install "base-devel git jshon"
          pacman -D --asdeps jshon
          aui_download_packages "apacman"
          if ! is_package_installed "apacman" ; then
            echo "Apacman not installed. EXIT now"
            pause_function
            exit 0
          fi
        fi
        AUR_PKG_MANAGER="apacman"
        ;;
      3)
        if ! is_package_installed "pacaur" ; then
          package_install "base-devel yajl expac"
          pacman -D --asdeps yajl expac
          add_key_user "hkp://pgp.mit.edu 1EB2638FF56C0C53"
	  aui_download_packages "cower pacaur"
          pacman -D --asdeps cower
          if ! is_package_installed "pacaur" ; then
            echo "Pacaur not installed. EXIT now"
            pause_function
            exit 0
          fi
        fi
        AUR_PKG_MANAGER="pacaur"
        ;;
      *)
        invalid_option
        ;;
    esac
    [[ -n $OPT ]] && break
  done
  pause_function
}
#}}}
#AUTOMODE {{{
automatic_mode(){
  print_title "AUTOMODE"
  print_info "Create a custom install with all options pre-selected.\nUse this option with care."
  print_danger "\tUse this mode only if you already know all the option.\n\tYou won't be able to select anything later."
  read_input_text "Enable Automatic Mode"
  if [[ $OPTION == y ]]; then
    $EDITOR ${AUI_DIR}/lilo.automode
    source ${AUI_DIR}/lilo.automode
    echo -e "The installation will start now."
    pause_function
    AUTOMATIC_MODE=1
  fi
}
#}}}
#CUSTOM REPOSITORIES {{{
add_custom_repositories(){
  print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
  read_input_text "Add custom repositories" $CUSTOMREPO
  if [[ $OPTION == y ]]; then
    while true
    do
      print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
      echo " 1) \"Add new repository\""
      echo ""
      echo " d) DONE"
      echo ""
      read -p "$prompt1" OPTION
      case $OPTION in
        1)
          read -p "Repository Name [ex: custom]: " repository_name
          read -p "Repository Address [ex: file:///media/backup/Archlinux]: " repository_addr
          add_repository "${repository_name}" "${repository_addr}" "Never"
          pause_function
          ;;
        "d")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
  fi
}
#}}}
#BASIC SETUP {{{
install_basic_setup(){
  print_title "BASH TOOLS - https://wiki.archlinux.org/index.php/Bash"
  package_install "bc rsync mlocate bash-completion pkgstats arch-wiki-lite"
  pause_function
  print_title "(UN)COMPRESS TOOLS - https://wiki.archlinux.org/index.php/P7zip"
  package_install "zip unzip unrar p7zip lzop cpio"
  pause_function
  print_title "AVAHI - https://wiki.archlinux.org/index.php/Avahi"
  print_info "Avahi is a free Zero Configuration Networking (Zeroconf) implementation, including a system for multicast DNS/DNS-SD discovery. It allows programs to publish and discovers services and hosts running on a local network with no specific configuration."
  package_install "avahi nss-mdns"
  is_package_installed "avahi" && system_ctl enable avahi-daemon
  pause_function
  print_title "ALSA - https://wiki.archlinux.org/index.php/Alsa"
  print_info "The Advanced Linux Sound Architecture (ALSA) is a Linux kernel component intended to replace the original Open Sound System (OSSv3) for providing device drivers for sound cards."
  package_install "alsa-utils alsa-plugins"
  pause_function
  print_title "PULSEAUDIO - https://wiki.archlinux.org/index.php/Pulseaudio"
  print_info "PulseAudio is the default sound server that serves as a proxy to sound applications using existing kernel sound components like ALSA or OSS"
  package_install "pulseaudio pulseaudio-alsa"
  pause_function
  print_title "NTFS/FAT/exFAT/F2FS - https://wiki.archlinux.org/index.php/File_Systems"
  print_info "A file system (or filesystem) is a means to organize data expected to be retained after a program terminates by providing procedures to store, retrieve and update data, as well as manage the available space on the device(s) which contain it. A file system organizes data in an efficient manner and is tuned to the specific characteristics of the device."
  package_install "ntfs-3g dosfstools exfat-utils f2fs-tools fuse fuse-exfat autofs mtpfs"
  pause_function
}
#}}}
#SSH {{{
install_ssh(){
  print_title "SSH - https://wiki.archlinux.org/index.php/Ssh"
  print_info "Secure Shell (SSH) is a network protocol that allows data to be exchanged over a secure channel between two computers."
  read_input_text "Install ssh" $SSH
  if [[ $OPTION == y ]]; then
    package_install "openssh"
    system_ctl enable sshd
    [[ ! -f /etc/ssh/sshd_config.aui ]] && cp -v /etc/ssh/sshd_config /etc/ssh/sshd_config.aui;
    #CONFIGURE SSHD_CONF #{{{
      sed -i '/Port 22/s/^#//' /etc/ssh/sshd_config
      sed -i '/Protocol 2/s/^#//' /etc/ssh/sshd_config
      sed -i '/HostKey \/etc\/ssh\/ssh_host_rsa_key/s/^#//' /etc/ssh/sshd_config
      sed -i '/HostKey \/etc\/ssh\/ssh_host_dsa_key/s/^#//' /etc/ssh/sshd_config
      sed -i '/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/s/^#//' /etc/ssh/sshd_config
      sed -i '/KeyRegenerationInterval/s/^#//' /etc/ssh/sshd_config
      sed -i '/ServerKeyBits/s/^#//' /etc/ssh/sshd_config
      sed -i '/SyslogFacility/s/^#//' /etc/ssh/sshd_config
      sed -i '/LogLevel/s/^#//' /etc/ssh/sshd_config
      sed -i '/LoginGraceTime/s/^#//' /etc/ssh/sshd_config
      sed -i '/PermitRootLogin/s/^#//' /etc/ssh/sshd_config
      sed -i '/HostbasedAuthentication no/s/^#//' /etc/ssh/sshd_config
      sed -i '/StrictModes/s/^#//' /etc/ssh/sshd_config
      sed -i '/RSAAuthentication/s/^#//' /etc/ssh/sshd_config
      sed -i '/PubkeyAuthentication/s/^#//' /etc/ssh/sshd_config
      sed -i '/IgnoreRhosts/s/^#//' /etc/ssh/sshd_config
      sed -i '/PermitEmptyPasswords/s/^#//' /etc/ssh/sshd_config
      sed -i '/AllowTcpForwarding/s/^#//' /etc/ssh/sshd_config
      sed -i '/AllowTcpForwarding no/d' /etc/ssh/sshd_config
      sed -i '/X11Forwarding/s/^#//' /etc/ssh/sshd_config
      sed -i '/X11Forwarding/s/no/yes/' /etc/ssh/sshd_config
      sed -i -e '/\tX11Forwarding yes/d' /etc/ssh/sshd_config
      sed -i '/X11DisplayOffset/s/^#//' /etc/ssh/sshd_config
      sed -i '/X11UseLocalhost/s/^#//' /etc/ssh/sshd_config
      sed -i '/PrintMotd/s/^#//' /etc/ssh/sshd_config
      sed -i '/PrintMotd/s/yes/no/' /etc/ssh/sshd_config
      sed -i '/PrintLastLog/s/^#//' /etc/ssh/sshd_config
      sed -i '/TCPKeepAlive/s/^#//' /etc/ssh/sshd_config
      sed -i '/the setting of/s/^/#/' /etc/ssh/sshd_config
      sed -i '/RhostsRSAAuthentication and HostbasedAuthentication/s/^/#/' /etc/ssh/sshd_config
    #}}}
    pause_function
  fi
}
#}}}
#NFS {{{
install_nfs(){
  print_title "NFS - https://wiki.archlinux.org/index.php/Nfs"
  print_info "NFS allowing a user on a client computer to access files over a network in a manner similar to how local storage is accessed."
  read_input_text "Install nfs" $NFS
  if [[ $OPTION == y ]]; then
    package_install "nfs-utils"
    system_ctl enable rpcbind
    system_ctl enable nfs-client.target
    system_ctl enable remote-fs.target
    pause_function
  fi
}
#}}}
#ZSH {{{
install_zsh(){
  print_title "ZSH - https://wiki.archlinux.org/index.php/Zsh"
  print_info "Zsh is a powerful shell that operates as both an interactive shell and as a scripting language interpreter. "
  read_input_text "Install zsh" $ZSH
  if [[ $OPTION == y ]]; then
    package_install "zsh"
    read_input_text "Install oh-my-zsh" $OH_MY_ZSH
    if [[ $OPTION == y ]]; then
      if [[ -f /home/${username}/.zshrc ]]; then
        read_input_text "Replace current .zshrc file"
        if [[ $OPTION == y ]]; then
          run_as_user "mv /home/${username}/.zshrc /home/${username}/.zshrc.bkp"
          run_as_user "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\""
          run_as_user "$EDITOR /home/${username}/.zshrc"
        fi
      else
        run_as_user "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\""
        run_as_user "$EDITOR /home/${username}/.zshrc"
      fi
    fi
    pause_function
  fi
}
#}}}
#SAMBA {{{
install_samba(){
  print_title "SAMBA - https://wiki.archlinux.org/index.php/Samba"
  print_info "Samba is a re-implementation of the SMB/CIFS networking protocol, it facilitates file and printer sharing among Linux and Windows systems as an alternative to NFS."
  read_input_text "Install Samba" $SAMBA
  if [[ $OPTION == y ]]; then
    package_install "samba smbnetfs"
    [[ ! -f /etc/samba/smb.conf ]] && cp /etc/samba/smb.conf.default /etc/samba/smb.conf
    local CONFIG_SAMBA=`cat /etc/samba/smb.conf | grep usershare`
    if [[ -z $CONFIG_SAMBA ]]; then
      # configure usershare
      export USERSHARES_DIR="/var/lib/samba/usershare"
      export USERSHARES_GROUP="sambashare"
      mkdir -p ${USERSHARES_DIR}
      groupadd ${USERSHARES_GROUP}
      chown root:${USERSHARES_GROUP} ${USERSHARES_DIR}
      chmod 1770 ${USERSHARES_DIR}
      sed -i -e '/\[global\]/a\\n   usershare path = /var/lib/samba/usershare\n   usershare max shares = 100\n   usershare allow guests = yes\n   usershare owner only = False' /etc/samba/smb.conf
      sed -i -e '/\[global\]/a\\n   socket options = IPTOS_LOWDELAY TCP_NODELAY SO_KEEPALIVE\n   write cache size = 2097152\n   use sendfile = yes\n' /etc/samba/smb.conf
      usermod -a -G ${USERSHARES_GROUP} ${username}
      sed -i '/user_allow_other/s/^#//' /etc/fuse.conf
      modprobe fuse
    fi
    echo "Enter your new samba account password:"
    pdbedit -a -u ${username}
    while [[ $? -ne 0 ]]; do
      pdbedit -a -u ${username}
    done
    # enable services
    system_ctl enable smbd
    system_ctl enable nmbd
    pause_function
  fi
}
#}}}
#READAHEAD {{{
enable_readahead(){
  print_title "Readahead - https://wiki.archlinux.org/index.php/Improve_Boot_Performance"
  print_info "Systemd comes with its own readahead implementation, this should in principle improve boot time. However, depending on your kernel version and the type of your hard drive, your mileage may vary (i.e. it might be slower)."
  read_input_text "Enable Readahead" $READAHEAD
  if [[ $OPTION == y ]]; then
    system_ctl enable systemd-readahead-collect
    system_ctl enable systemd-readahead-replay
    pause_function
  fi
}
#}}}
#ZRAM {{{
install_zram (){
  print_title "ZRAM - https://wiki.archlinux.org/index.php/Maximizing_Performance"
  print_info "Zram creates a device in RAM and compresses it. If you use for swap means that part of the RAM can hold much more information but uses more CPU. Still, it is much quicker than swapping to a hard drive. If a system often falls back to swap, this could improve responsiveness. Zram is in mainline staging (therefore its not stable yet, use with caution)."
  read_input_text "Install Zram" $ZRAM
  if [[ $OPTION == y ]]; then
    aur_package_install "zramswap"
    system_ctl enable zramswap
    pause_function
  fi
}
#}}}
#TLP {{{
install_tlp(){
  print_title "TLP - https://wiki.archlinux.org/index.php/Tlp"
  print_info "TLP is an advanced power management tool for Linux. It is a pure command line tool with automated background tasks and does not contain a GUI."
  read_input_text "Install TLP" $TLP
  if [[ $OPTION == y ]]; then
    package_install "tlp"
    system_ctl enable tlp
    system_ctl enable tlp-sleep
    system_ctl disable systemd-rfkill
    tlp start
    pause_function
  fi
}
#}}}
#XORG {{{
install_xorg(){
  print_title "XORG - https://wiki.archlinux.org/index.php/Xorg"
  print_info "Xorg is the public, open-source implementation of the X window system version 11."
  echo "Installing X-Server (req. for Desktopenvironment, GPU Drivers, Keyboardlayout,...)"
  package_install "xorg-server xorg-apps xorg-server-xwayland xorg-xinit xorg-xkill xorg-xinput xf86-input-libinput"
  package_install "mesa"
  modprobe uinput
  pause_function
}
#}}}
#FONT CONFIGURATION {{{
font_config(){
  print_title "FONTS CONFIGURATION - https://wiki.archlinux.org/index.php/Font_Configuration"
  print_info "Fontconfig is a library designed to provide a list of available fonts to applications, and also for configuration for how fonts get rendered."
  read_input_text "Install Fontconfig" $FONTCONFIG
  if [[ $OPTION == y ]]; then
    pacman -S --asdeps --needed cairo fontconfig freetype2
    pause_function
  fi
}
#}}}
#VIDEO CARDS {{{
install_video_cards(){
  package_install "dmidecode"
  print_title "VIDEO CARD"
  check_vga
  #Virtualbox {{{
  if [[ ${VIDEO_DRIVER} == virtualbox ]]; then
    package_install "virtualbox-guest-modules-arch virtualbox-guest-utils mesa-libgl"
    add_module "vboxguest vboxsf vboxvideo" "virtualbox-guest"
    add_user_to_group ${username} vboxsf
    system_ctl disable ntpd
    system_ctl enable vboxservice
  #}}}
  #VMware {{{
  elif [[ ${VIDEO_DRIVER} == vmware ]]; then
    package_install "xf86-video-vmware xf86-input-vmmouse open-vm-tools"
    cat /proc/version > /etc/arch-release
    system_ctl disable ntpd
    system_ctl enable vmtoolsd
  #}}}
  #Bumblebee {{{
  elif [[ ${VIDEO_DRIVER} == bumblebee ]]; then
    XF86_DRIVERS=$(pacman -Qe | grep xf86-video | awk '{print $1}')
    [[ -n $XF86_DRIVERS ]] && pacman -Rcsn $XF86_DRIVERS
    pacman -S --needed xf86-video-intel bumblebee nvidia
    [[ ${ARCHI} == x86_64 ]] && pacman -S --needed lib32-virtualgl lib32-nvidia-utils
    replace_line '*options nouveau modeset=1' '#options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
    replace_line '*MODULES="nouveau"' '#MODULES="nouveau"' /etc/mkinitcpio.conf
    mkinitcpio -p linux
    add_user_to_group ${username} bumblebee
  #}}}
  #NVIDIA {{{
  elif [[ ${VIDEO_DRIVER} == nvidia ]]; then
    XF86_DRIVERS=$(pacman -Qe | grep xf86-video | awk '{print $1}')
    [[ -n $XF86_DRIVERS ]] && pacman -Rcsn $XF86_DRIVERS
    pacman -S --needed nvidia{,-utils}
    [[ ${ARCHI} == x86_64 ]] && pacman -S --needed lib32-nvidia-utils
    replace_line '*options nouveau modeset=1' '#options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
    replace_line '*MODULES="nouveau"' '#MODULES="nouveau"' /etc/mkinitcpio.conf
    mkinitcpio -p linux
    nvidia-xconfig --add-argb-glx-visuals --allow-glx-with-composite --composite -no-logo --render-accel -o /etc/X11/xorg.conf.d/20-nvidia.conf;
  #}}}
  #Nouveau [NVIDIA] {{{
  elif [[ ${VIDEO_DRIVER} == nouveau ]]; then
    is_package_installed "nvidia" && pacman -Rdds --noconfirm nvidia{,-utils}
    [[ ${ARCHI} == x86_64 ]] && is_package_installed "lib32-nvidia-utils" && pacman -Rdds --noconfirm lib32-nvidia-utils
    [[ -f /etc/X11/xorg.conf.d/20-nvidia.conf ]] && rm /etc/X11/xorg.conf.d/20-nvidia.conf
    package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl libvdpau-va-gl"
    replace_line '#*options nouveau modeset=1' 'options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
    replace_line '#*MODULES="nouveau"' 'MODULES="nouveau"' /etc/mkinitcpio.conf
    mkinitcpio -p linux
  #}}}
  #ATI {{{
  elif [[ ${VIDEO_DRIVER} == ati ]]; then
    is_package_installed "catalyst-total" && pacman -Rdds --noconfirm catalyst-total
    [[ -f /etc/X11/xorg.conf.d/20-radeon.conf ]] && rm /etc/X11/xorg.conf.d/20-radeon.conf
    [[ -f /etc/modules-load.d/catalyst.conf ]] && rm /etc/modules-load.d/catalyst.conf
    [[ -f /etc/X11/xorg.conf ]] && rm /etc/X11/xorg.conf
    package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl mesa-vdpau libvdpau-va-gl"
    add_module "radeon" "ati"
  #}}}
  #Intel {{{
  elif [[ ${VIDEO_DRIVER} == intel ]]; then
    package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl libvdpau-va-gl"
  #}}}
  #Vesa {{{
  else
    package_install "xf86-video-${VIDEO_DRIVER} mesa-libgl libvdpau-va-gl"
  fi
  #}}}
  if [[ ${ARCHI} == x86_64 ]]; then
    is_package_installed "mesa-libgl" && package_install "lib32-mesa-libgl"
    is_package_installed "mesa-vdpau" && package_install "lib32-mesa-vdpau"
  fi
  if is_package_installed "libvdpau-va-gl"; then
    add_line "export VDPAU_DRIVER=va_gl" "/etc/profile"
  fi
  pause_function
}
#}}}
#CUPS {{{
install_cups(){
  print_title "CUPS - https://wiki.archlinux.org/index.php/Cups"
  print_info "CUPS is the standards-based, open source printing system developed by Apple Inc. for Mac OS X and other UNIX-like operating systems."
  read_input_text "Install CUPS (aka Common Unix Printing System)" $CUPS
  if [[ $OPTION == y ]]; then
    package_install "cups cups-filters ghostscript gsfonts"
    package_install "gutenprint foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-filters foomatic-db-ppds foomatic-db-nonfree-ppds hplip splix cups-pdf foomatic-db-gutenprint-ppds"
    system_ctl enable org.cups.cupsd.service
    pause_function
  fi
}
#}}}
#ADDITIONAL FIRMWARE {{{
install_additional_firmwares(){
  print_title "INSTALL ADDITIONAL FIRMWARES"
  read_input_text "Install additional firmwares [Audio,Bluetooth,Scanner,Wireless]" $FIRMWARE
  if [[ $OPTION == y ]]; then
    while true
    do
      print_title "INSTALL ADDITIONAL FIRMWARES"
      echo " 1) $(menu_item "aic94xx-firmware") $AUR"
      echo " 2) $(menu_item "alsa-firmware")"
      echo " 3) $(menu_item "b43-firmware") $AUR"
      echo " 4) $(menu_item "b43-firmware-legacy") $AUR"
      echo " 5) $(menu_item "bfa-firmware") $AUR"
      echo " 6) $(menu_item "bluez-firmware") [Broadcom BCM203x/STLC2300 Bluetooth]"
      echo " 7) $(menu_item "broadcom-wl") $AUR"
      echo " 8) $(menu_item "ipw2100-fw")"
      echo " 9) $(menu_item "ipw2200-fw")"
      echo "10) $(menu_item "libffado") [Fireware Audio Devices]"
      echo "11) $(menu_item "libmtp") [Android Devices]"
      echo "12) $(menu_item "libraw1394") [IEEE1394 Driver]"
      echo ""
      echo " d) DONE"
      echo ""
      FIRMWARE_OPTIONS+=" d"
      read_input_options "$FIRMWARE_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            aur_package_install "aic94xx-firmware"
            ;;
          2)
            package_install "alsa-firmware"
            ;;
          3)
            aur_package_install "b43-firmware"
            ;;
          4)
            aur_package_install "b43-firmware-legacy"
            ;;
          5)
            aur_package_install "bfa-firmware"
            ;;
          6)
            package_install "bluez-firmware"
            ;;
          7)
            aur_package_install "broadcom-wl"
            ;;
          8)
            package_install "ipw2100-fw"
            ;;
          9)
            package_install "ipw2200-fw"
            ;;
          10)
            package_install "libffado"
            ;;
          11)
            package_install "libmtp"
            aur_package_install "android-udev"
            ;;
          12)
            package_install "libraw1394"
            ;;
          "d")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      source sharedfuncs_elihw
    done
  fi
}
#}}}
#DESKTOP ENVIRONMENT {{{
install_desktop_environment(){
  install_icon_theme() { #{{{
    while true
    do
      print_title "GNOME ICONS"
      echo " 1) $(menu_item "numix-icon-theme-git") $AUR"
      echo " 2) $(menu_item "arc-icon-theme-git") $AUR"
      echo ""
      echo " b) BACK"
      echo ""
      ICONS_THEMES+=" b"
      read_input_options "$ICONS_THEMES"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            aur_package_install "numix-icon-theme-git numix-circle-icon-theme-git"
            ;;
          2)
            aur_package_install "arc-icon-theme-git moka-icon-theme-git"
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      source sharedfuncs_elihw
    done
  } #}}}
  install_gtk_theme() { #{{{
    while true
    do
      print_title "GTK2/GTK3 THEMES"
      echo " 1) $(menu_item "gtk-theme-arc-git" "Arc Themes")"
      echo ""
      echo " b) BACK"
      echo ""
      GTK_THEMES+=" b"
      read_input_options "$GTK_THEMES"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            aur_package_install "gtk-theme-arc-git "
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      source sharedfuncs_elihw
    done
  } #}}}
  install_display_manager() { #{{{
    while true
    do
      print_title "DISPLAY MANAGER - https://wiki.archlinux.org/index.php/Display_Manager"
      print_info "A display manager, or login manager, is a graphical interface screen that is displayed at the end of the boot process in place of the default shell."
      echo " 1) $(menu_item "entrance-git" "Entrance") $AUR"
      echo " 2) $(menu_item "gdm" "GDM")"
      echo " 3) $(menu_item "lightdm" "LightDM")"
      echo " 4) $(menu_item "sddm" "SDDM")"
      echo " 5) $(menu_item "slim" "Slim")"
      echo ""
      echo " b) BACK|SKIP"
      echo ""
      DISPLAY_MANAGER+=" b"
      read_input_options "$DISPLAY_MANAGER"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            aur_package_install "entrance-git"
            system_ctl enable entrance
            ;;
          2)
            package_install "gdm"
            system_ctl enable gdm
            ;;
          3)
            if [[ ${KDE} -eq 1 ]]; then
              package_install "lightdm lightdm-kde-greeter"
            else
              package_install "lightdm lightdm-gtk-greeter"
            fi
            system_ctl enable lightdm
            ;;
          4)
            package_install "sddm sddm-kcm"
            system_ctl enable sddm
            sddm --example-config > /etc/sddm.conf
            sed -i 's/Current=/Current=breeze/' /etc/sddm.conf
            sed -i 's/CursorTheme=/CursorTheme=breeze_cursors/' /etc/sddm.conf
            sed -i 's/Numlock=none/Numlock=on/' /etc/sddm.conf
            ;;
          5)
            package_install "slim"
            system_ctl enable slim
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      source sharedfuncs_elihw
    done
  } #}}}
  install_themes() { #{{{
    while true
    do
      print_title "$1 THEMES"
      echo " 1) $(menu_item "numix-circle-icon-theme-git" "Icons Themes") $AUR"
      echo " 2) $(menu_item "gtk-theme-arc-git " "GTK Themes") $AUR"
      echo ""
      echo " d) DONE"
      echo ""
      THEMES_OPTIONS+=" d"
      read_input_options "$THEMES_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            install_icon_theme
            OPT=1
            ;;
          2)
            install_gtk_theme
            OPT=2
            ;;
          "d")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      source sharedfuncs_elihw
    done
  } #}}}
  install_misc_apps() { #{{{
    while true
    do
      print_title "$1 ESSENTIAL APPS"
      echo " 1) $(menu_item "entrance-git gdm lightdm sddm" "Display Manager") $AUR"
      echo " 2) $(menu_item "dmenu")"
      echo " 3) $(menu_item "viewnior")"
      echo " 4) $(menu_item "gmrun")"
      echo " 5) $(menu_item "rxvt-unicode")"
      echo " 6) $(menu_item "squeeze-git") $AUR"
      echo " 7) $(menu_item "thunar")"
      echo " 8) $(menu_item "tint2")"
      echo " 9) $(menu_item "volwheel")"
      echo "10) $(menu_item "xfburn")"
      echo "11) $(menu_item "xcompmgr")"
      echo "12) $(menu_item "zathura")"
      echo "13) $(menu_item "speedtest-cli") $AUR"
      echo ""
      echo " d) DONE"
      echo ""
      MISCAPPS+=" d"
      read_input_options "$MISCAPPS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            install_display_manager
            OPT=1
            ;;
          2)
            package_install "dmenu"
            ;;
          3)
            package_install "viewnior"
            ;;
          4)
            package_install "gmrun"
            ;;
          5)
            package_install "rxvt-unicode"
            ;;
          6)
            aur_package_install "squeeze-git"
            ;;
          7)
            package_install "thunar tumbler"
            ;;
          8)
            package_install "tint2"
            ;;
          9)
            package_install "volwheel"
            ;;
          10)
            package_install "xfburn"
            ;;
          11)
            package_install "xcompmgr transset-df"
            ;;
          12)
            package_install "zathura"
            ;;
          13)
            aur_package_install "speedtest-cli"
            ;;
          "d")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      source sharedfuncs_elihw
    done
  } #}}}

  print_title "DESKTOP ENVIRONMENT|WINDOW MANAGER"
  print_info "A DE provide a complete GUI for a system by bundling together a variety of X clients written using a common widget toolkit and set of libraries.\n\nA window manager is one component of a system's graphical user interface."

  echo -e "Select your DE or WM:\n"
  echo " --- DE ---         --- WM ---"
  echo " 1) Cinnamon        10) Awesome"
  echo " 2) Deepin          11) Fluxbox"
  echo " 3) Enlightenment   12) i3"
  echo " 4) GNOME           13) OpenBox"
  echo " 5) KDE             14) Xmonad"
  echo " 6) LXQT"
  echo " 7) Mate"
  echo " 8) XFCE"
  echo " 9) Budgie"
  echo ""
  echo " b) BACK"
  read_input $DESKTOPENV
  case "$OPTION" in
    1)
      #CINNAMON {{{
      print_title "CINNAMON - https://wiki.archlinux.org/index.php/Cinnamon"
      print_info "Cinnamon is a fork of GNOME Shell, initially developed by Linux Mint. It attempts to provide a more traditional user environment based on the desktop metaphor, like GNOME 2. Cinnamon uses Muffin, a fork of the GNOME 3 window manager Mutter, as its window manager."
      package_install "cinnamon nemo-fileroller nemo-preview"
      # config xinitrc
      config_xinitrc "cinnamon-session"
      CINNAMON=1
      pause_function
      install_display_manager
      install_themes "CINNAMON"
      ;;
      #}}}
    2)
      #DEEPIN {{{
      print_title "DEEPIN - http://www.linuxdeepin.com"
      print_info "The desktop interface and apps feature an intuitive and elegant design. Moving around, sharing and searching etc. has become simply a joyful experience."
      package_install "deepin deepin-extra lightdm-gtk-greeter"
      # config xinitrc
      config_xinitrc "startdde"
      #Tweaks
      pause_function
      system_ctl enable lightdm
      sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-deepin-greeter/' /etc/lightdm/lightdm.conf
      ;;
      #}}}
    3)
      #ENLIGHTENMENT {{{
      print_title "ENLIGHTENMENT - http://wiki.archlinux.org/index.php/Enlightenment"
      print_info "Enlightenment, also known simply as E, is a stacking window manager for the X Window System which can be used alone or in conjunction with a desktop environment such as GNOME or KDE. Enlightenment is often used as a substitute for a full desktop environment."
      package_install "enlightenment terminology"
      package_install "leafpad epdfview"
      package_install "lxappearance"
      # config xinitrc
      config_xinitrc "enlightenment_start"
      pause_function
      install_misc_apps "Enlightenment"
      install_themes "Enlightenment"
      ;;
      #}}}
    4)
      #GNOME {{{
      print_title "GNOME - https://wiki.archlinux.org/index.php/GNOME"
      print_info "GNOME is a desktop environment and graphical user interface that runs on top of a computer operating system. It is composed entirely of free and open source software. It is an international project that includes creating software development frameworks, selecting application software for the desktop, and working on the programs that manage application launching, file handling, and window and task management."
      package_install "gnome gnome-extra gnome-software gnome-initial-setup"
      package_install "deja-dup gedit-plugins gpaste gnome-tweak-tool gnome-power-manager"
      aur_package_install "nautilus-share"
      # remove gnome games
      package_remove "aisleriot atomix four-in-a-row five-or-more gnome-2048 gnome-chess gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-tetravex gnome-taquin swell-foop hitori iagno quadrapassel lightsoff tali"
      # config xinitrc
      config_xinitrc "gnome-session"
      GNOME=1
      pause_function
      install_themes "GNOME"
      #Gnome Display Manager (a reimplementation of xdm)
      system_ctl enable gdm
      ;;
      #}}}
    5)
      #KDE {{{
      print_title "KDE - https://wiki.archlinux.org/index.php/KDE"
      print_info "KDE is an international free software community producing an integrated set of cross-platform applications designed to run on Linux, FreeBSD, Microsoft Windows, Solaris and Mac OS X systems. It is known for its Plasma Desktop, a desktop environment provided as the default working environment on many Linux distributions."
      package_install "plasma kf5 sddm"
      package_install "ark dolphin dolphin-plugins kio-extras kdeconnect quota-tools gwenview kipi-plugins kate kcalc konsole spectacle okular kdeutils-sweeper kwalletmanager"
      is_package_installed "cups" && package_install "print-manager"
      [[ $LOCALE != en_US ]] && package_install "kde-l10n-$LOCALE_KDE"
      # config xinitrc
      config_xinitrc "startkde"
      pause_function
      #KDE CUSTOMIZATION {{{
      while true
      do
        print_title "KDE CUSTOMIZATION"
        echo " 1) $(menu_item "choqok")"
        echo " 2) $(menu_item "digikam")"
        echo " 3) $(menu_item "k3b")"
        echo " 4) $(menu_item "skrooge")"
        echo " 5) $(menu_item "yakuake")"
        echo ""
        echo " d) DONE"
        echo ""
        KDE_OPTIONS+=" d"
        read_input_options "$KDE_OPTIONS"
        for OPT in ${OPTIONS[@]}; do
          case "$OPT" in
            1)
              package_install "choqok"
              ;;
            2)
              package_install "digikam"
              ;;
            3)
              package_install "k3b cdrdao dvd+rw-tools"
              ;;
            4)
              package_install "skrooge"
              ;;
            5)
              package_install "yakuake"
              ;;
            "d")
              break
              ;;
            *)
              invalid_option
              ;;
          esac
        done
        source sharedfuncs_elihw
      done
      #}}}
      system_ctl enable sddm
      sddm --example-config > /etc/sddm.conf
      sed -i 's/Current=/Current=breeze/' /etc/sddm.conf
      sed -i 's/CursorTheme=/CursorTheme=breeze_cursors/' /etc/sddm.conf
      sed -i 's/Numlock=none/Numlock=on/' /etc/sddm.conf
      KDE=1
      ;;
      #}}}
    6)
      #LXQT {{{
      print_title "LXQT - http://wiki.archlinux.org/index.php/lxqt"
      print_info "LXQt is the Qt port and the upcoming version of LXDE, the Lightweight Desktop Environment. It is the product of the merge between the LXDE-Qt and the Razor-qt projects: A lightweight, modular, blazing-fast and user-friendly desktop environment."
      package_install "lxqt openbox oxygen-icons qtcurve"
      package_install "leafpad epdfview"
      mkdir -p /home/${username}/.config/lxqt
      cp /etc/xdg/lxqt/* /home/${username}/.config/lxqt
      mkdir -p /home/${username}/.config/openbox/
      cp /etc/xdg/openbox/{menu.xml,rc.xml,autostart} /home/${username}/.config/openbox/
      chown -R ${username}:users /home/${username}/.config
      # config xinitrc
      config_xinitrc "startlxqt"
      pause_function
      install_misc_apps "LXQT"
      install_themes "LXQT"
      KDE=1
      ;;
      #}}}
    7)
      #MATE {{{
      print_title "MATE - https://wiki.archlinux.org/index.php/Mate"
      print_info "The MATE Desktop Environment is a fork of GNOME 2 that aims to provide an attractive and intuitive desktop to Linux users using traditional metaphors."
      package_install "mate mate-extra"
      # config xinitrc
      config_xinitrc "mate-session"
      pause_function
      install_display_manager
      install_themes "MATE"
      ;;
      #}}}
    8)
      #XFCE {{{
      print_title "XFCE - https://wiki.archlinux.org/index.php/Xfce"
      print_info "Xfce is a free software desktop environment for Unix and Unix-like platforms, such as Linux, Solaris, and BSD. It aims to be fast and lightweight, while still being visually appealing and easy to use."
      package_install "xfce4 xfce4-goodies xarchiver mupdf"
      # config xinitrc
      config_xinitrc "startxfce4"
      pause_function
      install_display_manager
      install_themes "XFCE"
      ;;
      #}}}
    9)
      #BUDGIE {{{
      print_title "BUDGIE - https://wiki.archlinux.org/index.php/Budgie_Desktop"
      print_info "Budgie is the default desktop of Solus Operating System, written from scratch. Besides a more modern design, Budgie can emulate the look and feel of the GNOME 2 desktop."
      package_install "gnome gnome-extra gnome-software gnome-initial-setup telepathy"
      package_install "deja-dup gedit-plugins gpaste gnome-tweak-tool gnome-power-manager"
      package_install "budgie-desktop"
      aur_package_install "nautilus-share"
      # remove gnome games
      package_remove "aisleriot atomix four-in-a-row five-or-more gnome-2048 gnome-chess gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-tetravex gnome-taquin swell-foop hitori iagno quadrapassel lightsoff"
      # config xinitrc
      config_xinitrc "export XDG_CURRENT_DESKTOP=Budgie:GNOME \n budgie-desktop"
      GNOME=1
      pause_function
      install_themes "GNOME"
      #Gnome Display Manager (a reimplementation of xdm)
      system_ctl enable gdm
      ;;
      #}}}
    10)
      #AWESOME {{{
      print_title "AWESOME - http://wiki.archlinux.org/index.php/Awesome"
      print_info "awesome is a highly configurable, next generation framework window manager for X. It is very fast, extensible and licensed under the GNU GPLv2 license."
      package_install "awesome"
      package_install "lxappearance"
      package_install "leafpad epdfview nitrogen"
      if [[ ! -d /home/${username}/.config/awesome/ ]]; then
        mkdir -p /home/${username}/.config/awesome/
        cp /etc/xdg/awesome/rc.lua /home/${username}/.config/awesome/
        chown -R ${username}:users /home/${username}/.config
      fi
      # config xinitrc
      config_xinitrc "awesome"
      pause_function
      install_misc_apps "AWESOME"
      install_themes "AWESOME"
      ;;
      #}}}
    11)
      #FLUXBOX {{{
      print_title "FLUXBOX - http://wiki.archlinux.org/index.php/Fluxbox"
      print_info "Fluxbox is yet another window manager for X11. It is based on the (now abandoned) Blackbox 0.61.1 code, but with significant enhancements and continued development. Fluxbox is very light on resources and fast, yet provides interesting window management tools such as tabbing and grouping."
      package_install "fluxbox menumaker"
      package_install "lxappearance"
      package_install "leafpad epdfview"
      # config xinitrc
      config_xinitrc "startfluxbox"
      install_misc_apps "FLUXBOX"
      install_themes "FLUXBOX"
      pause_function
      ;;
      #}}}
    12)
      #I3 {{{
      print_title "i3 - https://wiki.archlinux.org/index.php/I3"
      print_info "i3 is a dynamic tiling window manager inspired by wmii that is primarily targeted at developers and advanced users. The stated goals for i3 include clear documentation, proper multi-monitor support, a tree structure for windows, and different modes like in vim."
      package_install "i3"
      package_install "dmenu"
      # config xinitrc
      config_xinitrc "i3"
      pause_function
      install_misc_apps "i3"
      install_themes "i3"
      ;;
      #}}}
    13)
      #OPENBOX {{{
      print_title "OPENBOX - http://wiki.archlinux.org/index.php/Openbox"
      print_info "Openbox is a lightweight and highly configurable window manager with extensive standards support."
      package_install "openbox obconf obmenu menumaker"
      package_install "lxappearance"
      package_install "leafpad epdfview nitrogen"
      mkdir -p /home/${username}/.config/openbox/
      cp /etc/xdg/openbox/{menu.xml,rc.xml,autostart} /home/${username}/.config/openbox/
      chown -R ${username}:users /home/${username}/.config
      # config xinitrc
      config_xinitrc "openbox-session"
      pause_function
      install_misc_apps "OPENBOX"
      install_themes "OPENBOX"
      ;;
      #}}}
    14)
      #XMONAD {{{
      print_title "XMONAD - http://wiki.archlinux.org/index.php/Xmonad"
      print_info "xmonad is a tiling window manager for X. Windows are arranged automatically to tile the screen without gaps or overlap, maximizing screen use. Window manager features are accessible from the keyboard: a mouse is optional."
      package_install "xmonad xmonad-contrib"
      # config xinitrc
      config_xinitrc "xmonad"
      pause_function
      install_misc_apps "XMONAD"
      install_themes "XMONAD"
      ;;
      #}}}
    "b")
      break
      ;;
    *)
      invalid_option
      install_desktop_environment
      ;;
  esac
  #COMMON PKGS {{{
    #MTP SUPPORT {{{
    if is_package_installed "libmtp" ; then
      package_install "gvfs-mtp"
    fi
    #}}}
    if [[ ${KDE} -eq 0 ]]; then
      package_install "gvfs gvfs-goa gvfs-afc gvfs-mtp gvfs-google"
      package_install "xdg-user-dirs-gtk"
      package_install "pavucontrol"
      package_install "ttf-bitstream-vera ttf-dejavu"
      aur_package_install "gnome-defaults-list"
      is_package_installed "cups" && package_install "system-config-printer gtk3-print-backends"
      is_package_installed "samba" && package_install "gvfs-smb"
    fi
  #}}}
  #COMMON CONFIG {{{
    # speed up application startup
    mkdir -p ~/.compose-cache
    # D-Bus interface for user account query and manipulation
    system_ctl enable accounts-daemon
    # Improvements
    add_line "fs.inotify.max_user_watches = 524288" "/etc/sysctl.d/99-sysctl.conf"
  #}}}
}
#}}}
#CONNMAN/NETWORKMANAGER/WICD {{{
install_nm_wicd(){
  print_title "NETWORK MANAGER"
  echo " 1) Networkmanager"
  echo " 2) Wicd"
  echo " 3) ConnMan"
  echo ""
  echo " n) NONE"
  echo ""
  read_input $NETWORKMANAGER
  case "$OPTION" in
    1)
      print_title "NETWORKMANAGER - https://wiki.archlinux.org/index.php/Networkmanager"
      print_info "NetworkManager is a program for providing detection and configuration for systems to automatically connect to network. NetworkManager's functionality can be useful for both wireless and wired networks."
      if [[ ${KDE} -eq 1 ]]; then
        package_install "networkmanager dnsmasq plasma-nm networkmanager-qt"
      else
        package_install "networkmanager dnsmasq network-manager-applet nm-connection-editor gnome-keyring"
      fi
      # vpn support
      package_install "networkmanager-openconnect networkmanager-openvpn networkmanager-pptp networkmanager-vpnc"
      # auto update datetime from network
      if is_package_installed "ntp"; then
        package_install "networkmanager-dispatcher-ntpd"
        system_ctl enable NetworkManager-dispatcher.service
      fi
      # power manager support
      is_package_installed "tlp" && package_install "tlp-rdw"
      # network management daemon
      system_ctl enable NetworkManager.service
      pause_function
      ;;
    2)
      print_title "WICD - https://wiki.archlinux.org/index.php/Wicd"
      print_info "Wicd is a network connection manager that can manage wireless and wired interfaces, similar and an alternative to NetworkManager."
      if [[ ${KDE} -eq 1 ]]; then
        aur_package_install "wicd wicd-kde"
      else
        package_install "wicd wicd-gtk"
      fi
      # WICD daemon
      system_ctl enable wicd
      pause_function
      ;;
    3)
      print_title "CONNMAN - https://wiki.archlinux.org/index.php/Connman"
      print_info "ConnMan is an alternative to NetworkManager and Wicd and was created by Intel and the Moblin project for use with embedded devices."
      package_install "connman"
      # ConnMan daemon
      system_ctl enable connman
      pause_function
      ;;
  esac
}
#}}}
#USB 3G MODEM {{{
install_usb_modem(){
  print_title "USB 3G MODEM - https://wiki.archlinux.org/index.php/USB_3G_Modem"
  print_info "A number of mobile telephone networks around the world offer mobile internet connections over UMTS (or EDGE or GSM) using a portable USB modem device."
  read_input_text "Install usb 3G modem support" $USBMODEM
  if [[ $OPTION == y ]]; then
    package_install "usbutils usb_modeswitch"
    if is_package_installed "networkmanager"; then
      package_install "modemmanager"
      [[ ${KDE} -eq 1 ]] && package_install "modemmanager-qt"
      system_ctl enable ModemManager.service
    else
      package_install "wvdial"
    fi
    pause_function
  fi
}
#}}}
#ACCESSORIES {{{
install_accessories_apps(){
  while true
  do
    print_title "ACCESSORIES APPS"
    echo " 1) $(menu_item "catfish")"
    echo " 2) $(menu_item "conky-lua") $AUR"
    echo " 3) $(menu_item "docky") $AUR"
    echo " 4) $(menu_item "galculator") $AUR"
    echo " 5) $(menu_item "pamac-aur" "Pamac") $AUR"
    echo " 6) $(menu_item "pyrenamer") $AUR"
    echo " 7) $(menu_item "enpass-bin") $AUR"
    echo " 8) $(menu_item "shutter hotshots" "$([[ ${KDE} -eq 1 ]] && echo "Hotshots" || echo "Shutter";)")"
    echo " 9) $(menu_item "synapse")"
    echo "10) $(menu_item "tilix-bin") $AUR"
    echo "11) $(menu_item "terminator")"
    echo "12) $(menu_item "unified-remote-server" "Unified Remote")"
    echo ""
    echo " b) BACK"
    echo ""
    ACCESSORIES_OPTIONS+=" b"
    read_input_options "$ACCESSORIES_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          package_install "catfish"
          ;;
        2)
          aur_package_install "conky-lua"
          package_install "lm_sensors"
          sensors-detect --auto
          ;;
        3)
          package_install "docky"
          aur_package_install "dockmanager"
          ;;
        4)
          package_install "galculator"
          ;;
        5)
          aur_package_install "pamac-aur"
          ;;
        6)
          aur_package_install "pyrenamer"
          ;;
        7)
          aur_package_install "enpass-bin"
          ;;
        8)
          if [[ ${KDE} -eq 1 ]]; then
            aur_package_install "hotshots"
          else
            aur_package_install "shutter"
          fi
          ;;
        9)
          package_install "synapse"
          ;;
        10)
          aur_package_install "tilix-bin"
          ;;
        11)
          package_install "terminator"
          ;;
        12)
          aur_package_install "unified-remote-server"
          system_ctl enable urserver
          ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#DEVELOPEMENT {{{
install_development_apps(){
  while true
  do
    print_title "DEVELOPMENT APPS"
    echo " 1) $(menu_item "atom" "Atom")"
    echo " 2) $(menu_item "emacs")"
    echo " 3) $(menu_item "gvim")"
    echo " 4) $(menu_item "meld")"
    echo " 5) $(menu_item "sublime-text") $AUR"
    echo " 6) $(menu_item "sublime-text-dev") $AUR"
    echo " 7) $(menu_item "android-studio" "Android Studio")"
    echo " 8) $(menu_item "intellij-idea-community-edition" "IntelliJ IDEA")"
    echo " 9) $(menu_item "monodevelop")"
    echo "10) $(menu_item "qtcreator")"
    echo "11) $(menu_item "mysql-workbench-gpl" "MySQL Workbench") $AUR"
    echo "12) $(menu_item "jdk7-openjdk" "OpenJDK")"
    echo "13) $(menu_item "jdk" "Oracle JDK") $AUR"
    echo "14) $(menu_item "nodejs")"
    echo ""
    echo " b) BACK"
    echo ""
    DEVELOPMENT_OPTIONS+=" b"
    read_input_options "$DEVELOPMENT_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          package_install "atom"
          ;;
        2)
          package_install "emacs"
          ;;
        3)
          package_remove "vim"
          package_install "gvim ctags"
          ;;
        4)
          package_install "meld"
          ;;
        5)
          aur_package_install "sublime-text"
          ;;
        6)
          aur_package_install "sublime-text-dev"
          ;;
        7)
          aur_package_install "android-sdk android-sdk-platform-tools android-sdk-build-tools android-platform"
          add_user_to_group ${username} sdkusers
          chown -R :sdkusers /opt/android-sdk/
          chmod -R g+w /opt/android-sdk/
          add_line "export ANDROID_HOME=/opt/android-sdk" "/home/${username}/.bashrc"
          aur_package_install "android-studio"
          ;;
        8)
          package_install "intellij-idea-community-edition"
          ;;
        9)
          package_install "monodevelop monodevelop-debugger-gdb"
          ;;
        10)
          package_install "qtcreator"
          ;;
        11)
          aur_package_install "mysql-workbench-gpl"
          ;;
        12)
          package_remove "jdk"
          package_install "jdk8-openjdk icedtea-web"
          ;;
        13)
          package_remove "jre{7,8}-openjdk"
          package_remove "jdk{7,8}-openjdk"
          aur_package_install "jdk"
          ;;
        14)
          package_install "nodejs"
          ;;
        13)
          aur_package_install "visual-studio-code"
          ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#OFFICE {{{
install_office_apps(){
  while true
  do
    print_title "OFFICE APPS"
    echo " 1) $(menu_item "goffice calligra-libs" "$([[ ${KDE} -eq 1 ]] && echo "Caligra" || echo "Abiword + Gnumeric";)")"
    echo " 2) $(menu_item "calibre")"
    echo " 3) $(menu_item "gcstar")"
    echo " 4) $(menu_item "geeknote-git") $AUR"
    echo " 5) $(menu_item "haroopad") $AUR"
    echo " 6) $(menu_item "homebank")"
    echo " 7) $(menu_item "impressive")"
    echo " 8) $(menu_item "texlive-core" "latex")"
    echo " 9) $(menu_item "libreoffice-fresh" "LibreOffice")"
    echo "10) $(menu_item "ocrfeeder")"
    echo "11) $(menu_item "xmind")"
    echo ""
    echo " b) BACK"
    echo ""
    OFFICE_OPTIONS+=" b"
    read_input_options "$OFFICE_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          if [[ ${KDE} -eq 1 ]]; then
            package_install "calligra"
          else
            package_install "gnumeric abiword abiword-plugins"
          fi
          package_install "hunspell hunspell-$LOCALE_HS"
          package_install "aspell aspell-$LOCALE_AS"
          ;;
        2)
          package_install "calibre"
          ;;
        3)
          package_install "gcstar"
          ;;
        4)
          aur_package_install "geeknote-git"
          ;;
        5)
          aur_package_install "haroopad"
          ;;
        6)
          package_install "homebank"
          ;;
        7)
          package_install "impressive"
          ;;
        8)
          package_install "texlive-most"
          if [[ $LOCALE == pt_BR ]]; then
            aur_package_install "abntex"
          fi
          if [[ ${KDE} -eq 0 ]]; then
            package_install "gummi"
          fi
          ;;
        9)
          print_title "LIBREOFFICE - https://wiki.archlinux.org/index.php/LibreOffice"
          package_install "libreoffice-fresh"
          [[ $LOCALE != en_US ]] && package_install "libreoffice-fresh-$LOCALE_LO"
          package_install "hunspell hunspell-$LOCALE_HS"
          package_install "aspell aspell-$LOCALE_AS"
          ;;
        10)
          package_install "ocrfeeder tesseract gocr"
          package_install "aspell aspell-$LOCALE_AS"
          ;;
        11)
          package_install "xmind"
          ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#SYSTEM TOOLS {{{
install_system_apps(){
  while true
  do
    print_title "SYSTEM TOOLS APPS"
    echo " 1) $(menu_item "clamav")"
    echo " 2) $(menu_item "cockpit") $AUR"
    echo " 3) $(menu_item "docker")"
    echo " 4) $(menu_item "firewalld")"
    echo " 5) $(menu_item "gparted")"
    echo " 6) $(menu_item "grsync")"
    echo " 7) $(menu_item "hosts-update") $AUR"
    echo " 8) $(menu_item "htop")"
    echo " 9) $(menu_item "plex-media-server" "Plex") $AUR"
    echo "10) $(menu_item "ufw") $AUR"
    echo "11) $(menu_item "unified-remote-server" "Unified Remote") $AUR"
    echo "12) $(menu_item "virtualbox")"
    echo "13) $(menu_item "wine")"
    echo "14) $(menu_item "netdata")"
    echo "15) $(menu_item "nload")"
    echo ""
    echo " b) BACK"
    echo ""
    SYSTEMTOOLS_OPTIONS+=" b"
    read_input_options "$SYSTEMTOOLS_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          package_install "clamav"
          cp /etc/clamav/clamd.conf.sample /etc/clamav/clamd.conf
          cp /etc/clamav/freshclam.conf.sample /etc/clamav/freshclam.conf
          sed -i '/Example/d' /etc/clamav/freshclam.conf
          sed -i '/Example/d' /etc/clamav/clamd.conf
          system_ctl enable clamd
          freshclam
          ;;
        2)
          aur_package_install "cockpit storaged linux-user-chroot ostree"
          ;;
        3)
          package_install "docker"
          add_user_to_group ${username} docker
          ;;
        4)
          is_package_installed "ufw" && package_remove "ufw"
          is_package_installed "firewalld" && package_remove "firewalld"
          package_install "firewalld"
          system_ctl enable firewalld
          ;;
        5)
          package_install "gparted"
          ;;
        6)
          package_install "grsync"
          ;;
        7)
          aur_package_install "hosts-update"
          hosts-update
          ;;
        8)
          package_install "htop"
          ;;
        9)
          aur_package_install "plex-media-server"
          system_ctl enable plexmediaserver.service
          ;;
        10)
          print_title "UFW - https://wiki.archlinux.org/index.php/Ufw"
          print_info "Ufw stands for Uncomplicated Firewall, and is a program for managing a netfilter firewall. It provides a command line interface and aims to be uncomplicated and easy to use."
          is_package_installed "firewalld" && package_remove "firewalld"
          aur_package_install "ufw gufw"
          system_ctl enable ufw.service
          ;;
        11)
          aur_package_install "unified-remote-server"
          system_ctl enable urserver.service
          ;;
        12)
          #Make sure we are not a VirtualBox Guest
          VIRTUALBOX_GUEST=`dmidecode --type 1 | grep VirtualBox`
          if [[ -z ${VIRTUALBOX_GUEST} ]]; then
            package_install "virtualbox virtualbox-host-dkms virtualbox-guest-iso linux-headers"
            aur_package_install "virtualbox-ext-oracle"
            add_user_to_group ${username} vboxusers
            modprobe vboxdrv vboxnetflt
          else
            cecho "${BBlue}[${Reset}${Bold}!${BBlue}]${Reset} VirtualBox was not installed as we are a VirtualBox guest."
          fi
          ;;
        13)
          package_install "icoutils wine wine_gecko wine-mono winetricks"
          ;;
        14)
          package_install "netdata"
          system_ctl enable netdata.service
          ;;
        15)
          package_install "nload"
          ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#GRAPHICS {{{
install_graphics_apps(){
  while true
  do
    print_title "GRAPHICS APPS"
    echo " 1) $(menu_item "blender")"
    echo " 2) $(menu_item "gimp")"
    echo " 3) $(menu_item "gthumb")"
    echo " 4) $(menu_item "inkscape")"
    echo " 5) $(menu_item "mcomix")"
    echo " 6) $(menu_item "mypaint")"
    echo " 7) $(menu_item "pencil" "Pencil Prototyping Tool") $AUR"
    echo " 8) $(menu_item "scribus")"
    echo " 9) $(menu_item "shotwell")"
    echo "10) $(menu_item "simple-scan")"
    echo ""
    echo " b) BACK"
    echo ""
    GRAPHICS_OPTIONS+=" b"
    read_input_options "$GRAPHICS_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          package_install "blender"
          ;;
        2)
          package_install "gimp"
          ;;
        3)
          package_install "gthumb"
          ;;
        4)
          package_install "inkscape python2-numpy python-lxml"
          ;;
        5)
          package_install "mcomix"
          ;;
        6)
          package_install "mypaint"
          ;;
        7)
          aur_package_install "pencil"
          ;;
        8)
          package_install "scribus"
          ;;
        9)
          package_install "shotwell"
          ;;
        10)
          package_install "simple-scan"
          ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#INTERNET {{{
install_internet_apps(){
  while true
  do
    print_title "INTERNET APPS"
    echo " 1) Browser"
    echo " 2) Download|Fileshare"
    echo " 3) Email|RSS"
    echo " 4) Instant Messaging|IRC"
    echo " 5) Mapping Tools"
    echo " 6) VNC|Desktop Share"
    echo ""
    echo " b) BACK"
    echo ""
    INTERNET_OPTIONS+=" b"
    read_input_options "$INTERNET_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          #BROWSER {{{
          while true
          do
            print_title "BROWSER"
            echo " 1) $(menu_item "google-chrome" "Chrome") $AUR"
            echo " 2) $(menu_item "chromium")"
            echo " 3) $(menu_item "firefox")"
            echo " 4) $(menu_item "midori konqueror" "$([[ ${KDE} -eq 1 ]] && echo "Konqueror" || echo "Midori";)")"
            echo " 5) $(menu_item "opera")"
            echo " 6) $(menu_item "vivaldi") $AUR"
            echo ""
            echo " b) BACK"
            echo ""
            BROWSERS_OPTIONS+=" b"
            read_input_options "$BROWSERS_OPTIONS"
            for OPT in ${OPTIONS[@]}; do
              case "$OPT" in
                1)
                  aur_package_install "google-chrome"
                  ;;
                2)
                  package_install "chromium"
                  ;;
                3)
                  package_install "firefox firefox-i18n-$LOCALE_FF"
                  ;;
                4)
                  if [[ ${KDE} -eq 1 ]]; then
                    package_install "konqueror"
                  else
                    package_install "midori"
                  fi
                  ;;
                5)
                  package_install "opera"
                  ;;
                6)
                  aur_package_install "vivaldi"
                  ;;
                "b")
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            source sharedfuncs_elihw
          done
          #}}}
          OPT=1
          ;;
        2)
          #DOWNLOAD|FILESHARE {{{
          while true
          do
            print_title "DOWNLOAD|FILESHARE"
            echo " 1) $(menu_item "aerofs") $AUR"
            echo " 2) $(menu_item "rslsync" "Resilio Sync") $AUR"
            echo " 3) $(menu_item "deluge")"
            echo " 4) $(menu_item "dropbox") $AUR"
            echo " 5) $(menu_item "flareget") $AUR"
            echo " 6) $(menu_item "jdownloader") $AUR"
            echo " 7) $(menu_item "qbittorrent")"
            echo " 8) $(menu_item "sparkleshare")"
            echo " 9) $(menu_item "spideroak") $AUR"
            echo "10) $(menu_item "transmission-qt transmission-gtk" "Transmission")"
            echo "11) $(menu_item "uget")"
            echo "12) $(menu_item "youtube-dl")"
	    echo "13) $(menu_item "tixati") $AUR"
            echo ""
            echo " b) BACK"
            echo ""
            DOWNLOAD_OPTIONS+=" b"
            read_input_options "$DOWNLOAD_OPTIONS"
            for OPT in ${OPTIONS[@]}; do
              case "$OPT" in
                1)
                  aur_package_install "aerofs"
                  ;;
                2)
                  aur_package_install "rslsync"
                  ;;
                3)
                  package_install "deluge"
                  ;;
                4)
                  aur_package_install "dropbox"
                  ;;
                5)
                  aur_package_install "flareget"
                  ;;
                6)
                  aur_package_install "jdownloader"
                  ;;
                7)
                  package_install "qbittorrent"
                  ;;
                8)
                  package_install "sparkleshare"
                  ;;
                9)
                  aur_package_install "spideroak"
                  ;;
                10)
                  if [[ ${KDE} -eq 1 ]]; then
                    package_install "transmission-qt"
                  else
                    package_install "transmission-gtk"
                  fi
                  if [[ -f /home/${username}/.config/transmission/settings.json ]]; then
                    replace_line '"blocklist-enabled": false' '"blocklist-enabled": true' /home/${username}/.config/transmission/settings.json
                    replace_line "www\.example\.com\/blocklist" "list\.iblocklist\.com\/\?list=bt_level1&fileformat=p2p&archiveformat=gz" /home/${username}/.config/transmission/settings.json
                  fi
                  ;;
                11)
                  package_install "uget"
                  ;;
                12)
                  package_install "youtube-dl"
                  ;;
		13)
		  aur_package_install "tixati"
		  ;;
                "b")
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            source sharedfuncs_elihw
          done
          #}}}
          OPT=2
          ;;
        3)
          #EMAIL {{{
          while true
          do
            print_title "EMAIL|RSS"
            echo " 1) $(menu_item "liferea")"
            echo " 2) $(menu_item "thunderbird")"
            echo ""
            echo " b) BACK"
            echo ""
            EMAIL_OPTIONS+=" b"
            read_input_options "$EMAIL_OPTIONS"
            for OPT in ${OPTIONS[@]}; do
              case "$OPT" in
                1)
                  package_install "liferea"
                  ;;
                2)
                  package_install "thunderbird"
                  [[ LOCALE_TB != en_US ]] && package_install "thunderbird-i18n-$LOCALE_TB"
                  ;;
                "b")
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            source sharedfuncs_elihw
          done
          #}}}
          OPT=3
          ;;
        4)
          #IM|IRC {{{
          while true
          do
            print_title "IM - INSTANT MESSAGING"
            echo " 1) $(menu_item "hexchat konversation" "$([[ ${KDE} -eq 1 ]] && echo "Konversation" || echo "Hexchat";)")"
            echo " 2) $(menu_item "irssi")"
            echo " 3) $(menu_item "pidgin")"
            echo " 4) $(menu_item "skype") $AUR"
            echo " 5) $(menu_item "teamspeak3")"
            echo " 6) $(menu_item "viber") $AUR"
            echo " 7) $(menu_item "telegram-desktop-bin") $AUR"
            echo " 8) $(menu_item "qtox-git") $AUR"
	    echo " 9) $(menu_item "discord") $AUR"
            echo ""
            echo " b) BACK"
            echo ""
            IM_OPTIONS+=" b"
            read_input_options "$IM_OPTIONS"
            for OPT in ${OPTIONS[@]}; do
              case "$OPT" in
                1)
                  if [[ ${KDE} -eq 1 ]]; then
                    package_install "konversation"
                  else
                    package_install "hexchat"
                  fi
                  ;;
                2)
                  package_install "irssi"
                  ;;
                3)
                  package_install "pidgin"
                  ;;
                4)
                  aur_package_install "skype"
                  ;;
                5)
                  package_install "teamspeak3"
                  ;;
                6)
                  aur_package_install "viber"
                  ;;
                7)
                  aur_package_install "telegram-desktop-bin"
                  ;;
                8)
                  aur_package_install "qtox-git"
                  ;;
		9)
		  aur_package_install "discord"
		  ;;
                "b")
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            source sharedfuncs_elihw
          done
          #}}}
          OPT=4
          ;;
        5)
          #MAPPING {{{
          while true
          do
            print_title "MAPPING TOOLS"
            echo " 1) $(menu_item "google-earth") $AUR"
            echo " 2) $(menu_item "worldwind" "NASA World Wind") $AUR"
            echo ""
            echo " b) BACK"
            echo ""
            MAPPING_OPTIONS+=" b"
            read_input_options "$MAPPING_OPTIONS"
            for OPT in ${OPTIONS[@]}; do
              case "$OPT" in
                1)
                  aur_package_install "google-earth"
                  ;;
                2)
                  aur_package_install "worldwind"
                  ;;
                "b")
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            source sharedfuncs_elihw
          done
          #}}}
          OPT=5
          ;;
        6)
          #DESKTOP SHARE {{{
          while true
          do
            print_title "DESKTOP SHARE"
            echo " 1) $(menu_item "remmina")"
            echo " 2) $(menu_item "teamviewer") $AUR"
            echo ""
            echo " b) BACK"
            echo ""
            VNC_OPTIONS+=" b"
            read_input_options "$VNC_OPTIONS"
            for OPT in ${OPTIONS[@]}; do
              case "$OPT" in
                1)
                  package_install "remmina"
                  ;;
                2)
                  aur_package_install "teamviewer"
                  ;;
                "b")
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            source sharedfuncs_elihw
          done
          #}}}
          OPT=6
          ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#AUDIO {{{
install_audio_apps(){
  while true
  do
    print_title "AUDIO APPS"
    echo " 1) Players"
    echo " 2) Editors|Tools"
    echo " 3) Codecs"
    echo ""
    echo " b) BACK"
    echo ""
    AUDIO_OPTIONS+=" b"
    read_input_options "$AUDIO_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          #PLAYERS {{{
          while true
          do
            print_title "AUDIO PLAYERS"
            echo " 1) $(menu_item "amarok")"
            echo " 2) $(menu_item "audacious")"
            echo " 3) $(menu_item "banshee") $AUR"
            echo " 4) $(menu_item "clementine")"
            echo " 5) $(menu_item "deadbeef")"
            echo " 6) $(menu_item "guayadeque") $AUR"
            echo " 7) $(menu_item "musique") $AUR"
            echo " 8) $(menu_item "nuvolaplayer") $AUR"
            echo " 9) $(menu_item "pragha")"
            echo "10) $(menu_item "radiotray") $AUR"
            echo "11) $(menu_item "rhythmbox")"
            echo "12) $(menu_item "spotify") $AUR"
            echo "13) $(menu_item "timidity++") $AUR"
            echo "14) $(menu_item "tomahawk") $AUR"
            echo "15) $(menu_item "quodlibet")"
            echo ""
            echo " b) BACK"
            echo ""
            AUDIO_PLAYER_OPTIONS+=" b"
            read_input_options "$AUDIO_PLAYER_OPTIONS"
            for OPT in ${OPTIONS[@]}; do
              case "$OPT" in
                1)
                  package_install "amarok"
                  ;;
                2)
                  package_install "audacious audacious-plugins"
                  ;;
                3)
                  aur_package_install "banshee"
                  ;;
                4)
                  package_install "clementine"
                  ;;
                5)
                  package_install "deadbeef"
                  ;;
                6)
                  aur_package_install "guayadeque"
                  ;;
                7)
                  aur_package_install "musique"
                  ;;
                8)
                  aur_package_install "nuvolaplayer"
                  ;;
                9)
                  package_install "pragha"
                  ;;
                10)
                  aur_package_install "radiotray"
                  ;;
                11)
                  package_install "rhythmbox grilo grilo-plugins libgpod libdmapsharing gnome-python python-mako"
                  #aur_package_install "pywebkitgtk"
                  # pywebkitgtk compile needed and take alot of time around 4-5H on i5-8gigram-ssd hdd
                  # + only need when Cannot activate "context pane" plugin
                  ;;
                12)
                  aur_package_install "spotify"
                  ;;
                13)
                  aur_package_install "timidity++ fluidr3"
                  echo -e 'soundfont /usr/share/soundfonts/fluidr3/FluidR3GM.SF2' >> /etc/timidity++/timidity.cfg
                  ;;
                14)
                  aur_package_install "tomahawk"
                  ;;
                15)
                  package_install "quodlibet"
                  ;;
                "b")
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            source sharedfuncs_elihw
          done
          #}}}
          OPT=1
          ;;
        2)
          #EDITORS {{{
          while true
          do
            print_title "AUDIO EDITORS|TOOLS"
            echo " 1) $(menu_item "audacity")"
            echo " 2) $(menu_item "easytag")"
            echo " 3) $(menu_item "ocenaudio-bin") $AUR"
            echo " 4) $(menu_item "soundconverter soundkonverter" "$([[ ${KDE} -eq 1 ]] && echo "Soundkonverter" || echo "Soundconverter";)")"
            echo ""
            echo " b) BACK"
            echo ""
            AUDIO_EDITOR_OPTIONS+=" b"
            read_input_options "$AUDIO_EDITOR_OPTIONS"
            for OPT in ${OPTIONS[@]}; do
              case "$OPT" in
                1)
                  package_install "audacity"
                  ;;
                2)
                  package_install "easytag"
                  ;;
                3)
                  aur_package_install "ocenaudio-bin"
                  ;;
                4)
                  if [[ ${KDE} -eq 1 ]]; then
                    package_install "soundkonverter"
                  else
                    package_install "soundconverter"
                  fi
                  ;;
                "b")
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            source sharedfuncs_elihw
          done
          #}}}
          OPT=2
          ;;
        3)
          package_install "gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav"
          [[ ${KDE} -eq 1 ]] && package_install "phonon-qt5-gstreamer"
          # Use the 'standard' preset by default. This preset should generally be
          # transparent to most people on most music and is already quite high in quality.
          # The resulting bitrate should be in the 170-210kbps range, according to music
          # complexity.
          run_as_user "gconftool-2 --type string --set /system/gstreamer/0.10/audio/profiles/mp3/pipeline \audio/x-raw-int,rate=44100,channels=2 ! lame name=enc preset=1001 ! id3v2mux\""
          ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#VIDEO {{{
install_video_apps(){
  while true
  do
    print_title "VIDEO APPS"
    echo " 1) Players"
    echo " 2) Editors|Tools"
    echo " 3) Codecs"
    echo ""
    echo " b) BACK"
    echo ""
    VIDEO_OPTIONS+=" b"
    read_input_options "$VIDEO_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          #PLAYERS {{{
          while true
          do
            print_title "VIDEO PLAYERS"
            echo " 1) $(menu_item "gnome-mplayer")"
            echo " 2) $(menu_item "livestreamer")"
            echo " 3) $(menu_item "minitube")"
            echo " 4) $(menu_item "miro") $AUR"
            echo " 5) $(menu_item "mpv")"
            echo " 6) $(menu_item "parole")"
            echo " 7) $(menu_item "popcorntime-ce") $AUR"
            echo " 8) $(menu_item "vlc")"
            echo " 9) $(menu_item "kodi")"
            echo ""
            echo " b) BACK"
            echo ""
            VIDEO_PLAYER_OPTIONS+=" b"
            read_input_options "$VIDEO_PLAYER_OPTIONS"
            for OPT in ${OPTIONS[@]}; do
              case "$OPT" in
                1)
                  package_install "gnome-mplayer"
                  ;;
                2)
                  package_install "livestreamer"
                  ;;
                3)
                  package_install "minitube"
                  ;;
                4)
                  aur_package_install "miro"
                  ;;
                5)
                  package_install "mpv"
                  ;;
                6)
                  package_install "parole"
                  ;;
                7)
                  aur_package_install "popcorntime-ce"
                  ;;
                8)
                  package_install "vlc"
                  [[ ${KDE} -eq 1 ]] && package_install "phonon-qt5-vlc"
                  ;;
                9)
                  package_install "kodi"
                  add_user_to_group ${username} kodi
                  ;;
                "b")
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            source sharedfuncs_elihw
          done
          #}}}
          OPT=1
          ;;
        2)
          #EDITORS {{{
          while true
          do
            print_title "VIDEO EDITORS|TOOLS"
            echo " 1) $(menu_item "arista") $AUR"
            echo " 2) $(menu_item "avidemux-gtk avidemux-qt" "Avidemux")"
            echo " 3) $(menu_item "filebot") $AUR"
            echo " 4) $(menu_item "handbrake")"
            echo " 5) $(menu_item "kazam") $AUR"
            echo " 6) $(menu_item "kdenlive")"
            echo " 7) $(menu_item "lwks" "Lightworks") $AUR"
            echo " 8) $(menu_item "openshot")"
            echo " 9) $(menu_item "pitivi")"
            echo "10) $(menu_item "transmageddon")"
            echo ""
            echo " b) BACK"
            echo ""
            VIDEO_EDITOR_OPTIONS+=" b"
            read_input_options "$VIDEO_EDITOR_OPTIONS"
            for OPT in ${OPTIONS[@]}; do
              case "$OPT" in
                1)
                  aur_package_install "arista"
                  ;;
                2)
                  if [[ ${KDE} -eq 1 ]]; then
                    package_install "avidemux-qt"
                  else
                    package_install "avidemux-gtk"
                  fi
                  ;;
                3)
                  aur_package_install "filebot"
                  ;;
                4)
                  package_install "handbrake"
                  ;;
                5)
                  aur_package_install "kazam"
                  ;;
                6)
                  package_install "kdenlive"
                  ;;
                7)
                  aur_package_install "lwks"
                  ;;
                8)
                  package_install "openshot"
                  ;;
                9)
                  package_install "pitivi frei0r-plugins"
                  ;;
                10)
                  package_install "transmageddon"
                  ;;
                "b")
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            source sharedfuncs_elihw
          done
          #}}}
          OPT=2
          ;;
        3)
          package_install "libdvdnav libdvdcss cdrdao cdrtools ffmpeg ffmpeg2.8 ffmpegthumbnailer ffmpegthumbs"
          if [[ ${KDE} -eq 1 ]]; then
          	package_install "kdegraphics-thumbnailers"
          fi
          ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#GAMES {{{
install_games(){
  while true
  do
    print_title "GAMES - https://wiki.archlinux.org/index.php/Games"
    echo " 1) Desura $AUR"
    echo " 2) PlayOnLinux $AUR"
    echo " 3) Steam"
    echo " 4) Minecraft"
    echo ""
    echo " b) BACK"
    echo ""
    GAMES_OPTIONS+=" b"
    read_input_options "$GAMES_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          aur_package_install "desura"
          OPT=1
          ;;
        2)
          aur_package_install "playonlinux"
          OPT=2
          ;;
        3)
          package_install "steam"
          OPT=3
          ;;
	4)
	  aur_package_install "minecraft"
	  OPT=4
	  ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#WEBSERVER {{{
install_web_server(){
  install_adminer(){ #{{{
    aur_package_install "adminer"
    local ADMINER=`cat /etc/httpd/conf/httpd.conf | grep Adminer`
    [[ -z $ADMINER ]] && echo -e '\n# Adminer Configuration\nInclude conf/extra/httpd-adminer.conf' >> /etc/httpd/conf/httpd.conf
  } #}}}
  install_mariadb(){ #{{{
    package_install "mariadb"
    /usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    system_ctl enable mysqld.service
    systemctl start mysqld.service
    /usr/bin/mysql_secure_installation
  } #}}}
  install_postgresql(){ #{{{
    package_install "postgresql"
    mkdir -p /var/lib/postgres
    chown -R postgres:postgres /var/lib/postgres
    systemd-tmpfiles --create postgresql.conf
    echo "Enter your new postgres account password:"
    passwd postgres
    while [[ $? -ne 0 ]]; do
      passwd postgres
    done
    su - postgres -c "initdb --locale ${LOCALE}.UTF-8 -D /var/lib/postgres/data"
    system_ctl enable postgresql.service
    system_ctl start postgresql.service
    read_input_text "Install Postgis + Pgrouting" $POSTGIS
    [[ $OPTION == y ]] && install_gis_extension
  } #}}}
  install_gis_extension(){ #{{{
    package_install "postgis"
    aur_package_install "pgrouting"
  } #}}}
  configure_php(){ #{{{
    if [[ -f /etc/php/php.ini.pacnew ]]; then
      mv -v /etc/php/php.ini /etc/php/php.ini.pacold
      mv -v /etc/php/php.ini.pacnew /etc/php/php.ini
      rm -v /etc/php/php.ini.aui
    fi
    [[ -f /etc/php/php.ini.aui ]] && echo "/etc/php/php.ini.aui" || cp -v /etc/php/php.ini /etc/php/php.ini.aui
    if [[ $1 == mariadb ]]; then
      sed -i '/mysqli.so/s/^;//' /etc/php/php.ini
      sed -i '/mysql.so/s/^;//' /etc/php/php.ini
      sed -i '/skip-networking/s/^/#/' /etc/mysql/my.cnf
    else
      sed -i '/pgsql.so/s/^;//' /etc/php/php.ini
    fi
    sed -i '/mcrypt.so/s/^;//' /etc/php/php.ini
    sed -i '/gd.so/s/^;//' /etc/php/php.ini
    sed -i '/display_errors=/s/off/on/' /etc/php/php.ini
  } #}}}
  configure_php_apache(){ #{{{
    if [[ -f /etc/httpd/conf/httpd.conf.pacnew ]]; then
      mv -v /etc/httpd/conf/httpd.conf.pacnew /etc/httpd/conf/httpd.conf
      rm -v /etc/httpd/conf/httpd.conf.aui
    fi
    [[ -f /etc/httpd/conf/httpd.conf.aui ]] && echo "/etc/httpd/conf/httpd.conf.aui" || cp -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.aui
    local IS_DISABLED=`cat /etc/httpd/conf/httpd.conf | grep php5_module.conf`
    if [[ -z $IS_DISABLED ]]; then
      echo -e 'application/x-httpd-php5                php php5' >> /etc/httpd/conf/mime.types
      sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
      echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\n\nAddHandler php5-script php' >> /etc/httpd/conf/httpd.conf
      #  libphp5.so included with php-apache does not work with mod_mpm_event (FS#39218). You'll have to use mod_mpm_prefork instead
      replace_line 'LoadModule mpm_event_module modules/mod_mpm_event.so' 'LoadModule mpm_prefork_module modules/mod_mpm_prefork.so' /etc/httpd/conf/httpd.conf
      replace_line 'DirectoryIndex\ index.html' 'DirectoryIndex\ index.html\ index.php' /etc/httpd/conf/httpd.conf
    fi
  } #}}}
  configure_php_nginx(){ #{{{
    if [[ -f /etc/nginx/nginx.conf.pacnew ]]; then
      mv -v /etc/nginx/nginx.conf.pacnew /etc/nginx/nginx.conf
      rm -v /etc/nginx/nginx.conf.aui
    fi
    [[ -f /etc/nginx/nginx.conf.aui ]] && cp -v /etc/nginx/nginx.conf.aui /etc/nginx/nginx.conf || cp -v /etc/nginx/nginx.conf /etc/nginx/nginx.conf.aui
    sed -i -e '/location ~ \.php$ {/,/}/d' /etc/nginx/nginx.conf
    sed -i -e '/pass the PHP/a\        #\n        location ~ \.php$ {\n            fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;\n            fastcgi_index  index.php;\n            root           /srv/http;\n            include        fastcgi.conf;\n        }' /etc/nginx/nginx.conf
  } #}}}
  create_sites_folder(){ #{{{
    [[ ! -f  /etc/httpd/conf/extra/httpd-userdir.conf.aui ]] && cp -v /etc/httpd/conf/extra/httpd-userdir.conf /etc/httpd/conf/extra/httpd-userdir.conf.aui
    replace_line 'public_html' 'Sites' /etc/httpd/conf/extra/httpd-userdir.conf
    su - ${username} -c "mkdir -p ~/Sites"
    su - ${username} -c "chmod o+x ~/ && chmod -R o+x ~/Sites"
    print_line
    echo "The folder \"Sites\" has been created in your home"
    echo "You can access your projects at \"http://localhost/~username\""
    pause_function
  } #}}}
  print_title "WEB SERVER - https://wiki.archlinux.org/index.php/LAMP|LAPP"
  print_info "*Adminer is installed by default in all options"
  echo " 1) LAMP - APACHE, MariaDB & PHP"
  echo " 2) LAPP - APACHE, POSTGRESQL & PHP"
  echo " 3) LEMP - NGINX, MariaDB & PHP"
  echo " 4) LEPP - NGINX, POSTGRESQL & PHP"
  echo ""
  echo " b) BACK"
  echo ""
  read_input $WEBSERVER
  case "$OPTION" in
    1)
      package_install "apache php php-apache php-mcrypt php-gd"
      install_mariadb
      install_adminer
      system_ctl enable httpd.service
      configure_php_apache
      configure_php "mariadb"
      create_sites_folder
      ;;
    2)
      package_install "apache php php-apache php-pgsql php-gd"
      install_postgresql
      install_adminer
      system_ctl enable httpd.service
      configure_php_apache
      configure_php "postgresql"
      create_sites_folder
      ;;
    3)
      package_install "nginx php php-mcrypt php-fpm"
      install_mariadb
      system_ctl enable nginx.service
      system_ctl enable php-fpm.service
      configure_php_nginx
      configure_php "mariadb"
      ;;
    4)
      package_install "nginx php php-fpm php-pgsql"
      install_postgresql
      system_ctl enable nginx.service
      system_ctl enable php-fpm.service
      configure_php_nginx
      configure_php "postgresql"
      ;;
  esac
}
#}}}
#FONTS {{{
install_fonts(){
  while true
  do
    print_title "FONTS - https://wiki.archlinux.org/index.php/Fonts"
    echo " 1) $(menu_item "ttf-dejavu")"
    echo " 2) $(menu_item "ttf-fira-code") $AUR"
    echo " 3) $(menu_item "ttf-google-fonts-git") $AUR"
    echo " 4) $(menu_item "ttf-liberation")"
    echo " 5) $(menu_item "ttf-bitstream-vera")"
    echo " 6) $(menu_item "ttf-hack")"
    echo " 7) $(menu_item "ttf-mac-fonts") $AUR"
    echo " 8) $(menu_item "ttf-ms-fonts") $AUR"
    echo " 9) $(menu_item "wqy-microhei") (Chinese/Japanese/Korean Support)"
    echo "10) $(menu_item "noto-fonts-cjk") (Chinese/Japanese/Korean Support)"
    echo ""
    echo " b) BACK"
    echo ""
    FONTS_OPTIONS+=" b"
    read_input_options "$FONTS_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          package_install "ttf-dejavu"
          ;;
        2)
          aur_package_install "ttf-fira-code"
          ;;
        3)
          package_remove "ttf-droid"
          package_remove "ttf-roboto"
          package_remove "ttf-ubuntu-font-family"
          package_remove "otf-oswald-ib"
          aur_package_install "ttf-google-fonts-git"
          ;;
        4)
          package_install "ttf-liberation"
          ;;
        5)
          package_install "ttf-bitstream-vera"
          ;;
        6)
          package_install "ttf-hack"
          ;;
        7)
          aur_package_install "ttf-mac-fonts"
          ;;
        8)
          aur_package_install "ttf-ms-fonts"
          ;;
        9)
          package_install "wqy-microhei"
          ;;
        10)
          package_install "noto-fonts-cjk"
          ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#CLEAN ORPHAN PACKAGES {{{
clean_orphan_packages(){
  print_title "CLEAN ORPHAN PACKAGES"
  pacman -Rsc --noconfirm $(pacman -Qqdt)
  #pacman -Sc --noconfirm
  pacman-optimize
}
#}}}
#RECONFIGURE SYSTEM {{{
reconfigure_system(){
  print_title "KEYMAP - https://wiki.archlinux.org/index.php/KEYMAP"
  print_info "The KEYMAP variable is specified in the /etc/rc.conf file. It defines what keymap the keyboard is in the virtual consoles. Keytable files are provided by the kbd package."
  OPTION=n
  while [[ $OPTION != y ]]; do
    getkeymap
    read_input_text "Confirm keymap: $KEYMAP"
  done
  localectl set-keymap ${KEYMAP}

  print_title "HOSTNAME - https://wiki.archlinux.org/index.php/HOSTNAME"
  print_info "A host name is a unique name created to identify a machine on a network.Host names are restricted to alphanumeric characters.\nThe hyphen (-) can be used, but a host name cannot start or end with it. Length is restricted to 63 characters."
  read -p "Hostname [ex: archlinux]: " HN
  hostnamectl set-hostname $HN

  print_title "TIMEZONE - https://wiki.archlinux.org/index.php/Timezone"
  print_info "In an operating system the time (clock) is determined by four parts: Time value, Time standard, Time Zone, and DST (Daylight Saving Time if applicable)."
  OPTION=n
  while [[ $OPTION != y ]]; do
    settimezone
    read_input_text "Confirm timezone ($ZONE/$SUBZONE)"
  done
  timedatectl set-timezone ${ZONE}/${SUBZONE}

  print_title "HARDWARE CLOCK TIME - https://wiki.archlinux.org/index.php/Internationalization"
  print_info "This is set in /etc/adjtime. Set the hardware clock mode uniformly between your operating systems on the same machine. Otherwise, they will overwrite the time and cause clock shifts (which can cause time drift correction to be miscalibrated)."
  hwclock_list=('UTC' 'Localtime');
  PS3="$prompt1"
  select OPT in "${hwclock_list[@]}"; do
    case "$REPLY" in
      1)
        timedatectl set-local-rtc false
        ;;
      2)
        timedatectl set-local-rtc true
        ;;
      *) invalid_option ;;
    esac
    [[ -n $OPT ]] && break
  done
  timedatectl set-ntp true
}
#}}}
#EXTRA {{{
install_extra(){
  while true
  do
    print_title "EXTRA"
    echo " 1) Global Menu $AUR"
    echo " 2) $(menu_item "profile-sync-daemon") $AUR"
    echo " b) BACK"
    echo ""
    EXTRA_OPTIONS+=" b"
    read_input_options "$EXTRA_OPTIONS"
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          aur_package_install "gtk2-appmenu gtk3-appmenu"
          if [[ ${KDE} -eq 1 ]]; then
            aur_package_install "appmenu-qt appmenu-gtk"
            aur_package_install "kdeplasma-applets-menubar"
          fi
          if [[ ! -f /home/${username}/.config/gtk-3.0/settings.ini ]]; then
            run_as_user "echo -e \"[Settings]\ngtk-shell-shows-menubar = 1\" > /home/${username}/.config/gtk-3.0/settings.ini"
          else
            add_line "gtk-shell-shows-menubar = 1" "/home/${username}/.config/gtk-3.0/settings.ini"
          fi
          ;;
        2)
          aur_package_install "profile-sync-daemon"
          run_as_user "psd"
          run_as_user "$EDITOR /home/${username}/.config/psd/psd.conf"
          run_as_user "systemctl --user enable psd.service"
          ;;
        "b")
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    source sharedfuncs_elihw
  done
}
#}}}
#FINISH {{{
finish(){
  print_title "WARNING: PACKAGES INSTALLED FROM AUR"
  print_danger "List of packages not officially supported that may kill your cat:"
  pause_function
  AUR_PKG_LIST="${AUI_DIR}/aur_pkg_list.log"
  pacman -Qm | awk '{print $1}' > $AUR_PKG_LIST
  less $AUR_PKG_LIST
  print_title "INSTALL COMPLETED"
  echo -e "Thanks for using the Archlinux Ultimate Install script by helmuthdu\n"
  #REBOOT
  read -p "Reboot your system [y/N]: " OPTION
  [[ $OPTION == y ]] && reboot
  exit 0
}
#}}}

welcome
check_root
check_archlinux
check_hostname
check_connection
check_pacman_blocked
check_multilib
pacman_key
system_update
language_selector
configure_sudo
select_user
choose_aurhelper
automatic_mode

if is_package_installed "kdebase-workspace"; then KDE=1; fi

while true
do
  print_title "ARCHLINUX INSTALL - https://github.com/helmuthdu/aui"
  print_warning "USERNAME: ${username}"
  echo " 1) $(mainmenu_item "${checklist[1]}" "Basic Setup")"
  echo " 2) $(mainmenu_item "${checklist[2]}" "Desktop Environment|Window Manager")"
  echo " 3) $(mainmenu_item "${checklist[3]}" "Accessories Apps")"
  echo " 4) $(mainmenu_item "${checklist[4]}" "Development Apps")"
  echo " 5) $(mainmenu_item "${checklist[5]}" "Office Apps")"
  echo " 6) $(mainmenu_item "${checklist[6]}" "System Apps")"
  echo " 7) $(mainmenu_item "${checklist[7]}" "Graphics Apps")"
  echo " 8) $(mainmenu_item "${checklist[8]}" "Internet Apps")"
  echo " 9) $(mainmenu_item "${checklist[9]}" "Audio Apps")"
  echo "10) $(mainmenu_item "${checklist[10]}" "Video Apps")"
  echo "11) $(mainmenu_item "${checklist[11]}" "Games")"
  echo "12) $(mainmenu_item "${checklist[12]}" "Web server")"
  echo "13) $(mainmenu_item "${checklist[13]}" "Fonts")"
  echo "14) $(mainmenu_item "${checklist[14]}" "Extra")"
  echo "15) $(mainmenu_item "${checklist[15]}" "Clean Orphan Packages")"
  echo "16) $(mainmenu_item "${checklist[16]}" "Reconfigure System")"
  echo ""
  echo " q) Quit"
  echo ""
  MAINMENU+=" q"
  read_input_options "$MAINMENU"
  for OPT in ${OPTIONS[@]}; do
    case "$OPT" in
      1)
        add_custom_repositories
        install_basic_setup
        install_zsh
        install_ssh
        install_nfs
        install_samba
        install_tlp
        enable_readahead
        install_zram
        install_video_cards
        install_xorg
        font_config
        install_cups
        install_additional_firmwares
        checklist[1]=1
        ;;
      2)
        if [[ checklist[1] -eq 0 ]]; then
          print_danger "\nWARNING: YOU MUST RUN THE BASIC SETUP FIRST"
          read_input_text "Are you sure you want to continue?"
          [[ $OPTION != y ]] && continue
        fi
        install_desktop_environment
        install_nm_wicd
        install_usb_modem
        checklist[2]=1
        ;;
      3)
        install_accessories_apps
        checklist[3]=1
        ;;
      4)
        install_development_apps
        checklist[4]=1
        ;;
      5)
        install_office_apps
        checklist[5]=1
        ;;
      6)
        install_system_apps
        checklist[6]=1
        ;;
      7)
        install_graphics_apps
        checklist[7]=1
        ;;
      8)
        install_internet_apps
        checklist[8]=1
        ;;
      9)
        install_audio_apps
        checklist[9]=1
        ;;
      10)
        install_video_apps
        checklist[10]=1
        ;;
      11)
        install_games
        checklist[11]=1
        ;;
      12)
        install_web_server
        checklist[12]=1
        ;;
      13)
        install_fonts
        checklist[13]=1
        ;;
      14)
        install_extra
        checklist[14]=1
        ;;
      15)
        clean_orphan_packages
        checklist[15]=1
        ;;
      16)
        print_danger "\nWARNING: THIS OPTION WILL RECONFIGURE THINGS LIKE HOSTNAME, TIMEZONE, CLOCK..."
        read_input_text "Are you sure you want to continue?"
        [[ $OPTION != y ]] && continue
        reconfigure_system
        checklist[16]=1
        ;;
      "q")
        finish
        ;;
      *)
        invalid_option
        ;;
    esac
  done
done
#}}}
