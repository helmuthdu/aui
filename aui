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

#VARIABLES {{{
  checklist=( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
  # COLORS {{{
    # Regular Colors
    Black='\e[0;30m'        # Black
    Blue='\e[0;34m'         # Blue
    Cyan='\e[0;36m'         # Cyan
    Green='\e[0;32m'        # Green
    Purple='\e[0;35m'       # Purple
    Red='\e[0;31m'          # Red
    White='\e[0;37m'        # White
    Yellow='\e[0;33m'       # Yellow
    # Bold
    BBlack='\e[1;30m'       # Black
    BBlue='\e[1;34m'        # Blue
    BCyan='\e[1;36m'        # Cyan
    BGreen='\e[1;32m'       # Green
    BPurple='\e[1;35m'      # Purple
    BRed='\e[1;31m'         # Red
    BWhite='\e[1;37m'       # White
    BYellow='\e[1;33m'      # Yellow
  #}}}
  # PROMPT {{{
    prompt1="Enter your option: "
    prompt2="Enter n° of options (ex: 1 2 3 or 1-3): "
    prompt3="You have to manual enter the following commands, then press ${BYellow}ctrl+d${White} or type ${BYellow}exit${White}:"
  #}}}
  # EDITOR {{{
    AUTOMATIC_MODE=0
    if [[ -f /usr/bin/vim ]]; then
      EDITOR="vim"
    elif [[ -z $EDITOR ]]; then
      EDITOR="nano"
    fi
  #}}}
  # DESKTOP ENVIRONMENT
  CINNAMON=0
  GNOME=0
  KDE=0
  # ARCHITECTURE
  ARCHI=`uname -m`
  UEFI=0
  # AUR PACKAGE
  AUR=`echo -e "(${BPurple}aur${White})"`
  #CURRENT DIRECTORY
  AUI_DIR=`pwd`
  MOUNTPOINT="/mnt"
  #PROPRIETARY DRIVER
  NVIDIA=0
  ATI=0
  # VERBOSE MODE
  if [[ $1 == "-v" || $1 == "--verbose" ]]; then
    VERBOSE_MODE=1
  else
    VERBOSE_MODE=0
  fi
  # LOG FILE
  LOG="${PWD}/`basename ${0}`.log"
  [[ -f $LOG ]] && rm $LOG 2>/dev/null
  # CONNECTION CHECK
  XPINGS=0
  #MISC
  SPIN="/-\|"
#}}}
#COMMON FUNCTIONS {{{
  error_msg() { #{{{
    local MSG="${1}"
    echo "${MSG}"
    exit 1
  } #}}}
  cecho() { #{{{
    echo -e "$1"
    echo -e "$1" >>"$LOG"
    tput sgr0;
  } #}}}
  ncecho() { #{{{
    echo -ne "$1"
    echo -ne "$1" >>"$LOG"
    tput sgr0
  } #}}}
  spinny() { #{{{
    echo -ne "\b${SPIN:i++%${#SPIN}:1}"
  } #}}}
  progress() { #{{{
    ncecho "  ";
    while [ /bin/true ]; do
      kill -0 $pid 2>/dev/null;
      if [[ $? = "0" ]]; then
        spinny
        sleep 0.25
      else
        ncecho "\b\b";
        wait $pid
        retcode=$?
        echo "$pid's retcode: $retcode" >> "$LOG"
        if [[ $retcode = "0" ]] || [[ $retcode = "255" ]]; then
          cecho success
        else
          cecho failed
          echo -e "${BRed}==>${White} Showing the last 10 lines from $LOG";
          tail -n10 "$LOG"
          read -e -sn 1 -p "Press any key to continue..."
        fi
        break 1; #was2
      fi
    done
  } #}}}
  check_root() { #{{{
    if [ "$(id -u)" != "0" ]; then
      error_msg "ERROR! You must execute the script as the 'root' user."
    fi
  } #}}}
  check_user() { #{{{
    if [ "$(id -u)" == "0" ]; then
      error_msg "ERROR! You must execute the script as a normal user."
    fi
  } #}}}
  check_archlinux() { #{{{
    if [ ! -e /etc/arch-release ]; then
      error_msg "ERROR! You must execute the script on Arch Linux."
    fi
  } #}}}
  check_hostname() { #{{{
    if [ `echo ${HOSTNAME} | sed 's/ //g'` == "" ]; then
      error_msg "ERROR! Hostname is not configured."
    fi
  } #}}}
  check_domainname() { #{{{
    DOMAINNAME=`echo ${HOSTNAME} | cut -d'.' -f2- | sed 's/ //g'`

    # Hmm, still no domain name. Keep looking...
    if [[ "${DOMAINNAME}" == "" ]]; then
      DOMAINNAME=`grep domain /etc/resolv.conf | sed 's/domain //g' | sed 's/ //g'`
    fi

    # OK, give up.
    if [[ "${DOMAINNAME}" == "" ]]; then
      error_msg "ERROR! Domain name is not configured."
    fi
  } #}}}
  check_connection() { #{{{
    XPINGS=$(( $XPINGS + 1 ))
    IP_ADDR=`ip addr 2>/dev/null | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' | egrep -v '255|(127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' | sed 's/ //g'`
    if [[ -z $IP_ADDR ]]; then
      if [[ $XPINGS -gt 4 ]]; then
        error_msg "ERROR! Could not find valid IP address."
        exit 1
      fi
      [[ $XPINGS -eq 1 ]] && dhcpcd
      sleep 3
      check_connection
    fi
  } #}}}
  check_vga() { #{{{
    # Determine video chipset - only Intel, ATI and nvidia are supported by this script"
    ncecho "${BBlue}==>${White} Detecting video chipset "
    local VGA=`lspci | grep VGA`
    echo ${VGA} | tr "[:upper:]" "[:lower:]" | grep -q nvidia
    if [ $? -eq 0 ]; then
      cecho Nvidia
      read_input_text "Install NVIDIA proprietary driver" $PROPRIETARY_DRIVER
      if [[ $OPTION == y ]]; then
        NVIDIA=1
      else
        VIDEO_DRIVER="nouveau"
      fi
    else
      echo ${VGA} | tr "[:upper:]" "[:lower:]" | grep -q "intel corporation"
      if [ $? -eq 0 ]; then
        cecho Intel
        VIDEO_DRIVER="intel"
      else
        echo ${VGA} | tr "[:upper:]" "[:lower:]" | grep -q "advanced micro devices"
        if [ $? -eq 0 ]; then
          cecho AMD/ATI
          read_input_text "Install ATI proprietary driver" $PROPRIETARY_DRIVER
          if [[ $OPTION == y ]]; then
            ATI=1
          else
            VIDEO_DRIVER="ati"
          fi
        else
          cecho VESA
          VIDEO_DRIVER=""
        fi
      fi
    fi
  } #}}}
  check_wireless() { #{{{
    lspci | grep -q BCM4312
    if [ $? -eq 0 ]; then
      WIRELESS_PKG="dkms-broadcom-wl"
      WIRELESS_MOD="wl"
    else
      WIRELESS_PKG=""
      WIRELESS_MOD=""
    fi
  } #}}}
  read_input(){ #{{{
    if [[ $AUTOMATIC_MODE -eq 1 ]]; then
      OPTION=$1
    else
      read -p "$prompt1" OPTION
    fi
  } #}}}
  read_input_text(){ #{{{
    if [[ $AUTOMATIC_MODE -eq 1 ]]; then
      OPTION=$2
    else
      read -p "$1 [y/N]: " OPTION
      echo ""
    fi
    OPTION=`echo "$OPTION" | tr '[:upper:]' '[:lower:]'`
  } #}}}
  read_input_options(){ #{{{
    local line
    local packages
    if [[ $AUTOMATIC_MODE -eq 1 ]]; then
      array=("$1")
    else
      read -p "$prompt2" OPTION
      array=("$OPTION")
    fi
    for line in ${array[@]/,/ }; do
      if [[ ${line/-/} != $line ]]; then
        for ((i=${line%-*}; i<=${line#*-}; i++)); do
          packages+=($i);
        done
      else
        packages+=($line)
      fi
    done
    OPTIONS=("${packages[@]}")
  } #}}}
  print_line(){ #{{{
    printf "%$(tput cols)s\n"|tr ' ' '-'
  } #}}}
  print_title(){ #{{{
    clear
    print_line
    echo -e "# ${BWhite}$1${White}"
    print_line
    echo ""
  } #}}}
  print_info(){ #{{{
    #Console width number
    T_COLS=`tput cols`
    echo -e "${BWhite}$1${White}\n" | fold -sw $(( $T_COLS - 18 )) | sed 's/^/\t/'
  } #}}}
  print_warning(){ #{{{
    #Console width number
    T_COLS=`tput cols`
    echo -e "${BRed}$1${White}\n" | fold -sw $(( $T_COLS - 1 ))
  } #}}}
  start_module(){ #{{{
    modprobe $1
  } #}}}
  replaceinfile() { #{{{
    SEARCH=${1}
    REPLACE=${2}
    FILEPATH=${3}
    FILEBASE=`basename ${3}`

    sed -e "s/${SEARCH}/${REPLACE}/" ${FILEPATH} > /tmp/${FILEBASE} 2>"$LOG"
    if [ ${?} -eq 0 ]; then
      mv /tmp/${FILEBASE} ${FILEPATH}
    else
      cecho "failed: ${SEARCH} - ${FILEPATH}"
    fi
  } #}}}
  add_module(){ #{{{
    #check if the number of arguments is less then 2
    for MODULE in $1; do
      [[ $# -lt 2 ]] && MODULE_NAME="$MODULE" || MODULE_NAME="$2";
      echo "$MODULE" >> /etc/modules-load.d/$MODULE_NAME.conf
      start_module "$MODULE"
    done
  } #}}}
  update_early_modules() { #{{{
    local NEW_MODULE=${1}
    local OLD_ARRAY=`egrep ^MODULES= /etc/mkinitcpio.conf`

    if [[ -n ${NEW_MODULE} ]]; then
      # Determine if the new module is already listed.
      _EXISTS=`echo ${OLD_ARRAY} | grep ${NEW_MODULE}`
      if [ $? -eq 1 ]; then

        source /etc/mkinitcpio.conf
        if [[ -z ${MODULES} ]]; then
          NEW_MODULES="${NEW_MODULE}"
        else
          NEW_MODULES="${MODULES} ${NEW_MODULE}"
        fi
        replaceinfile "MODULES=\"${MODULES}\"" "MODULES=\"${NEW_MODULES}\"" /etc/mkinitcpio.conf
        ncecho "${BBlue}==>${White} Rebuilding init "
        mkinitcpio -p linux >>"$LOG" 2>&1 &
        pid=$!;progress $pid
      fi
    fi
  } #}}}
  is_package_installed(){ #{{{
    #check if a package is already installed
    for PKG in $1; do
      pacman -Q $PKG &> /dev/null && return 0;
    done
    return 1
  } #}}}
  checkbox(){ #{{{
    #display [X] or [ ]
    [[ "$1" -eq 1 ]] && echo -e "${BBlue}[${BWhite}X${BBlue}]${White}" || echo -e "${BBlue}[${White} ${BBlue}]${White}";
  } #}}}
  checkbox_package(){ #{{{
    #check if [X] or [ ]
    is_package_installed "$1" && checkbox 1 || checkbox 0
  } #}}}
  aui_download_packages(){ #{{{
    for PKG in $1; do
      #exec command as user instead of root
      su - ${USER_NAME} -c "
        [[ ! -d aui_packages ]] && mkdir aui_packages
        cd aui_packages
        curl -o $PKG.tar.gz https://aur.archlinux.org/packages/${PKG:0:2}/$PKG/$PKG.tar.gz
        tar zxvf $PKG.tar.gz
        rm $PKG.tar.gz
        cd $PKG
        makepkg -si --noconfirm
      "
    done
  } #}}}
  aur_package_install(){ #{{{
    #install package from aur
    for PKG in $1; do
      if ! is_package_installed "${PKG}" ; then
        if [[ $AUTOMATIC_MODE -eq 1 || $VERBOSE_MODE -eq 0 ]]; then
          ncecho "${BBlue}==>${White} Installing ${AUR} ${BWhite}${PKG}${White} "
          su - ${USER_NAME} -c "${AUR_HELPER} --noconfirm -S ${PKG}" >>"$LOG" 2>&1 &
          pid=$!;progress $pid
        else
          su - ${USER_NAME} -c "${AUR_HELPER} -S ${PKG}"
        fi
      else
        if [[ $VERBOSE_MODE -eq 0 ]]; then
          cecho "${BBlue}==>${White} Installing ${AUR} ${BWhite}${PKG}${White} success"
        else
          echo -e "Warning: ${PKG} is up to date --skipping"
        fi
      fi
    done
  } #}}}
  package_install(){ #{{{
    #install packages using pacman
    if [[ $AUTOMATIC_MODE -eq 1 || $VERBOSE_MODE -eq 0 ]]; then
      for PKG in ${1}; do
        PKG_REPO=`pacman -Sp --print-format %r ${PKG} | uniq | sed '1!d'`
        case $PKG_REPO in
          "core")
            PKG_REPO="${BRed}${PKG_REPO}${White}"
            ;;
          "extra")
            PKG_REPO="${BYellow}${PKG_REPO}${White}"
            ;;
          "community")
            PKG_REPO="${BGreen}${PKG_REPO}${White}"
            ;;
          "multilib")
            PKG_REPO="${BCyan}${PKG_REPO}${White}"
            ;;
        esac
        if ! is_package_installed "${PKG}" ; then
          ncecho "${BBlue}==>${White} Installing (${PKG_REPO}) ${BWhite}${PKG}${White} "
          pacman -S --noconfirm --needed ${PKG} >>"$LOG" 2>&1 &
          pid=$!;progress $pid
        else
          cecho "${BBlue}==>${White} Installing (${PKG_REPO}) ${BWhite}${PKG}${White} exists "
        fi
      done
    else
      pacman -S --needed $1
    fi
  } #}}}
  package_remove(){ #{{{
    #remove package
    for PKG in ${1}; do
      if is_package_installed "${PKG}" ; then
        if [[ $AUTOMATIC_MODE -eq 1 || $VERBOSE_MODE -eq 0 ]]; then
          ncecho "${BBlue}==>${White} Removing ${BWhite}${PKG}${White} "
          pacman -Rcsn --noconfirm ${PKG} >>"$LOG" 2>&1 &
          pid=$!;progress $pid
        else
         pacman -Rcsn ${PKG}
        fi
      fi
    done
  } #}}}
  system_upgrade(){ #{{{
    if [[ $VERBOSE_MODE -eq 0 ]]; then
      ncecho "${BBlue}==>${White} Upgrading packages "
      pacman -Syu --noconfirm --noprogress >>"$LOG" 2>&1 &
      pid=$!;progress $pid
    else
      pacman -Syu $1
    fi
  } #}}}
  contains_element(){ #{{{
    #check if an element exist in a string
    for e in "${@:2}"; do [[ $e == $1 ]] && break; done;
  } #}}}
  config_xinitrc(){ #{{{
    #create a xinitrc file in home user directory
    cp -fv /etc/skel/.xinitrc /home/${USER_NAME}/
    echo -e "exec ck-launch-session $1" >> /home/${USER_NAME}/.xinitrc
    chown -R ${USER_NAME}:users /home/${USER_NAME}/.xinitrc
  } #}}}
  invalid_option(){ #{{{
    print_line
    echo "Invalid option. Try another one."
    pause_function
  } #}}}
  pause_function(){ #{{{
    print_line
    if [[ $AUTOMATIC_MODE -ne 1 ]]; then
      read -e -sn 1 -p "Press any key to continue..."
    fi
  } #}}}
  menu_item(){ #{{{
    #check if the number of arguments is less then 2
    [[ $# -lt 2 ]] && PACKAGE_NAME="$1" || PACKAGE_NAME="$2";
    #list of chars to remove from the package name
    CHARS_TO_REMOVE=("Ttf-" "-bzr" "-hg" "-svn" "-git" "-stable" "-icon-theme" "Gnome-shell-theme-" "Gnome-shell-extension-");
    #remove chars from package name
    for CHARS in ${CHARS_TO_REMOVE[@]}; do PACKAGE_NAME=`echo ${PACKAGE_NAME^} | sed 's/'$CHARS'//'`; done
    #display checkbox and package name
    echo -e "$(checkbox_package "$1") ${BWhite}$PACKAGE_NAME${White}"
  } #}}}
  mainmenu_item(){ #{{{
    echo -e "$(checkbox "$1") ${BWhite}$2${White}"
  } #}}}
  elihw() { #{{{
    [[ $OPT == b || $OPT == d ]] && break;
  } #}}}
  add_user_to_group() { #{{{
    local _USER=${1}
    local _GROUP=${2}

    if [[ -z ${_GROUP} ]]; then
      error_msg "ERROR! 'add_user_to_group' was not given enough parameters."
    fi

    ncecho "${BBlue}==>${White} Adding ${BWhite}${_USER}${White} to ${BWhite}${_GROUP}${White} "
    gpasswd -a ${_USER} ${_GROUP} >>"$LOG" 2>&1 &
    pid=$!;progress $pid
  } #}}}
#}}}

case "$1" in
  --ais)
  #ARCHLINUX INSTALL SCRIPTS MODE {{{
  #CONFIGURE KEYMAP {{{
  configure_keymap(){
    setkeymap(){
      local keymaps=(`ls /usr/share/kbd/keymaps/i386/qwerty | sed 's/.map.gz//g'`)
      PS3="(shift+pgup/pgdown) $prompt1"
      echo "Select keymap:"
      select KEYMAP in "${keymaps[@]}" "more"; do
        if contains_element "$KEYMAP" "${keymaps[@]}"; then
          loadkeys $KEYMAP
          break
        elif [[ $KEYMAP == more ]]; then
          read -p "Type your Keyboard Layout [ex: us-acentos]: " KEYMAP
          loadkeys $KEYMAP
          break
        else
          invalid_option
        fi
      done
    }
    print_title "KEYMAP - https://wiki.archlinux.org/index.php/KEYMAP"
    print_info "The KEYMAP variable is specified in the /etc/rc.conf file. It defines what keymap the keyboard is in the virtual consoles. Keytable files are provided by the kbd package."
    OPTION=n
    while [[ $OPTION != y ]]; do
      setkeymap
      read_input_text "Confirm keymap: $KEYMAP"
    done
  }
  #}}}
  #DEFAULT EDITOR {{{
  select_editor(){
    print_title "DEFAULT EDITOR"
    editors_list=("emacs" "nano" "vi" "vim");
    PS3="$prompt1"
    echo -e "Select editor\n"
    select EDITOR in "${editors_list[@]}"; do
      if contains_element "$EDITOR" "${editors_list[@]}"; then
        package_install "$EDITOR"
        break
      else
        invalid_option
      fi
    done
  }
  #}}}
  #MIRRORLIST {{{
  configure_mirrorlist(){
    local countries_code=("AU" "BY" "BE" "BR" "BG" "CA" "CL" "CN" "CO" "CZ" "DK" "EE" "FI" "FR" "DE" "GR" "HU" "IN" "IE" "IL" "IT" "JP" "KZ" "KR" "LV" "LU" "MK" "NL" "NC" "NZ" "NO" "PL" "PT" "RO" "RU" "RS" "SG" "SK" "ZA" "ES" "LK" "SE" "CH" "TW" "TR" "UA" "GB" "US" "UZ" "VN")
    local countries_name=("Australia" "Belarus" "Belgium" "Brazil" "Bulgaria" "Canada" "Chile" "China" "Colombia" "Czech Republic" "Denmark" "Estonia" "Finland" "France" "Germany" "Greece" "Hungary" "India" "Ireland" "Israel" "Italy" "Japan" "Kazakhstan" "Korea" "Latvia" "Luxembourg" "Macedonia" "Netherlands" "New Caledonia" "New Zealand" "Norway" "Poland" "Portugal" "Romania" "Russian" "Serbia" "Singapore" "Slovakia" "South Africa" "Spain" "Sri Lanka" "Sweden" "Switzerland" "Taiwan" "Turkey" "Ukraine" "United Kingdom" "United States" "Uzbekistan" "Viet Nam")
    country_list(){
      #`reflector --list-countries | sed 's/[0-9]//g' | sed 's/^/"/g' | sed 's/,.*//g' | sed 's/ *$//g'  | sed 's/$/"/g' | sed -e :a -e '$!N; s/\n/ /; ta'`
      PS3="$prompt1"
      echo "Select your country:"
      select OPT in "${countries_name[@]}"; do
        if contains_element "$OPT" "${countries_name[@]}"; then
          country=${countries_code[$(( $REPLY - 1 ))]}
          break
        else
          invalid_option
        fi
      done
    }
    package_install "wget"
    print_title "MIRRORLIST - https://wiki.archlinux.org/index.php/Mirrors"
    print_info "This option is a guide to selecting and configuring your mirrors, and a listing of current available mirrors."
    OPTION=n
    while [[ $OPTION != y ]]; do
      country_list
      read_input_text "Confirm country: $OPT"
    done

    url="https://www.archlinux.org/mirrorlist/?country=$country&protocol=ftp&protocol=http&ip_version=4&use_mirror_status=on"

    tmpfile=$(mktemp --suffix=-mirrorlist)

    # Get latest mirror list and save to tmpfile
    wget -qO- "$url" | sed 's/^#Server/Server/g' > "$tmpfile"

    # Backup and replace current mirrorlist file (if new file is non-zero)
    if [[ -s "$tmpfile" ]]
    then
     { echo " Backing up the original mirrorlist..."
       mv -i /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig; } &&
     { echo " Rotating the new list into place..."
       mv -i "$tmpfile" /etc/pacman.d/mirrorlist; }
    else
      echo " Unable to update, could not download list."
    fi
    # allow global read access (required for non-root yaourt execution)
    chmod +r /etc/pacman.d/mirrorlist
    $EDITOR /etc/pacman.d/mirrorlist
  }
  #}}}
  #CREATE PARTITION {{{
  create_partition(){
    select_device(){
      devices_list=(`parted -ls | grep 'Disk /dev/sd\|Disk /dev/hd' | awk '{print $2}' | sed 's/://'`);
      PS3="$prompt1"
      echo -e "Select device:\n"
      select DEVICE in "${devices_list[@]}"; do
        if contains_element "$DEVICE" "${devices_list[@]}"; then
          break
        else
          invalid_option
        fi
      done
    }
    print_title "https://wiki.archlinux.org/index.php/Partitioning"
    print_info "Partitioning a hard drive allows one to logically divide the available space into sections that can be accessed independently of one another. Partition information is stored within a hard drive's Master Boot Record."
    partition_app=("cfdisk" "cgdisk" "gdisk");
    PS3="$prompt1"
    echo -e "Select partition program:"
    select APP in "${partition_app[@]}"; do
      if contains_element "$APP" "${partition_app[@]}"; then
        select_device
        $APP $DEVICE
        break
      else
        invalid_option
      fi
    done
  }
  #}}}
  #FORMAT DEVICE {{{
  format_device(){
    print_title "https://wiki.archlinux.org/index.php/Format_a_device"
    print_info "This step will select and format the selected partiton where the archlinux will be installed"
    print_warning "\tAll data on the ROOT and SWAP partition will be LOST."
    i=0
    partitions=(`cat /proc/partitions | awk 'length($3)>1' | awk '{print "/dev/" $4}' | awk 'length($0)>8' | grep 'sd\|hd'`)
    device_name=("root" "swap" "another")
    select_filesystem(){
      filesystem=("ext4" "ext3" "ext2" "btrfs" "vfat" "ntfs" "jfs" "xfs");
      PS3="$prompt1"
      echo -e "Select filesystem:\n"
      select TYPE in "${filesystem[@]}"; do
        if contains_element "$TYPE" "${filesystem[@]}"; then
          break
        else
          invalid_option
        fi
      done
    }
    umount_partition(){
      #check if swap is on and umount
      swapon -s|grep $1 && swapoff $1
      #check if partition is mounted and umount
      mount|grep $1 && umount $1
    }
    remove_partition(){
      #remove the selected partition from list
      unset partitions[$DEVICE_NUMBER]
      partitions=(${partitions[@]})
      #increase i
      [[ ${device_name[i]} != another ]] && i=$(( i + 1 ))
    }
    format_partition(){
      read_input_text "Confirm format $1 partition"
      if [[ $OPTION == y ]]; then
        umount_partition "$1"
        [[ -z $3 ]] && select_filesystem
        if [[ $1 == $ROOT && $TYPE == btrfs ]]; then
          print_title "https://wiki.archlinux.org/index.php/Btrfs"
          print_info "btrfs provides a number of features (such as checksumming, snapshots, and subvolumes) that make it an excellent candidate for using it as the root partition in an Arch Linux installation."
          print_warning "This filesystem still experimental, use at your own risk.\nYou should install the bootloader in a different partition"
          pause_function
          mkfs.$TYPE $1
          mount -t $TYPE $1 $2
        else
          mkfs.$TYPE $1
          fsck $1
          mkdir -p $2
          mount -t $TYPE $1 $2
        fi
        remove_partition "$1"
      fi
    }
    format_swap_partition(){
      read_input_text "Confirm format $1 partition"
      if [[ $OPTION == y ]]; then
        umount_partition "$1"
        mkswap $1
        swapon $1
        remove_partition "$1"
      fi
    }
    function check_mountpoint(){
    if mount|grep $2; then
      echo "Successfully mounted"
      remove_partition "$1"
    else
      echo "WARNING: Not Successfully mounted"
    fi
    }
    while [[ 1 ]]; do
      PS3="$prompt1"
      echo -e "Select ${BYellow}${device_name[i]}${White} partition:\n"
      select DEVICE in "${partitions[@]}"; do
        #get the selected number - 1
        DEVICE_NUMBER=$(( $REPLY - 1 ))
        if contains_element "$DEVICE" "${partitions[@]}"; then
          case ${device_name[i]} in
            root)
              ROOT=$DEVICE
              ROOT_DEVICE=`echo $ROOT | sed 's/[0-9]//'`
              format_partition "$DEVICE" "$MOUNTPOINT"
              ;;
            swap)
              format_swap_partition "$DEVICE"
              ;;
            another)
              read -p "Mountpoint [ex: /home]:" DIR
              select_filesystem
              read_input_text "Format $DEVICE partition"
              if [[ $OPTION == y ]]; then
                format_partition "$DEVICE" "$MOUNTPOINT$DIR" "$TYPE"
              else
                read_input_text "Confirm type="$TYPE" dev="$DEVICE" dir="$DIR""
                if [[ $OPTION == y ]]; then
                  mkdir -p $MOUNTPOINT$DIR
                  mount -t $TYPE $DEVICE $MOUNTPOINT$DIR
                  check_mountpoint "$DEVICE" "$MOUNTPOINT$DIR"
                fi
              fi
              ;;
          esac
          break
        else
          invalid_option
        fi
      done
      #check if there is no partitions left
      if [[ ${#partitions[@]} == 0 ]]; then
        break
      elif [[ ${device_name[i]} == another ]]; then
        read_input_text "Configure more partitions"
        [[ $OPTION != y ]] && break
      fi
    done
    pause_function
  }
  #}}}
  #INSTALL BASE SYSTEM {{{
  install_base_system(){
    print_title "INSTALL BASE SYSTEM"
    print_info "Using the pacstrap script we install the base system. The base-devel package group will be installed also."
    pacstrap $MOUNTPOINT base base-devel btrfs-progs
    #ADD KEYMAP TO THE NEW SETUP
    echo "KEYMAP=$KEYMAP" > $MOUNTPOINT/etc/vconsole.conf
    echo "FONT=\"\"" >> $MOUNTPOINT/etc/vconsole.conf
    echo "FONT_MAP=\"\"" >> $MOUNTPOINT/etc/vconsole.conf
  }
  #}}}
  #CONFIGURE FSTAB {{{
  configure_fstab(){
    print_title "FSTAB - https://wiki.archlinux.org/index.php/Fstab"
    print_info "The /etc/fstab file contains static filesystem information. It defines how storage devices and partitions are to be mounted and integrated into the overall system. It is read by the mount command to determine which options to use when mounting a specific device or partition."
    if [[ ! -f $MOUNTPOINT/etc/fstab.aui ]]; then
      cp $MOUNTPOINT/etc/fstab $MOUNTPOINT/etc/fstab.aui
    else
      cp $MOUNTPOINT/etc/fstab.aui $MOUNTPOINT/etc/fstab
    fi
    FSTAB=("DEV" "UUID" "LABEL");
    PS3="$prompt1"
    echo -e "Configure fstab based on:"
    select OPT in "${FSTAB[@]}"; do
      case "$REPLY" in
        1)
          genfstab -p $MOUNTPOINT >> $MOUNTPOINT/etc/fstab
          break
          ;;
        2)
          genfstab -U $MOUNTPOINT >> $MOUNTPOINT/etc/fstab
          break
          ;;
        3)
          genfstab -L $MOUNTPOINT >> $MOUNTPOINT/etc/fstab
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    echo "Review your fstab"
    pause_function
    $EDITOR $MOUNTPOINT/etc/fstab
  }
  #}}}
  #CONFIGURE HOSTNAME {{{
  configure_hostname(){
    print_title "HOSTNAME - https://wiki.archlinux.org/index.php/HOSTNAME"
    print_info "A host name is a unique name created to identify a machine on a network.Host names are restricted to alphanumeric characters.\nThe hyphen (-) can be used, but a host name cannot start or end with it. Length is restricted to 63 characters."
    read -p "Hostname [ex: archlinux]: " HN
    echo "$HN" > $MOUNTPOINT/etc/hostname
    if [[ ! -f $MOUNTPOINT/etc/hosts.aui ]]; then
      cp $MOUNTPOINT/etc/hosts $MOUNTPOINT/etc/hosts.aui
    else
      cp $MOUNTPOINT/etc/hosts.aui $MOUNTPOINT/etc/hosts
    fi
    chroot $MOUNTPOINT sed -i '/127.0.0.1/s/$/ '$HN'/' /etc/hosts
    chroot $MOUNTPOINT sed -i '/::1/s/$/ '$HN'/' /etc/hosts
  }
  #}}}
  #CONFIGURE TIMEZONE {{{
  configure_timezone(){
    settimezone(){
      [[ -f $MOUNTPOINT/etc/localtime ]] && rm $MOUNTPOINT/etc/localtime;
      local zone=("Africa" "America" "Antarctica" "Arctic" "Asia" "Atlantic" "Australia" "Brazil" "Canada" "Chile" "Europe" "Indian" "Mexico" "Midest" "Pacific" "US");
      PS3="$prompt1"
      echo "Select zone:"
      select ZONE in "${zone[@]}"; do
        if contains_element "$ZONE" "${zone[@]}"; then
          local subzone=(`ls /usr/share/zoneinfo/$ZONE/`)
          PS3="$prompt1"
          echo "Select subzone:"
          select SUBZONE in "${subzone[@]}"; do
            if contains_element "$SUBZONE" "${subzone[@]}"; then
              chroot $MOUNTPOINT ln -s /usr/share/zoneinfo/$ZONE/$SUBZONE /etc/localtime
              break
            else
              invalid_option
            fi
          done
          break
        else
          invalid_option
        fi
      done
    }
    print_title "TIMEZONE - https://wiki.archlinux.org/index.php/Timezone"
    print_info "In an operating system the time (clock) is determined by four parts: Time value, Time standard, Time Zone, and DST (Daylight Saving Time if applicable)."
    OPTION=n
    while [[ $OPTION != y ]]; do
      settimezone
      read_input_text "Confirm timezone ($ZONE/$SUBZONE)"
    done
    chroot $MOUNTPOINT echo "$ZONE/$SUBZONE" > /etc/timezone
  }
  #}}}
  #CONFIGURE HARDWARECLOCK {{{
  configure_hardwareclock(){
    print_title "HARDWARE CLOCK TIME - https://wiki.archlinux.org/index.php/Internationalization"
    print_info "This is set in /etc/adjtime. Set the hardware clock mode uniformly between your operating systems on the same machine. Otherwise, they will overwrite the time and cause clock shifts (which can cause time drift correction to be miscalibrated)."
    echo -e $prompt3
    echo -e "You can replace ${BYellow}--utc${White} for ${BYellow}--localtime${White} (discouraged)."
    print_warning "hwclock --systohc --utc"
    arch-chroot $MOUNTPOINT
  }
  #}}}
  #CONFIGURE LOCALE {{{
  configure_locale(){
    print_title "LOCALE - https://wiki.archlinux.org/index.php/Locale"
    print_info "Locales are used in Linux to define which language the user uses. As the locales define the character sets being used as well, setting up the correct locale is especially important if the language contains non-ASCII characters."
    read -p "Locale [ex: pt_BR]: " LOCALE
    LOCALE_8859="$LOCALE ISO-8859"
    LOCALE_UTF8="$LOCALE.UTF-8"
    echo 'LANG="'$LOCALE_UTF8'"' > $MOUNTPOINT/etc/locale.conf
    chroot $MOUNTPOINT sed -i '/'$LOCALE'/s/^#//' /etc/locale.gen
    echo -e $prompt3
    print_warning "locale-gen"
    arch-chroot $MOUNTPOINT
  }
  #}}}
  #CONFIGURE MKINITCPIO {{{
  configure_mkinitcpio(){
    print_title "MKINITCPIO - https://wiki.archlinux.org/index.php/Mkinitcpio"
    print_info "mkinitcpio is a Bash script used to create an initial ramdisk environment."
    echo -e $prompt3
    print_warning "mkinitcpio -p linux"
    arch-chroot $MOUNTPOINT
  }
  #}}}
  #INSTALL BOOTLOADER {{{
  install_bootloader(){
    print_title "BOOTLOADER - https://wiki.archlinux.org/index.php/Bootloader"
    print_info "The boot loader is responsible for loading the kernel and initial RAM disk before initiating the boot process."
    bootloader=("Grub2" "Syslinux" "Skip")
    PS3="$prompt1"
    echo -e "Install bootloader:\n"
    select BOOTLOADER in "${bootloader[@]}"; do
      case "$REPLY" in
        1)
          # IS UEFI MODE {{{
          is_uefi_or_bios()
          {
            if [[ "$(cat /sys/class/dmi/id/sys_vendor)" == 'Apple Inc.' ]] || [[ "$(cat /sys/class/dmi/id/sys_vendor)" == 'Apple Computer, Inc.' ]]; then
              modprobe -r -q efivars || true  # if MAC
            else
              modprobe -q efivars             # all others
            fi
            if [ -d "/sys/firmware/efi/vars/" ]; then
              UEFI=1
              echo "UEFI Mode detected"
              if [[ $ARCHI == i686 ]]; then
                pacstrap $MOUNTPOINT grub-efi-i386
              else
                pacstrap $MOUNTPOINT grub-efi-x86_64
              fi
            else
              UEFI=0
              echo "BIOS Mode detected"
              pacstrap $MOUNTPOINT grub-bios
            fi
          }
          #}}}
          is_uefi_or_bios
          #make grub automatically detect others OS
          pacstrap $MOUNTPOINT os-prober
          break
          ;;
        2)
          pacstrap $MOUNTPOINT syslinux
          break
          ;;
        3)
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
  }
  #}}}
  #CONFIGURE BOOTLOADER {{{
  configure_bootloader(){
    case $BOOTLOADER in
      Grub2)
        print_title "GRUB2 - https://wiki.archlinux.org/index.php/GRUB2"
        print_info "GRUB2 is the next generation of the GRand Unified Bootloader (GRUB).\nIn brief, the bootloader is the first software program that runs when a computer starts. It is responsible for loading and transferring control to the Linux kernel."
        echo -e $prompt3
        if [[ $UEFI == 1 ]]; then
          print_warning "modprobe dm-mod\ngrub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck\ngrub-mkconfig -o /boot/grub/grub.cfg"
        else
          print_warning "modprobe dm-mod\ngrub-install --target=i386-pc --recheck $ROOT_DEVICE\ngrub-mkconfig -o /boot/grub/grub.cfg"
        fi
        arch-chroot $MOUNTPOINT
        chroot $MOUNTPOINT mkdir -p /boot/grub/locale
        chroot $MOUNTPOINT cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
        ;;
      Syslinux)
        print_title "SYSLINUX - https://wiki.archlinux.org/index.php/Syslinux"
        print_info "Syslinux is a collection of boot loaders capable of booting from hard drives, CDs, and over the network via PXE. It supports the fat, ext2, ext3, ext4, and btrfs file systems."
        echo -e $prompt3
        print_warning "syslinux-install_update -iam\n$EDITOR /boot/syslinux/syslinux.cfg"
        arch-chroot $MOUNTPOINT
        ;;
    esac
  }
  #}}}
  #ROOT PASSWORD {{{
  root_password(){
    print_title "ROOT PASSWORD"
    print_warning "Enter your new root password"
    chroot $MOUNTPOINT passwd
    pause_function
  }
  #}}}
  #FINISH {{{
  finish(){
    print_title "INSTALL COMPLETED"
    #COPY AUI TO ROOT FOLDER IN THE NEW SYSTEM
    print_warning "\nA copy of the AUI will be placed in /root directory of your new system"
    cp -R `pwd` $MOUNTPOINT/root
    read_input_text "Reboot system"
    if [[ $OPTION == y ]]; then
      #umount mounted partitions
      mounted_partitions=(`findmnt --fstab -o TARGET -t noswap,notmpfs | grep /mnt`)
      for i in ${mounted_partitions[@]}; do
        umount $i
      done
      reboot
    fi
    exit 0
  }
  #}}}

  print_title "https://wiki.archlinux.org/index.php/Arch_Install_Scripts"
  print_info "The Arch Install Scripts are a set of Bash scripts that simplify Arch installation."
  pause_function
  pacman -Sy
  while [[ 1 ]]
  do
    print_title "ARCHLINUX ULTIMATE INSTALL - https://github.com/helmuthdu/aui"
    echo " 1) $(mainmenu_item "${checklist[1]}" "Configure Keymap")"
    echo " 2) $(mainmenu_item "${checklist[2]}" "Select Editor")"
    echo " 3) $(mainmenu_item "${checklist[3]}" "Configure Mirrorlist")"
    echo " 4) $(mainmenu_item "${checklist[4]}" "Create Partition")"
    echo " 5) $(mainmenu_item "${checklist[5]}" "Format Device")"
    echo " 6) $(mainmenu_item "${checklist[6]}" "Install Base System")"
    echo " 7) $(mainmenu_item "${checklist[7]}" "Configure Fstab")"
    echo " 8) $(mainmenu_item "${checklist[8]}" "Configure Hostname")"
    echo " 9) $(mainmenu_item "${checklist[9]}" "Configure Timezone")"
    echo "10) $(mainmenu_item "${checklist[10]}" "Configure Hardware Clock")"
    echo "11) $(mainmenu_item "${checklist[11]}" "Configure Locale")"
    echo "12) $(mainmenu_item "${checklist[12]}" "Configure Mkinitcpio")"
    echo "13) $(mainmenu_item "${checklist[13]}" "Install Bootloader")"
    echo "14) $(mainmenu_item "${checklist[14]}" "Root Password")"
    echo ""
    echo " d) Done"
    echo ""
    read_input_options
    for OPT in ${OPTIONS[@]}; do
      case "$OPT" in
        1)
          configure_keymap
          checklist[1]=1
          ;;
        2)
          select_editor
          checklist[2]=1
          ;;
        3)
          configure_mirrorlist
          checklist[3]=1
          ;;
        4)
          create_partition
          checklist[4]=1
          ;;
        5)
          format_device
          checklist[5]=1
          ;;
        6)
          install_base_system
          checklist[6]=1
          ;;
        7)
          configure_fstab
          checklist[7]=1
          ;;
        8)
          configure_hostname
          checklist[8]=1
          ;;
        9)
          configure_timezone
          checklist[9]=1
          ;;
        10)
          configure_hardwareclock
          checklist[10]=1
          ;;
        11)
          configure_locale
          checklist[11]=1
          ;;
        12)
          configure_mkinitcpio
          checklist[12]=1
          ;;
        13)
          install_bootloader
          configure_bootloader
          checklist[13]=1
          ;;
        14)
          root_password
          checklist[14]=1
          ;;
        "d")
          finish
          ;;
        *)
          invalid_option
          ;;
      esac
    done
  done
  ;;
  #}}}
  --help  | -h)
  #HELP {{{
  echo "Usage: "  1>&2
  echo " aui               - install programs and other stuffs, aka default mode"  1>&2
  echo " aui --ais         - archlinux install scripts mode"  1>&2
  echo "Options: "  1>&2
  echo " -v, --verbose     - Enable verbose in default mode"  1>&2
  echo " --help            - print this help text"  1>&2
  echo ""
  exit 1
  ;;
  #}}}
  *)
  #ARCHLINUX ULTIMATE INSTALL {{{
  #WELCOME {{{
  welcome(){
    clear
    echo -e "${BWhite}Welcome to the Archlinux Ultimate install script by helmuthdu${White}"
    print_line
    echo "Requirements:"
    echo "-> Archlinux installation"
    echo "-> Run script as root user"
    echo "-> Working internet connection"
    print_line
    echo "Script can be cancelled at any time with CTRL+C"
    print_line
    echo "This version is still in BETA. Send bugreports to: "
    echo "http://www.github.com/helmuthdu/aui"
    print_line
    echo -e "\nBackups:"
    print_line
    # backup old configs
    [[ ! -f /etc/pacman.conf.aui ]] && cp -v /etc/pacman.conf /etc/pacman.conf.aui || echo "/etc/pacman.conf.aui";
    [[ -f /etc/ssh/sshd_config.aui ]] && echo "/etc/ssh/sshd_conf.aui";
    [[ -f /etc/X11/xorg.conf.d/10-evdev.conf.aui ]] && echo "/etc/X11/xorg.conf.d/10-evdev.conf.aui";
    pause_function
    echo ""
  }
  #}}}
  #LANGUAGE SELECTOR {{{
  language_selector(){
    #AUTOMATICALLY DETECTS THE SYSTEM LANGUAGE {{{
    #automatically detects the system language based on your locale
    LANGUAGE=`locale | sed '1!d' | sed 's/LANG=//' | cut -c1-5`
    #KDE #{{{
    if [[ $LANGUAGE == pt_BR || $LANGUAGE == en_GB || $LANGUAGE == zh_CN ]]; then
      LANGUAGE_KDE=`echo $LANGUAGE | tr '[:upper:]' '[:lower:]'`
    elif [[ $LANGUAGE == en_US ]]; then
      LANGUAGE_KDE="en_gb"
    else
      LANGUAGE_KDE=`echo $LANGUAGE | cut -d\_ -f1`
    fi
    #}}}
    #FIREFOX #{{{
    if [[ $LANGUAGE == pt_BR || $LANGUAGE == pt_PT || $LANGUAGE == en_GB || $LANGUAGE == es_AR || $LANGUAGE == es_ES || $LANGUAGE == zh_CN ]]; then
      LANGUAGE_FF=`echo $LANGUAGE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
    elif [[ $LANGUAGE == en_US ]]; then
      LANGUAGE_FF="en-gb"
    else
      LANGUAGE_FF=`echo $LANGUAGE | cut -d\_ -f1`
    fi
    #}}}
    #HUNSPELL #{{{
    if [[ $LANGUAGE == pt_BR ]]; then
      LANGUAGE_HS=`echo $LANGUAGE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
    elif [[ $LANGUAGE == pt_PT ]]; then
      LANGUAGE_HS="pt_pt"
    else
      LANGUAGE_HS=`echo $LANGUAGE | cut -d\_ -f1`
    fi
    #}}}
    #ASPELL #{{{
    LANGUAGE_AS=`echo $LANGUAGE | cut -d\_ -f1`
    #}}}
    #LIBREOFFICE #{{{
    if [[ $LANGUAGE == pt_BR || $LANGUAGE == en_GB || $LANGUAGE == en_US || $LANGUAGE == zh_CN ]]; then
      LANGUAGE_LO=`echo $LANGUAGE | sed 's/_/-/'`
    else
      LANGUAGE_LO=`echo $LANGUAGE | cut -d\_ -f1`
    fi
    #}}}
    #}}}
    print_title "LANGUAGE - https://wiki.archlinux.org/index.php/Locale"
    read_input_text "Default system language: \"$LANGUAGE\""
    case "$OPTION" in
      "n")
        read -p "New system language [ex: en_US]: " LANGUAGE
        #KDE #{{{
        if [[ $LANGUAGE == pt_BR || $LANGUAGE == en_GB || $LANGUAGE == zh_CN ]]; then
          LANGUAGE_KDE=`echo $LANGUAGE | tr '[:upper:]' '[:lower:]'`
        elif [[ $LANGUAGE == en_US ]]; then
          LANGUAGE_KDE="en_gb"
        else
          LANGUAGE_KDE=`echo $LANGUAGE | cut -d\_ -f1`
        fi
        #}}}
        #FIREFOX #{{{
        if [[ $LANGUAGE == pt_BR || $LANGUAGE == pt_PT || $LANGUAGE == en_GB || $LANGUAGE == es_AR || $LANGUAGE == es_ES || $LANGUAGE == zh_CN ]]; then
          LANGUAGE_FF=`echo $LANGUAGE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
        elif [[ $LANGUAGE == en_US ]]; then
          LANGUAGE_FF="en-gb"
        else
          LANGUAGE_FF=`echo $LANGUAGE | cut -d\_ -f1`
        fi
        #}}}
        #HUNSPELL #{{{
        if [[ $LANGUAGE == pt_BR ]]; then
          LANGUAGE_HS=`echo $LANGUAGE | tr '[:upper:]' '[:lower:]' | sed 's/_/-/'`
        elif [[ $LANGUAGE == pt_PT ]]; then
          LANGUAGE_HS="pt_pt"
        else
          LANGUAGE_HS=`echo $LANGUAGE | cut -d\_ -f1`
        fi
        #}}}
        #ASPELL #{{{
        LANGUAGE_AS=`echo $LANGUAGE | cut -d\_ -f1`
        #}}}
        #LIBREOFFICE #{{{
        if [[ $LANGUAGE == pt_BR || $LANGUAGE == en_GB || $LANGUAGE == en_US || $LANGUAGE == zh_CN ]]; then
          LANGUAGE_LO=`echo $LANGUAGE | sed 's/_/-/'`
        else
          LANGUAGE_LO=`echo $LANGUAGE | cut -d\_ -f1`
        fi
        #}}}
        ;;
      *)
        ;;
    esac
    pause_function
  }
  #}}}
  #SELECT/CREATE USER {{{
  select_user(){
    #CREATE NEW USER {{{
    create_new_user(){
      read -p "Username: " USER_NAME
      useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner,network -s /bin/bash ${USER_NAME}
      chfn ${USER_NAME}
      passwd ${USER_NAME}
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
            git clone https://github.com/helmuthdu/dotfiles
            cp dotfiles/.bashrc dotfiles/.dircolors dotfiles/.dircolors_256 dotfiles/.nanorc ~/
            cp dotfiles/.bashrc dotfiles/.dircolors dotfiles/.dircolors_256 dotfiles/.nanorc /home/${USER_NAME}/
            mkdir -p /home/${USER_NAME}/.config/fontconfig
            cp -i dotfiles/fonts.conf /home/${USER_NAME}/.config/fontconfig
            rm -fr dotfiles
            break
            ;;
          2)
            cp /etc/skel/.bashrc /home/${USER_NAME}
            break
            ;;
          3)
            package_install "git"
            read -p "Enter your github username [ex: helmuthdu]: " GITHUB_USER
            read -p "Enter your github repository [ex: aui]: " GITHUB_REPO
            git clone https://github.com/$GITHUB_USER/$GITHUB_REPO
            cp -R $GITHUB_REPO/.* /home/${USER_NAME}/
            rm -fr $GITHUB_REPO
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      #}}}
      #EDITOR {{{
      print_title "DEFAULT EDITOR"
      editors_list=("emacs" "joe" "nano" "vi" "vim" "zile");
      PS3="$prompt1"
      echo -e "Select editor\n"
      select EDITOR in "${editors_list[@]}"; do
        if contains_element "$EDITOR" "${editors_list[@]}"; then
          if [[ $EDITOR == joe ]]; then
            ! is_package_installed "joe" && aui_download_packages "joe"
          elif [[ $EDITOR == vim ]]; then
            ! is_package_installed "gvim" && package_install "vim ctags"
            #VIMRC {{{
            vimrc_list=("Default" "Vanilla" "Get from github");
            PS3="$prompt1"
            echo -e "Choose your .vimrc\n"
            select OPT in "${vimrc_list[@]}"; do
              case "$REPLY" in
                1)
                  package_install "git"
                  git clone https://github.com/helmuthdu/vim
                  mv vim /home/${USER_NAME}/.vim
                  ln -sf /home/${USER_NAME}/.vim/vimrc /home/${USER_NAME}/.vimrc
                  break
                  ;;
                2)
                  break
                  ;;
                3)
                  package_install "git"
                  read -p "Enter your github username [ex: helmuthdu]: " GITHUB_USER
                  read -p "Enter your github repository [ex: vim]: " GITHUB_REPO
                  git clone https://github.com/$GITHUB_USER/$GITHUB_REPO
                  cp -R $GITHUB_REPO/.vim /home/${USER_NAME}/
                  if [[ -f $GITHUB_REPO/.vimrc ]]; then
                    cp $GITHUB_REPO/.vimrc /home/${USER_NAME}/
                  else
                    ln -sf /home/${USER_NAME}/.vim/vimrc /home/${USER_NAME}/.vimrc
                  fi
                  rm -fr $GITHUB_REPO
                  break
                  ;;
                *)
                  invalid_option
                  ;;
              esac
            done
            #}}}
          else
            package_install "$EDITOR"
          fi
          break
        else
          invalid_option
        fi
      done
      echo "EDITOR=\"$EDITOR\"" >> /home/${USER_NAME}/.bashrc
      #}}}
      chown -R ${USER_NAME}:users /home/${USER_NAME}
    }
    #}}}
    print_title "SELECT/CREATE USER ACCOUNT - https://wiki.archlinux.org/index.php/Users_and_Groups"
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
        break
      elif contains_element "$OPT" "${users_list[@]}"; then
        USER_NAME=$OPT
        break
      else
        invalid_option
      fi
    done
    [[ ! -f /home/${USER_NAME}/.bashrc ]] && configure_user_account;
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
      echo 'Defaults timestamp_timeout=300' >> /etc/sudoers
      echo 'Defaults passprompt="[sudo] password for %u: "' >> /etc/sudoers
    fi
    #}}}
  }
  #}}}
  #AUR HELPER {{{
  choose_aurhelper(){
    print_title "AUR HELPER - https://wiki.archlinux.org/index.php/AUR_Helpers"
    print_info "AUR Helpers are written to make using the Arch User Repository more comfortable."
    print_warning "\tNone of these tools are officially supported by Arch devs."
    aurhelper=("Yaourt (recommended)" "Packer" "Pacaur")
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
          AUR_HELPER="yaourt"
          break
          ;;
        2)
          if ! is_package_installed "packer" ; then
            package_install "base-devel git jshon"
            pacman -D --asdeps jshon
            aui_download_packages "packer"
            if ! is_package_installed "packer" ; then
              echo "Packer not installed. EXIT now"
              pause_function
              exit 0
            fi
          fi
          AUR_HELPER="packer"
          break
          ;;
        3)
          if ! is_package_installed "pacaur" ; then
            package_install "base-devel yajl expac"
            pacman -D --asdeps yajl expac
            #fix pod2man path
            ln -s /usr/bin/core_perl/pod2man /usr/bin/
            aui_download_packages "cower pacaur"
            pacman -D --asdeps cower
            if ! is_package_installed "pacaur" ; then
              echo "Pacaur not installed. EXIT now"
              pause_function
              exit 0
            fi
          fi
          AUR_HELPER="pacaur"
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
    pause_function
  }
  #}}}
  #CUSTOM REPOSITORIES {{{
  add_custom_repositories(){
    # ENABLE MULTILIB REPOSITORY {{{
    # this option will avoid any problem with packages install
    if [[ $ARCHI == x86_64 ]]; then
      multilib=`grep -n "\[multilib\]" /etc/pacman.conf | cut -f1 -d:`
      if $multilib &> /dev/null; then
        echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
        echo -e '\nMultilib repository added into pacman.conf file'
      else
        sed -i "${multilib}s/^#//" /etc/pacman.conf
        multilib=$(( $multilib + 2 ))
        sed -i "${multilib}s/^#//" /etc/pacman.conf
      fi
      pacman -Sy
    fi
    #}}}
    print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
    read_input_text "Add custom repositories" $CUSTOMREPO
    if [[ $OPTION == y ]]; then
      while [[ 1 ]]
      do
        print_title "CUSTOM REPOSITORIES - https://wiki.archlinux.org/index.php/Unofficial_User_Repositories"
        echo " 1) \"Add new repository\""
        echo ""
        echo " d) DONE"
        echo ""
        read -p "$prompt1" OPTION
        case $OPTION in
          1)
            read -p "Repository Name [ex: custom]: " REPONAME
            read -p "Repository Address [ex: file:///media/backup/Archlinux]: " REPOADDRESS
            echo -e '\n['"$REPONAME"']\nServer = '"$REPOADDRESS"/'$arch' >> /etc/pacman.conf
            echo -e '\nCustom repository added into pacman.conf file'
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
      ncecho "${BBlue}==>${White} Syncing repositories "
      pacman -Syy >>"$LOG" 2>&1 &
      pid=$!;progress $pid
      pause_function
    fi
  }
  #}}}
  #AUTOMATIC MODE {{{
  automatic_mode(){
    print_title "AUTOMATIC MODE"
    print_info "Create a custom install with all options pre-selected.\nUse this option with care."
    print_warning "\tUse this mode only if you already know all the option.\n\tYou won't be able to select anything later."
    read_input_text "Enable Automatic Mode"
    if [[ $OPTION == y ]]; then
      [[ -f packages_not_installed.txt ]] && rm packages_not_installed.txt;
      $EDITOR auiscript
      source auiscript
      echo -e "The installation will start now."
      pause_function
      AUTOMATIC_MODE=1
    fi
  }
  #}}}
  #BASIC SETUP {{{
  install_basic_setup(){
    print_title "SYSTEMD - https://wiki.archlinux.org/index.php/Systemd"
    print_info "systemd is a replacement for the init daemon for Linux (either System V or BSD-style). It is intended to provide a better framework for expressing services' dependencies, allow more work to be done in parallel at system startup, and to reduce shell overhead."
    package_install "systemd systemd-sysvcompat"
    systemctl enable cronie.service
    print_title "BASH TOOLS - https://wiki.archlinux.org/index.php/Bash"
    package_install "bc rsync mlocate bash-completion ntp pkgstats"
    systemctl enable ntpd.service
    pause_function
    print_title "DBUS - https://wiki.archlinux.org/index.php/D-Bus"
    print_info "D-Bus is a message bus system that provides an easy way for inter-process communication. It consists of a daemon, which can be run both system-wide and for each user session, and a set of libraries to allow applications to use D-Bus."
    package_install "dbus"
    pause_function
    print_title "(UN)COMPRESS TOOLS - https://wiki.archlinux.org/index.php/P7zip"
    package_install "zip unzip unrar p7zip"
    pause_function
    print_title "AVAHI - https://wiki.archlinux.org/index.php/Avahi"
    print_info "Avahi is a free Zero Configuration Networking (Zeroconf) implementation, including a system for multicast DNS/DNS-SD service discovery. It allows programs to publish and discover services and hosts running on a local network with no specific configuration."
    package_install "avahi nss-mdns"
    is_package_installed "avahi" && systemctl enable avahi-daemon.service
    is_package_installed "avahi" && systemctl enable avahi-dnsconfd.service
    pause_function
    print_title "ACPI - https://wiki.archlinux.org/index.php/ACPI_modules"
    print_info "acpid is a flexible and extensible daemon for delivering ACPI events."
    package_install "acpi acpid"
    is_package_installed "acpid" && systemctl enable acpid.service
    pause_function
    print_title "ALSA - https://wiki.archlinux.org/index.php/Alsa"
    print_info "The Advanced Linux Sound Architecture (ALSA) is a Linux kernel component intended to replace the original Open Sound System (OSSv3) for providing device drivers for sound cards."
    package_install "alsa-utils alsa-plugins"
    if [[ ${ARCHI} == x86_64 ]]; then
      package_install "lib32-alsa-plugins"
    fi
    add_module "snd-usb-audio"
    pause_function
    print_title "PULSEAUDIO - https://wiki.archlinux.org/index.php/Pulseaudio"
    print_info "PulseAudio is the default sound server that serves as a proxy to sound applications using existing kernel sound components like ALSA or OSS"
    package_install "pulseaudio pulseaudio-alsa"
    if [[ ${ARCHI} == x86_64 ]]; then
      package_install "lib32-libpulse"
    fi
    local CONFIG_PULSEAUDIO=`cat /etc/pulse/default.pa | grep module-switch-on-connect`
    [[ -z $CONFIG_PULSEAUDIO ]] && echo -e "# automatically switch to newly-connected devices\nload-module module-switch-on-connect" >> /etc/pulse/default.pa
    pause_function
    print_title "NTFS/FAT/exFAT - https://wiki.archlinux.org/index.php/File_Systems"
    print_info "A file system (or filesystem) is a means to organize data expected to be retained after a program terminates by providing procedures to store, retrieve and update data, as well as manage the available space on the device(s) which contain it. A file system organizes data in an efficient manner and is tuned to the specific characteristics of the device."
    package_install "ntfs-3g ntfsprogs dosfstools exfat-utils fuse fuse-exfat"
    is_package_installed "fuse" && add_module "fuse"
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
      aur_package_install "rssh"
      systemctl enable sshd.service
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
        sed -i '/HostbasedAuthentication/s/^#//' /etc/ssh/sshd_config
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
      systemctl enable rpc-statd.service
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
      package_install "samba"
      cp /etc/samba/smb.conf.default /etc/samba/smb.conf
      systemctl enable smbd.service
      systemctl enable nmbd.service
      systemctl enable winbindd.service
      pause_function
    fi
  }
  #}}}
  #PRELOAD {{{
  install_preload(){
    print_title "PRELOAD - https://wiki.archlinux.org/index.php/Preload"
    print_info "Preload is a program which runs as a daemon and records statistics about usage of programs using Markov chains; files of more frequently-used programs are, during a computer's spare time, loaded into memory. This results in faster startup times as less data needs to be fetched from disk. preload is often paired with prelink."
    read_input_text "Install Preload" $PRELOAD
    if [[ $OPTION == y ]]; then
      package_install "preload"
      systemctl enable preload.service
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
      systemctl enable zramswap.service
      pause_function
    fi
  }
  #}}}
  #LAPTOP MODE TOOLS {{{
  install_lmt(){
    print_title "LAPTOP MODE TOOLS- https://wiki.archlinux.org/index.php/Laptop_Mode_Tools"
    print_info "Laptop Mode Tools is a laptop power saving package for Linux systems. It is the primary way to enable the Laptop Mode feature of the Linux kernel, which lets your hard drive spin down. In addition, it allows you to tweak a number of other power-related settings using a simple configuration file."
    read_input_text "Install Laptop Mode Tools" $LMT
    if [[ $OPTION == y ]]; then
      package_install "laptop-mode-tools"
      systemctl enable laptop-mode.service
      pause_function
    fi
  }
  #}}}
  #UFW {{{
  install_ufw(){
    print_title "UFW - https://wiki.archlinux.org/index.php/Uncomplicated_Firewall"
    print_info "Uncomplicated Firewall (ufw) is a simple frontend for iptables that is designed to be easy to use."
    read_input_text "Install ufw" $UFW
    if [[ $OPTION == y ]]; then
      package_install "ufw"
      systemctl enable ufw
      pause_function
    fi
  }
  #}}}
  #XORG {{{
  install_xorg(){
    print_title "XORG - https://wiki.archlinux.org/index.php/Xorg"
    print_info "Xorg is the public, open-source implementation of the X window system version 11."
    echo "Installing X-Server (req. for Desktopenvironment, GPU Drivers, Keyboardlayout,...)"
    package_install "xorg-server xorg-xinit xorg-xkill xorg-setxkbmap"
    package_install "xf86-input-synaptics xf86-input-mouse xf86-input-keyboard"
    package_install "mesa"
    package_install "gamin"
    [[ ! -f /etc/X11/xorg.conf.d/10-evdev.conf.aui ]] && cp -v /etc/X11/xorg.conf.d/10-evdev.conf /etc/X11/xorg.conf.d/10-evdev.conf.aui;
    #CONFIGURE QWERTY KEYBOARD IN XORG {{{
    local file="/etc/X11/xorg.conf.d/10-evdev.conf"
    #get the line number that has "keyboard" in 10-evdev.conf
    local line=`grep -n "keyboard" $file | cut -f1 -d:`
    #sum that line with more 2, it will insert the patch there
    local line=$(( $line + 2 ))
    #variable to check if the file wasnt already patched
    local patch=`cat $file | sed ''$(( $line + 1 ))'!d'`
    #get the keymap from rc.conf
    local keymap=`cat /etc/vconsole.conf | sed -n '/KEYMAP[=]/p' | sed 's/KEYMAP=//'`
    #check if the file wasnt already patched
    if [[ $patch != *"XkbLayout"* ]]; then
      if [[ $keymap == us-acentos ]]; then
        kblayout="\\\tOption \"XkbLayout\" \"us_intl\""
      else
        case "$LANGUAGE" in
          de_DE)
            kblayout="\\\tOption \"XkbLayout\" \"de\""
            ;;
          es_ES | es_CL)
            KBLAYOUT=("es" "latam");
            PS3="$prompt1"
            echo -e "Select keyboard layout:"
            select KBRD in "${KBLAYOUT[@]}"; do
              if contains_element "$KBRD" "${KBLAYOUT[@]}"; then
                kblayout="\\\tOption \"XkbLayout\" \"$KBRD\""
                break
              else
                invalid_option
              fi
            done
            ;;
          it_IT)
            kblayout="\\\tOption \"XkbLayout\" \"it\""
            kblayout+="\n\\tOption \"XkbOptions\" \"terminate:ctrl_alt_bksp\""
            ;;
          fr_FR)
            kblayout="\\\tOption \"XkbLayout\" \"fr\""
            ;;
          pt_BR)
            kblayout="\\\tOption \"XkbLayout\" \"br\""
            kblayout+="\n\\tOption \"XkbVariant\" \"abnt2\""
            ;;
          pt_PT)
            kblayout="\\\tOption \"XkbLayout\" \"pt-latin9\""
            ;;
        esac
      fi
      #patch file
      sed -i "${line}a $kblayout" $file
    fi
    #}}}
    pause_function
    #FONT CONFIGURATION PRESETS {{{
    print_title "FONT CONFIGURATION - https://wiki.archlinux.org/index.php/Font_Configuration"
    print_info "Fontconfig is a library designed to provide a list of available fonts to applications, and also for configuration for how fonts get rendered."
    #enable global fonts configs
    cd /etc/fonts/conf.d
    ln -sv ../conf.avail/10-sub-pixel-rgb.conf
    #ln -sv ../conf.avail/10-autohint.conf
    ln -sv ../conf.avail/11-lcdfilter-default.conf
    ln -s ../conf.avail/70-no-bitmaps.conf
    cd $AUI_DIR
    #}}}
    pause_function
  }
  #}}}
  #VIDEO CARDS {{{
  install_video_cards(){
    package_install "dmidecode"
    VIRTUALBOX_GUEST=`dmidecode --type 1 | grep VirtualBox`
    print_title "VIDEO CARD"
    check_vga
    if [[ -n ${VIRTUALBOX_GUEST} ]]; then
      package_install "virtualbox-guest-utils"
      add_module "vboxguest vboxsf vboxvideo" "virtualbox-guest"
      add_user_to_group ${USER_NAME} vboxsf
      systemctl disable ntpd.service
      systemctl enable vboxservice.service
    elif [[ ${NVIDIA} -eq 1 ]]; then
      pacman -Rcsn $(pacman -Qe | grep xf86-video | awk '{print $1}')
      pacman -S --needed nvidia{,-utils}
      #fix nvidia-settings open
      package_install "pangox-compat"
      package_install "libva-vdpau-driver"
      if [[ ${ARCHI} == x86_64 ]]; then
        package_install "lib32-nvidia-utils"
      fi
      sed -i 's/options nouveau modeset=1/#options nouveau modeset=1/' /etc/modprobe.d/modprobe.conf
      sed -i 's/MODULES="nouveau"/#MODULES="nouveau"/' /etc/mkinitcpio.conf
      mkinitcpio -p linux
    elif [[ ${ATI} -eq 1 ]]; then
      package_install "linux-headers"
      pacman -Rcsn $(pacman -Qe | grep xf86-video | awk '{print $1}')
      pacman -S --needed catalyst-dkms
      if [[ ${ARCHI} == x86_64 ]]; then
        package_install "lib32-catalyst-utils"
      fi
    elif [[ -n ${VIDEO_DRIVER} ]]; then
      is_package_installed "nvidia" && pacman -Rdds --noconfirm nvidia{,-utils}
      pacman -S --asdeps libgl
      package_install "xf86-video-${VIDEO_DRIVER} ${VIDEO_DRIVER}-dri ${VIDEO_DRIVER}"
      if [[ ${ARCHI} == x86_64 ]]; then
        package_install "lib32-${VIDEO_DRIVER}-dri"
      fi
      if [[ ${VIDEO_DRIVER} == nouveau ]]; then
        sed -i 's/#*options nouveau modeset=1/options nouveau modeset=1/' /etc/modprobe.d/modprobe.conf
        sed -i 's/#*MODULES="nouveau"/MODULES="nouveau"/' /etc/mkinitcpio.conf
        mkinitcpio -p linux
      else [[ ${VIDEO_DRIVER} == radeon ]]
        add_module "${VIDEO_DRIVER}"
      fi
    else
      package_install "xf86-video-vesa"
    fi
    pause_function
  }
  #}}}
  #CUPS {{{
  install_cups(){
    print_title "CUPS - https://wiki.archlinux.org/index.php/Cups"
    print_info "CUPS is the standards-based, open source printing system developed by Apple Inc. for Mac OS® X and other UNIX®-like operating systems."
    read_input_text "Install CUPS (aka Common Unix Printing System)" $CUPS
    if [[ $OPTION == y ]]; then
      package_install "cups cups-filters ghostscript gsfonts"
      package_install "gutenprint foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-filters hplip splix cups-pdf"
      systemctl enable cups.service
      pause_function
    fi
  }
  #}}}
  #ADDITIONAL FIRMWARE {{{
  install_additional_firmwares(){
    print_title "INSTALL ADDITIONAL FIRMWARES"
    read_input_text "Install additional firmwares [Audio,Bluetooth,Scanner,Wireless]" $FIRMWARE
    if [[ $OPTION == y ]]; then
      while [[ 1 ]]
      do
        print_title "INSTALL ADDITIONAL FIRMWARES"
        echo " 1) $(menu_item "alsa-firmware")"
        echo " 2) $(menu_item "ipw2100-fw")"
        echo " 3) $(menu_item "ipw2200-fw")"
        echo " 4) $(menu_item "b43-firmware") $AUR"
        echo " 5) $(menu_item "b43-firmware-legacy") $AUR"
        echo " 6) $(menu_item "broadcom-wl") $AUR"
        echo " 7) $(menu_item "zd1211-firmware ")"
        echo " 8) $(menu_item "bluez-firmware") "
        echo " 9) $(menu_item "libffado") [Fireware Audio Devices]"
        echo "10) $(menu_item "libraw1394") [IEEE1394 Driver]"
        echo "11) $(menu_item "sane-gt68xx-firmware")"
        echo ""
        echo " d) DONE"
        echo ""
        FIRMWARE_OPTIONS+=" d"
        read_input_options "$FIRMWARE_OPTIONS"
        for OPT in ${OPTIONS[@]}; do
          case "$OPT" in
            1)
              package_install "alsa-firmware"
              ;;
            2)
              package_install "ipw2100-fw"
              ;;
            3)
              package_install "ipw2200-fw"
              ;;
            4)
              aur_package_install "b43-firmware"
              ;;
            5)
              aur_package_install "b43-firmware-legacy"
              ;;
            6)
              aur_package_install "broadcom-wl"
              ;;
            7)
              package_install "zd1211-firmware"
              ;;
            8)
              package_install "bluez-firmware"
              ;;
            9)
              package_install "libffado"
              ;;
            10)
              package_install "libraw1394"
              ;;
            11)
              package_install "sane-gt68xx-firmware"
              ;;
            "d")
              break
              ;;
            *)
              invalid_option
              ;;
          esac
        done
        elihw
      done
    fi
  }
  #}}}
  #GIT ACCESS THRU A FIREWALL {{{
  install_git_tor(){
    print_title "GIT-TOR - https://wiki.archlinux.org/index.php/Tor"
    print_info "Tor is an open source implementation of 2nd generation onion routing that provides free access to an anonymous proxy network. Its primary goal is to enable online anonymity by protecting against traffic analysis attacks."
    read_input_text "Ensuring access to GIT through a firewall (bypass college/work firewall)" $GITTOR
    if [[ $OPTION == y ]]; then
      package_install "openbsd-netcat vidalia privoxy git"
      if [[ ! -f /usr/bin/proxy-wrapper ]]; then
        echo 'forward-socks5   /               127.0.0.1:9050 .' >> /etc/privoxy/config
        echo -e '#!/bin/bash\nnc -xlocalhost:9050 -X5 $*' > /usr/bin/proxy-wrapper
        chmod +x /usr/bin/proxy-wrapper
        echo -e '\nexport GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"' >> /etc/bash.bashrc
        export GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"
        su - ${USER_NAME} -c 'export GIT_PROXY_COMMAND="/usr/bin/proxy-wrapper"'
      fi
      groupadd -g 42 privoxy
      useradd -u 42 -g privoxy -s /bin/false -d /etc/privoxy privoxy
      systemctl start tor.service
      systemctl start privoxy.service
      systemctl enable tor.service
      systemctl enable privoxy.service
      pause_function
    fi
  }
  #}}}
  #DESKTOP ENVIRONMENT {{{
  install_desktop_environment(){
    install_icon_theme() { #{{{
      package_install "gtk-update-icon-cache"
      while [[ 1 ]]
      do
        print_title "GNOME ICONS"
        echo " 1) $(menu_item "awoken-icons" "Awoken")"
        echo " 2) $(menu_item "elementary-xfce-icons" "Elementary XFCE")"
        echo " 3) $(menu_item "faenza-icon-theme")"
        echo " 4) $(menu_item "faenza-cupertino-icon-theme" "Faenza-Cupertino")"
        echo " 5) $(menu_item "faience-icon-theme")"
        echo " 6) $(menu_item "inx-icon-theme" "iNX")"
        echo " 7) $(menu_item "matrilineare-icon-theme")"
        echo " 8) $(menu_item "nitrux-icon-theme")"
        echo ""
        echo " b) BACK"
        echo ""
        ICONS_THEMES+=" b"
        read_input_options "$ICONS_THEMES"
        for OPT in ${OPTIONS[@]}; do
          case "$OPT" in
            1)
              aur_package_install "awoken-icons"
              ;;
            2)
              aur_package_install "elementary-xfce-icons"
              ;;
            3)
              aur_package_install "faenza-icon-theme"
              ;;
            4)
              aur_package_install "faenza-cupertino-icon-theme"
              ;;
            5)
              aur_package_install "faience-icon-theme"
              ;;
            6)
              aur_package_install "inx-icon-theme"
              ;;
            7)
              aur_package_install "matrilineare-icon-theme"
              ;;
            8)
              aur_package_install "nitrux-icon-theme"
              ;;
            "b")
              break
              ;;
            *)
              invalid_option
              ;;
          esac
        done
        elihw
      done
    } #}}}
    install_gtk_theme() { #{{{
      while [[ 1 ]]
      do
        print_title "GTK2/GTK3 THEMES"
        echo " 1) $(menu_item "adwaita-x-dark-and-light-theme" "Adwaita-X")"
        echo " 2) $(menu_item "gtk-theme-boje" "Boje")"
        echo " 3) $(menu_item "xfce-theme-blackbird" "Blackbird")"
        echo " 4) $(menu_item "xfce-theme-bluebird" "Bluebird")"
        echo " 5) $(menu_item "xfce-theme-greybird" "Greybird")"
        echo " 6) $(menu_item "faience-themes" "Faience")"
        echo " 7) $(menu_item "gtk-theme-gnome-cupertino" "Gnome Cupertino")"
        echo " 8) $(menu_item "mediterraneannight-theme" "MediterraneanNight")"
        echo " 9) $(menu_item "light-themes" "Light") (aka Ambiance/Radiance)"
        echo "10) $(menu_item "zukitwo-themes" "Zukitwo")"
        echo ""
        echo " b) BACK"
        echo ""
        GTK_THEMES+=" b"
        read_input_options "$GTK_THEMES"
        for OPT in ${OPTIONS[@]}; do
          case "$OPT" in
            1)
              aur_package_install "adwaita-x-dark-and-light-theme"
              ;;
            2)
              aur_package_install "gtk-theme-boje"
              ;;
            3)
              aur_package_install "xfce-theme-blackbird"
              ;;
            4)
              aur_package_install "xfce-theme-bluebird"
              ;;
            5)
              aur_package_install "xfce-theme-greybird"
              ;;
            6)
              aur_package_install "faience-themes"
              ;;
            7)
              aur_package_install "gtk-theme-gnome-cupertino"
              ;;
            8)
              aur_package_install "mediterraneannight-theme"
              ;;
            9)
              aur_package_install "light-themes"
              ;;
            10)
              aur_package_install "zukitwo-themes"
              ;;
            "b")
              break
              ;;
            *)
              invalid_option
              ;;
          esac
        done
        elihw
      done
    } #}}}
    install_display_manager() { #{{{
      while [[ 1 ]]
      do
        print_title "DISPLAY MANAGER - https://wiki.archlinux.org/index.php/Display_Manager"
        print_info "A display manager, or login manager, is a graphical interface screen that is displayed at the end of the boot process in place of the default shell."
        echo " 1) $(menu_item "entrance-svn" "Elsa") $AUR"
        echo " 2) $(menu_item "gdm" "GDM")"
        echo " 3) $(menu_item "lightdm" "LightDM") $AUR"
        echo " 4) $(menu_item "lxdm" "LXDM")"
        echo " 5) $(menu_item "slim")"
        echo ""
        echo " b) BACK|SKIP"
        echo ""
        DISPLAY_MANAGER+=" b"
        read_input_options "$DISPLAY_MANAGER"
        for OPT in ${OPTIONS[@]}; do
          case "$OPT" in
            1)
              aur_package_install "entrance-svn"
              systemctl enable entrace.service
              ;;
            2)
              package_install "gdm"
              systemctl enable gdm.service
              ;;
            3)
              aur_package_install "lightdm lightdm-gtk-greeter"
              sed -i 's/#greeter-session=.*$/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
              systemctl enable lightdm.service
              ;;
            4)
              package_install "lxdm"
              systemctl enable lxdm.service
              ;;
            5)
              package_install "slim"
              systemctl enable slim.service
              ;;
            "b")
              break
              ;;
            *)
              invalid_option
              ;;
          esac
        done
        elihw
      done
    } #}}}
    install_themes() { #{{{
      while [[ 1 ]]
      do
        print_title "$1 THEMES"
        echo " 1) $(menu_item "awoken-icons faenza-icon-theme faenza-cupertino-icon-theme faience-icon-theme elementary-xfce-icons inx-icon-theme matrilineare-icon-theme nitrux-icon-theme" "Icons Themes") $AUR"
        echo " 2) $(menu_item "adwaita-x-dark-and-light-theme gtk-theme-boje xfce-theme-blackbird xfce-theme-bluebird xfce-theme-greybird faience-themes gtk-theme-gnome-cupertino mediterraneannight-theme light-themes zukitwo-themes" "GTK Themes") $AUR"
        [[ $GNOME == 1 ]] && echo " 3) $(menu_item "gnome-shell-theme-elegance gnome-shell-theme-eos" "Gnome Shell Themes") $AUR"
        [[ $CINNAMON == 1 ]] && echo " 3) $(menu_item "cinnamon-theme-ambience cinnamon-theme-baldr cinnamon-theme-google+ cinnamon-theme-eleganse cinnamon-theme-helios cinnamon-theme-elementary-luna cinnamon-theme-holo cinnamon-theme-gnome cinnamon-theme-loki" "Cinnamon themes") $AUR"
        echo ""
        echo " d) DONE"
        echo ""
        THEMES_OPTIONS+=" d"
        read_input_options "$THEME_OPTIONS"
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
            3)
              if [[ $GNOME == 1 ]]; then
                #GNOME SHELL THEMES {{{
                while [[ 1 ]]
                do
                  print_title "GNOME SHELL THEMES"
                  echo " 1) $(menu_item "gnome-shell-theme-elegance")"
                  echo " 2) $(menu_item "gnome-shell-theme-eos")"
                  echo ""
                  echo " b) BACK"
                  echo ""
                  GNOME_SHELL_THEMES+=" b"
                  read_input_options "$GNOME_SHELL_THEMES"
                  for OPT in ${OPTIONS[@]}; do
                    case "$OPT" in
                      1)
                        aur_package_install "gnome-shell-theme-elegance"
                        ;;
                      2)
                        aur_package_install "gnome-shell-theme-eos"
                        ;;
                      "b")
                        break
                        ;;
                      *)
                        invalid_option
                        ;;
                    esac
                  done
                  elihw
                done
                #}}}
              elif [[ $CINNAMON == 1 ]]; then
                #CINNAMON THEMES {{{
                while [[ 1 ]]
                do
                  print_title "CINNAMON THEMES"
                  echo " 1) $(menu_item "cinnamon-theme-ambience")"
                  echo " 2) $(menu_item "cinnamon-theme-baldr")"
                  echo " 3) $(menu_item "cinnamon-theme-eleganse")"
                  echo " 4) $(menu_item "cinnamon-theme-elementary-luna")"
                  echo " 5) $(menu_item "cinnamon-theme-gnome")"
                  echo " 6) $(menu_item "cinnamon-theme-google+")"
                  echo " 7) $(menu_item "cinnamon-theme-helios")"
                  echo " 8) $(menu_item "cinnamon-theme-holo")"
                  echo " 9) $(menu_item "cinnamon-theme-loki")"
                  echo "10) $(menu_item "cinnamon-theme-nadia")"
                  echo ""
                  echo " b) BACK"
                  echo ""
                  CINNAMON_THEMES+=" b"
                  read_input_options "$CINNAMON_THEMES"
                  for OPT in ${OPTIONS[@]}; do
                    case "$OPT" in
                      1)
                        aur_package_install "cinnamon-theme-ambience"
                        ;;
                      2)
                        aur_package_install "cinnamon-theme-baldr"
                        ;;
                      3)
                        aur_package_install "cinnamon-theme-eleganse"
                        ;;
                      4)
                        aur_package_install "cinnamon-theme-elementary-luna"
                        ;;
                      5)
                        aur_package_install "cinnamon-theme-gnome"
                        ;;
                      6)
                        aur_package_install "cinnamon-theme-google+"
                        ;;
                      7)
                        aur_package_install "cinnamon-theme-helios"
                        ;;
                      8)
                        aur_package_install "cinnamon-theme-holo"
                        ;;
                      9)
                        aur_package_install "cinnamon-theme-loki"
                        ;;
                      10)
                        aur_package_install "cinnamon-theme-nadia"
                        ;;
                      "b")
                        break
                        ;;
                      *)
                        invalid_option
                        ;;
                    esac
                  done
                  elihw
                done
                #}}}
              else
                invalid_option
              fi
              OPT=3
              ;;
            "d")
              break
              ;;
            *)
              invalid_option
              ;;
          esac
        done
        elihw
      done
    } #}}}
    install_misc_apps() { #{{{
        while [[ 1 ]]
        do
          print_title "$1 ESSENTIAL APPS"
          echo " 1) $(menu_item "entrance-svn gdm lightdm lxdm slim" "Display Manager") $AUR"
          echo " 2) $(menu_item "dmenu")"
          echo " 3) $(menu_item "viewnior")"
          echo " 4) $(menu_item "gmrun")"
          echo " 5) $(menu_item "pcmanfm" "PCManFM")"
          echo " 6) $(menu_item "rxvt-unicode")"
          echo " 7) $(menu_item "scrot")"
          echo " 8) $(menu_item "thunar")"
          echo " 9) $(menu_item "tint2")"
          echo "10) $(menu_item "volwheel")"
          echo "11) $(menu_item "xfburn")"
          echo "12) $(menu_item "xcompmgr")"
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
                package_install "pcmanfm polkit-gnome gvfs"
                ;;
              6)
                package_install "rxvt-unicode"
                ;;
              7)
                package_install "scrot"
                ;;
              8)
                package_install "thunar tumbler"
                ;;
              9)
                package_install "tint2"
                ;;
              10)
                package_install "volwheel"
                ;;
              11)
                package_install "xfburn"
                ;;
              12)
                package_install "xcompmgr transset-df"
                ;;
              "d")
                break
                ;;
              *)
                invalid_option
                ;;
            esac
          done
          elihw
        done
    } #}}}
    print_title "DESKTOP ENVIRONMENT|WINDOW MANAGER"
    print_info "A DE provide a complete GUI for a system by bundling together a variety of X clients written using a common widget toolkit and set of libraries.\n\nA window manager is one component of a system's graphical user interface."
    echo -e "Select your DE or WM:\n"
    echo " 1) Cinnamon $AUR"
    echo " 2) E17"
    echo " 3) GNOME"
    echo " 4) KDE"
    echo " 5) LXDE"
    echo " 6) Mate"
    echo " 7) XFCE"
    echo " 8) Awesome"
    echo " 9) Fluxbox"
    echo "10) OpenBox"
    echo ""
    echo " b) BACK"
    read_input $DESKTOPENV
    case "$OPTION" in
      1)
        #CINNAMON {{{
        print_title "CINNAMON - https://wiki.archlinux.org/index.php/Cinnamon"
        print_info "Cinnamon is a fork of GNOME Shell, initially developed by Linux Mint. It attempts to provide a more traditional user environment based on the desktop metaphor, like GNOME 2. Cinnamon uses Muffin, a fork of the GNOME 3 window manager Mutter, as its window manager."
        aur_package_install "cinnamon"
        package_install "gnome-extra gedit-plugins"
        package_install "telepathy"
        package_install "gksu nautilus-open-terminal gnome-tweak-tool xdg-user-dirs-gtk gucharmap"
        package_install "gvfs-smb gvfs-afc"
        package_install "deja-dup"
        package_install "gnome-packagekit gnome-settings-daemon-updates"
        aur_package_install "gnome-defaults-list"
        #Essential stuffs
        aur_package_install "cinnamon-applet-screenshot-record"
        aur_package_install "cinnamon-applet-shutdown"
        aur_package_install "cinnamon-extension-coverflow-alt-tab"
        config_xinitrc "gnome-session-cinnamon"
        #Tweaks
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-close-effect scale
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-close-time 250
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-close-transition easeInExpo
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-map-effect scale
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-map-time 350
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-map-transition easeOutBack
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-maximize-effect scale
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-maximize-time 150
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-maximize-transition easeInOutSine
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-minimize-effect scale
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-minimize-time 250
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-minimize-transition easeInOutSine
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-unmaximize-effect scale
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-unmaximize-time 150
        sudo -u ${USER_NAME} gsettings set org.cinnamon desktop-effects-unmaximize-transition easeInOutSine
        CINNAMON=1
        pause_function
        install_themes "CINNAMON"
        #Gnome Display Manager (a reimplementation of xdm)
        systemctl enable gdm.service
        #D-Bus interface for user account query and manipulation
        systemctl enable accounts-daemon.service
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        systemctl enable upower.service
        ;;
        #}}}
      2)
        #E17 {{{
        print_title "E17 - http://wiki.archlinux.org/index.php/E17"
        print_info "Enlightenment, also known simply as E, is a stacking window manager for the X Window System which can be used alone or in conjunction with a desktop environment such as GNOME or KDE. Enlightenment is often used as a substitute for a full desktop environment."
        package_install "enlightenment17"
        package_install "gvfs"
        package_install "xdg-user-dirs"
        package_install "leafpad epdfview"
        package_install "lxappearance"
        package_install "ttf-bitstream-vera ttf-dejavu"
        aur_package_install "gnome-defaults-list"
        config_xinitrc "enlightenment_start"
        pause_function
        install_misc_apps "E17"
        install_themes "E17"
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        systemctl enable upower.service
        ;;
        #}}}
      3)
        #GNOME {{{
        print_title "GNOME - https://wiki.archlinux.org/index.php/GNOME"
        print_info "GNOME is a desktop environment and graphical user interface that runs on top of a computer operating system. It is composed entirely of free and open source software. It is an international project that includes creating software development frameworks, selecting application software for the desktop, and working on the programs that manage application launching, file handling, and window and task management."
        package_install "gnome gnome-extra telepathy"
        package_install "gksu nautilus-open-terminal gedit-plugins gnome-tweak-tool gucharmap"
        package_install "gvfs-smb gvfs-afc"
        package_install "zeitgeist"
        package_install "deja-dup"
        package_install "gnome-packagekit gnome-settings-daemon-updates"
        aur_package_install "gnome-defaults-list"
        package_install "python2-distutils-extra"
        aur_package_install "empathy-theme-ubuntu-adium-bzr"
        config_xinitrc "gnome-session"
        GNOME=1
        pause_function
        install_themes "GNOME"
        #Gnome Display Manager (a reimplementation of xdm)
        systemctl enable gdm.service
        #D-Bus interface for user account query and manipulation
        systemctl enable accounts-daemon.service
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        systemctl enable upower.service
        ;;
        #}}}
      4)
        #KDE {{{
        print_title "KDE - https://wiki.archlinux.org/index.php/KDE"
        print_info "KDE is an international free software community producing an integrated set of cross-platform applications designed to run on Linux, FreeBSD, Microsoft Windows, Solaris and Mac OS X systems. It is known for its Plasma Desktop, a desktop environment provided as the default working environment on many Linux distributions."
        package_install "kde kde-l10n-$LANGUAGE_KDE kipi-plugins"
        package_install "xdg-user-dirs"
        package_install "kde-telepathy telepathy"
        package_remove "kdemultimedia-kscd kdemultimedia-juk kdebase-kwrite kdenetwork-kopete"
        aur_package_install "kde-gtk-config"
        aur_package_install "oxygen-gtk2 oxygen-gtk3 qtcurve-gtk2 qtcurve-kde4"
        local CONFIG_PULSEAUDIO=`cat /etc/pulse/default.pa | grep module-device-manager`
        [[ -z $CONFIG_PULSEAUDIO ]] && echo "load-module module-device-manager" >> /etc/pulse/default.pa
        config_xinitrc "startkde"
        pause_function
        #QTCURVE THEMES #{{{
          curl -o Sweet.tar.gz http://kde-look.org/CONTENT/content-files/144205-Sweet.tar.gz
          curl -o Kawai.tar.gz http://kde-look.org/CONTENT/content-files/141920-Kawai.tar.gz
          tar zxvf Sweet.tar.gz
          tar zxvf Kawai.tar.gz
          rm Sweet.tar.gz
          rm Kawai.tar.gz
          mkdir -p /home/${USER_NAME}/.kde4/share/apps/color-schemes
          mv Sweet/Sweet.colors /home/${USER_NAME}/.kde4/share/apps/color-schemes
          mv Kawai/Kawai.colors /home/${USER_NAME}/.kde4/share/apps/color-schemes
          mkdir -p /home/${USER_NAME}/.kde4/share/apps/QtCurve
          mv Sweet/Sweet.qtcurve /home/${USER_NAME}/.kde4/share/apps/QtCurve
          mv Kawai/Kawai.qtcurve /home/${USER_NAME}/.kde4/share/apps/QtCurve
          chown -R ${USER_NAME}:users /home/${USER_NAME}/.kde4
          rm -fr Kawai Sweet
        #}}}
        #KDE CUSTOMIZATION {{{
        while [[ 1 ]]
        do
          print_title "KDE CUSTOMIZATION"
          echo " 1) $(menu_item "apper")"
          echo " 2) $(menu_item "bangarang") $AUR"
          echo " 3) $(menu_item "choqok")"
          echo " 4) $(menu_item "digikam")"
          echo " 5) $(menu_item "k3b")"
          echo " 6) $(menu_item "rosa-icons") $AUR"
          echo " 7) $(menu_item "caledonia-bundle plasma-theme-produkt" "Plasma Themes") $AUR"
          echo " 8) $(menu_item "yakuake")"
          echo ""
          echo " d) DONE"
          echo ""
          KDE_OPTIONS+=" d"
          read_input_options "$KDE_OPTIONS"
          for OPT in ${OPTIONS[@]}; do
            case "$OPT" in
              1)
                package_install "apper"
                ;;
              2)
                aur_package_install "bangarang"
                ;;
              3)
                package_install "choqok"
                ;;
              4)
                package_install "digikam"
                ;;
              5)
                package_install "k3b cdrdao dvd+rw-tools"
                ;;
              6)
                aur_package_install "rosa-icons"
                ;;
              7)
                aur_package_install "caledonia-bundle plasma-theme-rosa plasma-theme-produkt ronak-plasmatheme"
                ;;
              8)
                package_install "yakuake"
                aur_package_install "yakuake-skin-plasma-oxygen-panel"
                ;;
              "d")
                break
                ;;
              *)
                invalid_option
                ;;
            esac
          done
          elihw
        done
        #}}}
        systemctl enable kdm.service
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        systemctl enable upower.service
        KDE=1
        ;;
        #}}}
      5)
        #LXDE {{{
        print_title "LXDE - http://wiki.archlinux.org/index.php/lxde"
        print_info "LXDE is a free and open source desktop environment for Unix and other POSIX compliant platforms, such as Linux or BSD. The goal of the project is to provide a desktop environment that is fast and energy efficient."
        package_install "lxde"
        package_install "upower"
        package_install "polkit-gnome gvfs"
        package_install "xdg-user-dirs"
        package_install "leafpad obconf epdfview"
        aur_package_install "gnome-defaults-list"
        mkdir -p /home/${USER_NAME}/.config/openbox/
        cp /etc/xdg/openbox/rc.xml /home/${USER_NAME}/.config/openbox/
        cp /etc/xdg/openbox/menu.xml /home/${USER_NAME}/.config/openbox/
        cp /etc/xdg/openbox/autostart /home/${USER_NAME}/.config/openbox/
        chown -R ${USER_NAME}:users /home/${USER_NAME}/.config
        config_xinitrc "startlxde"
        pause_function
        install_misc_apps "LXDE"
        install_themes "LXDE"
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        systemctl enable upower.service
        ;;
        #}}}
      6)
        #MATE {{{
        print_title "MATE - https://wiki.archlinux.org/index.php/Mate"
        print_info "The MATE Desktop Environment is a fork of GNOME 2 that aims to provide an attractive and intuitive desktop to Linux users using traditional metaphors."
        echo -e '\n[mate]\nServer = http://repo.mate-desktop.org/archlinux/$arch' >> /etc/pacman.conf
        pacman -Sy
        package_install "mate mate-extras"
        package_install "gvfs"
        aur_package_install "gnome-defaults-list"
        config_xinitrc "mate-session"
        pause_function
        install_themes "MATE"
        #D-Bus interface for user account query and manipulation
        systemctl enable accounts-daemon.service
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        systemctl enable upower.service
        ;;
        #}}}
      7)
        #XFCE {{{
        print_title "XFCE - https://wiki.archlinux.org/index.php/Xfce"
        print_info "Xfce is a free software desktop environment for Unix and Unix-like platforms, such as Linux, Solaris, and BSD. It aims to be fast and lightweight, while still being visually appealing and easy to use."
        package_install "xfce4 xfce4-goodies"
        package_install "gvfs"
        package_install "xdg-user-dirs"
        aur_package_install "gnome-defaults-list"
        config_xinitrc "startxfce4"
        pause_function
        install_display_manager
        install_themes "XFCE"
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        systemctl enable upower.service
        ;;
        #}}}
      8)
        #AWESOME {{{
        print_title "AWESOME - http://wiki.archlinux.org/index.php/Awesome"
        print_info "awesome is a highly configurable, next generation framework window manager for X. It is very fast, extensible and licensed under the GNU GPLv2 license."
        package_install "awesome"
        package_install "gvfs"
        package_install "lxappearance"
        package_install "leafpad epdfview nitrogen"
        package_install "ttf-bitstream-vera ttf-dejavu"
        aur_package_install "gnome-defaults-list"
        mkdir -p /home/${USER_NAME}/.config/awesome/
        cp /etc/xdg/awesome/rc.lua /home/${USER_NAME}/.config/awesome/
        chown -R ${USER_NAME}:users /home/${USER_NAME}/.config
        config_xinitrc "awesome"
        pause_function
        install_misc_apps "AWESOME"
        install_themes "AWESOME"
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        systemctl enable upower.service
        ;;
        #}}}
      9)
        #FLUXBOX {{{
        print_title "FLUXBOX - http://wiki.archlinux.org/index.php/Fluxbox"
        print_info "Fluxbox is yet another window manager for X11. It is based on the (now abandoned) Blackbox 0.61.1 code, but with significant enhancements and continued development. Fluxbox is very light on resources and fast, yet provides interesting window management tools such as tabbing and grouping."
        package_install "fluxbox menumaker"
        package_install "lxappearance"
        package_install "xdg-user-dirs"
        package_install "leafpad epdfview"
        package_install "ttf-bitstream-vera ttf-dejavu"
        aur_package_install "gnome-defaults-list"
        config_xinitrc "startfluxbox"
        install_misc_apps "FLUXBOX"
        install_themes "FLUXBOX"
        pause_function
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        systemctl enable upower.service
        ;;
        #}}}
      10)
        #OPENBOX {{{
        print_title "OPENBOX - http://wiki.archlinux.org/index.php/Openbox"
        print_info "Openbox is a lightweight and highly configurable window manager with extensive standards support."
        package_install "openbox obconf obmenu menumaker"
        package_install "lxappearance"
        package_install "xdg-user-dirs"
        package_install "leafpad epdfview nitrogen"
        package_install "ttf-bitstream-vera ttf-dejavu"
        aur_package_install "gnome-defaults-list"
        mkdir -p /home/${USER_NAME}/.config/openbox/
        cp /etc/xdg/openbox/rc.xml /home/${USER_NAME}/.config/openbox/
        cp /etc/xdg/openbox/menu.xml /home/${USER_NAME}/.config/openbox/
        cp /etc/xdg/openbox/autostart /home/${USER_NAME}/.config/openbox/
        chown -R ${USER_NAME}:users /home/${USER_NAME}/.config
        config_xinitrc "openbox-session"
        pause_function
        install_misc_apps "OPENBOX"
        install_themes "OPENBOX"
        #Abstraction for enumerating power devices, listening to device events and querying history and statistics
        systemctl enable upower.service
        ;;
        #}}}
    "b")
        break
        ;;
      *)
        invalid_option
        ;;
    esac
    #Fix p7FM {{{
    [[ ${KDE} -eq 0 ]] && package_install "wxgtk"
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
          package_install "networkmanager kdeplasma-applets-networkmanagement"
        else
          package_install "networkmanager network-manager-applet"
        fi
        is_package_installed "ntp" && package_install "networkmanager-dispatcher-ntpd"
        groupadd networkmanager
        add_user_to_group ${USER_NAME} networkmanager
        #Network Management daemon
        systemctl enable NetworkManager.service
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
        #WICD daemon
        systemctl enable wicd.service
        pause_function
        ;;
      3)
        print_title "CONNMAN - https://wiki.archlinux.org/index.php/Connman"
        print_info "ConnMan is an alternative to NetworkManager and Wicd and was created by Intel and the Moblin project for use with embedded devices."
        package_install "connman "
        #ConnMan daemon
        systemctl enable connman.service
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
      package_install "usbutils usb_modeswitch modemmanager"
      pause_function
    fi
  }
  #}}}
  #ACCESSORIES {{{
  install_accessories_apps(){
    while [[ 1 ]]
    do
      print_title "ACCESSORIES APPS"
      echo " 1) $(menu_item "cairo-dock") $AUR"
      echo " 2) $(menu_item "catfish")"
      echo " 3) $(menu_item "conky-lua") $AUR"
      echo " 4) $(menu_item "deepin-screenshot-git") $AUR"
      echo " 5) $(menu_item "dockbarx") $AUR"
      echo " 6) $(menu_item "docky") $AUR"
      echo " 7) $(menu_item "speedcrunch galculator" "$([[ ${KDE} -eq 1 ]] && echo "Speedcrunch" || echo "Galculator";)") $AUR"
      echo " 8) $(menu_item "guake")"
      echo " 9) $(menu_item "kupfer") $AUR"
      echo "10) $(menu_item "pyrenamer") $AUR"
      echo "11) $(menu_item "shutter") $AUR"
      echo "12) $(menu_item "stormcloud") $AUR"
      echo "13) $(menu_item "synapse") $AUR"
      echo "14) $(menu_item "terminator")"
      echo "15) $(menu_item "zim")"
      echo ""
      echo " b) BACK"
      echo ""
      ACCESSORIES_OPTIONS+=" b"
      read_input_options "$ACCESSORIES_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            aur_package_install "cairo-dock cairo-dock-plugins"
            ;;
          2)
            package_install "catfish"
            ;;
          3)
            aur_package_install "conky-lua"
            ;;
          4)
            aur_package_install "deepin-screenshot-git"
            ;;
          5)
            aur_package_install "dockbarx dockbarx-shinybar-theme"
            ;;
          6)
            package_install "docky"
            ;;
          7)
            if [[ ${KDE} -eq 1 ]]; then
              aur_package_install "speedcrunch"
            else
              aur_package_install "galculator"
            fi
            ;;
          8)
            package_install "guake"
            ;;
          9)
            aur_package_install "kupfer"
            ;;
          10)
            aur_package_install "pyrenamer"
            ;;
          11)
            aur_package_install "shutter"
            ;;
          12)
            aur_package_install "stormcloud"
            ;;
          13)
            package_install "zeitgeist"
            aur_package_install "libzeitgeist zeitgeist-datahub synapse"
            ;;
          14)
            package_install "terminator"
            ;;
          15)
            package_install "zim"
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      elihw
    done
  }
  #}}}
  #DEVELOPEMENT {{{
  install_development_apps(){
    while [[ 1 ]]
    do
      print_title "DEVELOPMENT APPS"
      echo " 1) $(menu_item "aptana-studio") $AUR"
      echo " 2) $(menu_item "bluefish")"
      echo " 3) $(menu_item "eclipse")"
      echo " 4) $(menu_item "emacs")"
      echo " 5) $(menu_item "gvim")"
      echo " 6) $(menu_item "geany")"
      echo " 7) $(menu_item "intellij-idea-community-edition" "IntelliJ IDEA")"
      echo " 8) $(menu_item "kdevelop")"
      echo " 9) $(menu_item "netbeans")"
      echo "10) $(menu_item "jdk" "Oracle JDK") $AUR"
      echo "11) $(menu_item "qtcreator")"
      echo "12) $(menu_item "sublime-text" "Sublime Text 2") $AUR"
      echo "13) $(menu_item "gdb" "Debugger Tools")"
      echo "14) $(menu_item "mysql-workbench-gpl" "MySQL Workbench") $AUR"
      echo "15) $(menu_item "meld")"
      echo "16) $(menu_item "rabbitvcs" "RabbitVCS") $AUR"
      echo ""
      echo " b) BACK"
      echo ""
      DEVELOPMENT_OPTIONS+=" b"
      read_input_options "$DEVELOPMENT_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            aur_package_install "aptana-studio"
            ;;
          2)
            package_install "bluefish"
            ;;
          3)
            #ECLIPSE {{{
            while [[ 1 ]]
            do
              print_title "ECLIPSE - https://wiki.archlinux.org/index.php/Eclipse"
              print_info "Eclipse is an open source community project, which aims to provide a universal development platform."
              echo " 1) $(menu_item "eclipse")"
              echo " 2) $(menu_item "eclipse-cdt" "Eclipse IDE for C/C++ Developers")"
              echo " 3) $(menu_item "eclipse-android" "Android Development Tools for Eclipse") $AUR"
              echo " 4) $(menu_item "eclipse-wtp-wst" "Web Development Tools for Eclipse") $AUR"
              echo " 5) $(menu_item "eclipse-pdt" "PHP Development Tools for Eclipse ") $AUR"
              echo " 6) $(menu_item "eclipse-pydev" "Python Development Tools for Eclipse") $AUR"
              echo " 7) $(menu_item "eclipse-aptana" "Aptana Studio plugin for Eclipse") $AUR"
              echo " 8) $(menu_item "eclipse-vrapper" "Vim-like editing plugin for Eclipse ") $AUR"
              echo " 9) $(menu_item "eclipse-egit" "Git support plugin for Eclipse") $AUR"
              echo ""
              echo " b) BACK"
              echo ""
              ECLIPSE_OPTIONS+=" b"
              read_input_options "$ECLIPSE_OPTIONS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "eclipse"
                    ;;
                  2)
                    package_install "eclipse-cdt"
                    ;;
                  3)
                    aur_package_install "eclipse-android android-apktool android-sdk android-sdk-platform-tools android-udev"
                    ;;
                  4)
                    aur_package_install "eclipse-wtp-wst"
                    ;;
                  5)
                    aur_package_install "eclipse-pdt"
                    ;;
                  6)
                    aur_package_install "eclipse-pydev"
                    ;;
                  7)
                    aur_package_install "eclipse-aptana"
                    ;;
                  8)
                    aur_package_install "eclipse-vrapper"
                    ;;
                  9)
                    aur_package_install "eclipse-egit"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=3
            ;;
          4)
            package_install "emacs"
            ;;
          5)
            package_remove "vim"
            package_install "gvim ctags"
            ;;
          6)
            package_install "geany"
            ;;
          7)
            package_install "intellij-idea-community-edition"
            ;;
          8)
            package_install "kdevelop"
            ;;
          9)
            package_install "netbeans"
            ;;
          10)
            package_remove "jre7-openjdk"
            package_remove "jdk7-openjdk"
            aur_package_install "jdk"
            ;;
          11)
            package_install "qtcreator qt-doc"
            mkdir -p /home/${USER_NAME}/.config/Nokia/qtcreator/styles
            curl -o monokai.xml http://angrycoding.googlecode.com/svn/branches/qt-creator-monokai-theme/monokai.xml
            mv monokai.xml /home/${USER_NAME}/.config/Nokia/qtcreator/styles/
            chown -R ${USER_NAME}:users /home/${USER_NAME}/.config
            ;;
          12)
            aur_package_install "sublime-text"
            ;;
          13)
            aur_package_install "valgrind gdb splint tidyhtml python2-pyflakes nodejs-jslint"
            ;;
          14)
            aur_package_install "mysql-workbench-gpl"
            ;;
          15)
            package_install "meld"
            ;;
          16)
            aur_package_install "rabbitvcs"
            if is_package_installed "nautilus" ; then
              aur_package_install "rabbitvcs-nautilus"
            elif is_package_installed "thunar" ; then
              aur_package_install "rabbitvcs-thunar"
            else
              aur_package_install "rabbitvcs-cli"
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
      elihw
    done
  }
  #}}}
  #OFFICE {{{
  install_office_apps(){
    while [[ 1 ]]
    do
      print_title "OFFICE APPS"
      echo " 1) $(menu_item "libreoffice-common" "LibreOffice")"
      echo " 2) $(menu_item "goffice calligra" "$([[ ${KDE} -eq 1 ]] && echo "Caligra" || echo "Abiword + Gnumeric";)")"
      echo " 3) $(menu_item "texlive-core" "latex")"
      echo " 4) $(menu_item "calibre")"
      echo " 5) $(menu_item "gcstar")"
      echo " 6) $(menu_item "homebank")"
      echo " 7) $(menu_item "impressive")"
      echo " 8) $(menu_item "nitrotasks") $AUR"
      echo " 9) $(menu_item "ocrfeeder")"
      echo "10) $(menu_item "uberwriter") $AUR"
      echo "11) $(menu_item "xmind") $AUR"
      echo "12) $(menu_item "zathura")"
      echo ""
      echo " b) BACK"
      echo ""
      OFFICE_OPTIONS+=" b"
      read_input_options "$OFFICE_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            print_title "LIBREOFFICE - https://wiki.archlinux.org/index.php/LibreOffice"
            package_install "libreoffice-$LANGUAGE_LO libreoffice-common libreoffice-base libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-math libreoffice-writer libreoffice-extension-presenter-screen libreoffice-extension-pdfimport"
            aur_package_install "hunspell-$LANGUAGE_HS"
            aur_package_install "aspell-$LANGUAGE_AS"
            if [[ ${KDE} -eq 1 ]]; then
              package_install "libreoffice-kde4"
            else
              package_install "libreoffice-gnome"
            fi
            ;;
          2)
            if [[ ${KDE} -eq 1 ]]; then
              package_install "calligra"
            else
              package_install "gnumeric abiword abiword-plugins"
            fi
            aur_package_install "hunspell-$LANGUAGE_HS"
            aur_package_install "aspell-$LANGUAGE_AS"
            ;;
          3)
            package_install "texlive-most"
            if [[ $LANGUAGE == pt_BR ]]; then
              aur_package_install "abntex"
            fi
            read_input_text "Install texmaker?"
            [[ $OPTION == y ]] && aur_package_install "texmaker"
            ;;
          4)
            package_install "calibre"
            ;;
          5)
            package_install "gcstar"
            ;;
          6)
            package_install "homebank"
            ;;
          7)
            package_install "impressive"
            ;;
          8)
            aur_package_install "nitrotasks"
            ;;
          9)
            package_install "ocrfeeder tesseract gocr"
            aur_package_install "aspell-$LANGUAGE_AS"
            ;;
          10)
            aur_package_install "uberwriter"
            ;;
          11)
            aur_package_install "xmind"
            ;;
          12)
            package_install "zathura"
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      elihw
    done
  }
  #}}}
  #SYSTEM TOOLS {{{
  install_system_apps(){
    while [[ 1 ]]
    do
      print_title "SYSTEM TOOLS APPS"
      echo " 1) $(menu_item "gparted")"
      echo " 2) $(menu_item "grsync")"
      echo " 3) $(menu_item "htop")"
      echo " 4) $(menu_item "virtualbox")"
      echo " 5) $(menu_item "webmin")"
      echo " 6) $(menu_item "wine")"
      echo ""
      echo " b) BACK"
      echo ""
      SYSTEMTOOLS_OPTIONS+=" b"
      read_input_options "$SYSTEMTOOLS_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            package_install "gparted"
            ;;
          2)
            package_install "grsync"
            ;;
          3)
            package_install "htop"
            ;;
          4)
            # Make sure we are not a VirtualBox Guest
            VIRTUALBOX_GUEST=`dmidecode --type 1 | grep VirtualBox`
            if [[ -z ${VIRTUALBOX_GUEST} ]]; then
              package_install "virtualbox virtualbox-host-modules virtualbox-guest-iso"
              aur_package_install "virtualbox-ext-oracle"
              add_module "vboxdrv vboxnetadp vboxnetflt" "virtualbox-host"
              modprobe -a vboxdrv vboxnetadp vboxnetflt
              add_user_to_group ${USER_NAME} vboxusers
            else
              cecho "VirtualBox was not installed as we are a VirtualBox guest."
            fi
            ;;
          5)
            package_install "webmin perl-net-ssleay"
            systemctl enable webmin.service
            ;;
          6)
            package_install "wine wine_gecko winetricks"
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      elihw
    done
  }
  #}}}
  #GRAPHICS {{{
  install_graphics_apps(){
    while [[ 1 ]]
    do
      print_title "GRAPHICS APPS"
      echo " 1) $(menu_item "blender")"
      echo " 2) $(menu_item "gimp")"
      echo " 3) $(menu_item "gradiator")"
      echo " 4) $(menu_item "gthumb")"
      echo " 5) $(menu_item "inkscape")"
      echo " 6) $(menu_item "mcomix")"
      echo " 7) $(menu_item "mypaint")"
      echo " 8) $(menu_item "scribus")"
      echo " 9) $(menu_item "shotwell")"
      echo "10) $(menu_item "simple-scan")"
      echo "11) $(menu_item "xnviewmp") $AUR"
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
            aur_package_install "gimphelp-scriptfu gimp-resynth gimpfx-foundry"
            ;;
          3)
            aur_package_install "gradiator"
            ;;
          4)
            package_install "gthumb"
            ;;
          5)
            package_install "inkscape uniconvertor python2-numpy python-lxml"
            aur_package_install "sozi"
            ;;
          6)
            package_install "mcomix"
            ;;
          7)
            package_install "mypaint"
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
          11)
            aur_package_install "xnviewmp"
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      elihw
    done
  }
  #}}}
  #INTERNET {{{
  install_internet_apps(){
    while [[ 1 ]]
    do
      print_title "INTERNET APPS"
      echo " 1) Browser"
      echo " 2) Download|Fileshare"
      echo " 3) Email|RSS"
      echo " 4) Instant Messaging"
      echo " 5) IRC"
      echo " 6) Mapping Tools"
      echo " 7) VNC|Desktop Share"
      echo ""
      echo " b) BACK"
      echo ""
      INTERNET_OPTIONS+=" b"
      read_input_options "$INTERNET_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            #BROWSER {{{
            while [[ 1 ]]
            do
              print_title "BROWSER"
              echo " 1) $(menu_item "chromium")"
              echo " 2) $(menu_item "google-chrome") $AUR"
              echo " 3) $(menu_item "rekonq midori" "$([[ ${KDE} -eq 1 ]] && echo "Rekonq" || echo "Midori";)")"
              echo " 4) $(menu_item "firefox")"
              echo " 5) $(menu_item "opera")"
              echo ""
              echo " b) BACK"
              echo ""
              BROWSERS_OPTIONS+=" b"
              read_input_options "$BROWSERS_OPTIONS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "chromium flashplugin"
                    ;;
                  2)
                    aur_package_install "google-chrome flashplugin"
                    ;;
                  3)
                    if [[ ${KDE} -eq 1 ]]; then
                      package_install "rekonq"
                    else
                      package_install "midori"
                    fi
                    ;;
                  4)
                    package_install "firefox firefox-i18n-$LANGUAGE_FF firefox-adblock-plus flashplugin "
                    ;;
                  5)
                    package_install "opera flashplugin "
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=1
            ;;
          2)
            #DOWNLOAD|FILESHARE {{{
            while [[ 1 ]]
            do
              print_title "DOWNLOAD|FILESHARE"
              echo " 1) $(menu_item "deluge") $AUR"
              echo " 2) $(menu_item "dropbox") $AUR"
              echo " 3) $(menu_item "insync") $AUR"
              echo " 4) $(menu_item "jdownloader") $AUR"
              echo " 5) $(menu_item "nitroshare") $AUR"
              echo " 6) $(menu_item "sparkleshare")"
              echo " 7) $(menu_item "steadyflow-bzr") $AUR"
              echo " 8) $(menu_item "transmission-qt transmission-gtk" "Transmission")"
              echo " 9) $(menu_item "ubuntuone-client" "Ubuntu One") $AUR"
              echo ""
              echo " b) BACK"
              echo ""
              DOWNLOAD_OPTIONS+=" b"
              read_input_options "$DOWNLOAD_OPTIONS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "deluge"
                    ;;
                  2)
                    aur_package_install "dropbox"
                    if is_package_installed "nautilus" ; then
                      aur_package_install "nautilus-dropbox"
                      aur_package_install "dropbox-tango-emblems"
                    elif is_package_installed "thunar" ; then
                      aur_package_install "thunar-dropbox"
                    elif is_package_installed "kdebase-dolphin" ; then
                      aur_package_install "kfilebox"
                    else
                      aur_package_install "dropbox-cli"
                    fi
                    ;;
                  3)
                    aur_package_install "insync"
                    ;;
                  4)
                    aur_package_install "jdownloader"
                    ;;
                  5)
                    aur_package_install "nitroshare"
                    ;;
                  6)
                    package_install "sparkleshare"
                    ;;
                  7)
                    aur_package_install "steadyflow-bzr"
                    ;;
                  8)
                    if [[ ${KDE} -eq 1 ]]; then
                      package_install "transmission-qt"
                    else
                      package_install "transmission-gtk"
                    fi
                    if [ -f /home/${USER_NAME}/.config/transmission/settings.json ]; then
                      replaceinfile '"blocklist-enabled": false' '"blocklist-enabled": true' /home/${USER_NAME}/.config/transmission/settings.json
                      replaceinfile "www\.example\.com\/blocklist" "list\.iblocklist\.com\/\?list=bt_level1&fileformat=p2p&archiveformat=gz" /home/${USER_NAME}/.config/transmission/settings.json
                    fi

                    ;;
                  9)
                    aur_package_install "ubuntuone-client"
                    if is_package_installed "nautilus" ; then
                      aur_package_install "ubuntuone-client-gnome"
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
              elihw
            done
            #}}}
            OPT=2
            ;;
          3)
            #EMAIL {{{
            while [[ 1 ]]
            do
              print_title "EMAIL|RSS"
              echo " 1) $(menu_item "thunderbird")"
              echo " 2) $(menu_item "liferea")"
              echo " 3) $(menu_item "lightread") $AUR"
              echo ""
              echo " b) BACK"
              echo ""
              EMAIL_OPTIONS+=" b"
              read_input_options "$EMAIL_OPTIONS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "thunderbird thunderbird-i18n-$LANGUAGE_FF"
                    ;;
                  2)
                    package_install "liferea"
                    ;;
                  3)
                    aur_package_install "lightread"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=3
            ;;
          4)
            #IM {{{
            while [[ 1 ]]
            do
              print_title "IM - INSTANT MESSAGING"
              echo " 1) $(menu_item "emesene")"
              echo " 2) $(menu_item "google-talkplugin") $AUR"
              echo " 3) $(menu_item "pidgin")"
              echo " 4) $(menu_item "skype")"
              echo " 5) $(menu_item "teamspeak3") $AUR"
              echo ""
              echo " b) BACK"
              echo ""
              IM_OPTIONS+=" b"
              read_input_options "$IM_OPTIONS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "emesene"
                    ;;
                  2)
                    aur_package_install "google-talkplugin"
                    ;;
                  3)
                    package_install "pidgin"
                    ;;
                  4)
                    package_install "skype"
                    ;;
                  5)
                    aur_package_install "teamspeak3"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=4
            ;;
          5)
            #IRC {{{
            while [[ 1 ]]
            do
              print_title "IRC"
              echo " 1) $(menu_item "irssi")"
              echo " 2) $(menu_item "quassel xchat" "$([[ ${KDE} -eq 1 ]] && echo "Quassel" || echo "X-Chat";)")"
              echo ""
              echo " b) BACK"
              echo ""
              IRC_OPTIONS+=" b"
              read_input_options "$IRC_OPTIONS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "irssi"
                    ;;
                  2)
                    if [[ ${KDE} -eq 1 ]]; then
                      package_install "quassel"
                    else
                      package_install "xchat"
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
              elihw
            done
            #}}}
            OPT=5
            ;;
          6)
            #MAPPING {{{
            while [[ 1 ]]
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
                    if [ -f /etc/fonts/conf.d/65-fonts-persian.conf ]; then
                      mv /etc/fonts/conf.d/65-fonts-persian.conf /etc/fonts/conf.d/65-fonts-persian.conf.breaks-google-earth
                    fi
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
              elihw
            done
            #}}}
            OPT=6
            ;;
          7)
            #DESKTOP SHARE {{{
            while [[ 1 ]]
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
              elihw
            done
            #}}}
            OPT=7
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      elihw
    done
  }
  #}}}
  #AUDIO {{{
  install_audio_apps(){
    while [[ 1 ]]
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
            while [[ 1 ]]
            do
              print_title "AUDIO PLAYERS"
              echo " 1) $(menu_item "amarok")"
              echo " 2) $(menu_item "audacious")"
              echo " 3) $(menu_item "banshee")"
              echo " 4) $(menu_item "clementine")"
              echo " 5) $(menu_item "deadbeef")"
              echo " 6) $(menu_item "exaile") $AUR"
              echo " 7) $(menu_item "musique") $AUR"
              echo " 8) $(menu_item "nuvolaplayer") $AUR"
              echo " 9) $(menu_item "rhythmbox")"
              echo "10) $(menu_item "radiotray") $AUR"
              echo "11) $(menu_item "spotify") $AUR"
              echo "12) $(menu_item "tomahawk") $AUR"
              echo "13) $(menu_item "timidity++")"
              echo "14) $(menu_item "xnoise") $AUR"
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
                    package_install "banshee"
                    ;;
                  4)
                    package_install "clementine"
                    ;;
                  5)
                    package_install "deadbeef"
                    ;;
                  6)
                    aur_package_install "exaile"
                    ;;
                  7)
                    aur_package_install "musique"
                    ;;
                  8)
                    aur_package_install "nuvolaplayer"
                    ;;
                  9)
                    package_install "rhythmbox"
                    ;;
                  10)
                    aur_package_install "radiotray"
                    ;;
                  11)
                    aur_package_install "spotify"
                    ;;
                  12)
                    aur_package_install "tomahawk"
                    ;;
                  13)
                    aur_package_install "timidity++ fluidr3"
                    echo -e 'soundfont /usr/share/soundfonts/fluidr3/FluidR3GM.SF2' >> /etc/timidity++/timidity.cfg
                    ;;
                  14)
                    aur_package_install "xnoise"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=1
            ;;
          2)
            #EDITORS {{{
            while [[ 1 ]]
            do
              print_title "AUDIO EDITORS|TOOLS"
              echo " 1) $(menu_item "soundconverter soundkonverter" "$([[ ${KDE} -eq 1 ]] && echo "Soundkonverter" || echo "Soundconverter";)")"
              echo " 2) $(menu_item "puddletag") $AUR"
              echo " 3) $(menu_item "audacity")"
              echo " 4) $(menu_item "ocenaudio") $AUR"
              echo ""
              echo " b) BACK"
              echo ""
              AUDIO_EDITOR_OPTIONS+=" b"
              read_input_options "$AUDIO_EDITOR_OPTIONS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    if [[ ${KDE} -eq 1 ]]; then
                      package_install "soundkonverter"
                    else
                      package_install "soundconverter"
                    fi
                    ;;
                  2)
                    aur_package_install "puddletag"
                    ;;
                  3)
                    package_install "audacity"
                    ;;
                  4)
                    aur_package_install "ocenaudio"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=2
            ;;
          3)
            package_install "gst-plugins-base gst-plugins-base-libs gst-plugins-good \
                             gst-plugins-bad gst-plugins-ugly gst-ffmpeg"
            if check_package "banshee clementine exaile rhythmbox xfburn" ; then
              package_install "gstreamer0.10-plugins"
              # Use the 'standard' preset by default. This preset should generally be
              # transparent to most people on most music and is already quite high in quality.
              # The resulting bitrate should be in the 170-210kbps range, according to music
              # complexity.
              sudo -u ${USER_NAME} gconftool-2 --type string --set /system/gstreamer/0.10/audio/profiles/mp3/pipeline "audio/x-raw-int,rate=44100,channels=2 ! lame name=enc preset=1001 ! id3v2mux"
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
      elihw
    done
  }
  #}}}
  #VIDEO {{{
  install_video_apps(){
    while [[ 1 ]]
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
            while [[ 1 ]]
            do
              print_title "VIDEO PLAYERS"
              echo " 1) $(menu_item "audience-bzr") $AUR"
              echo " 2) $(menu_item "gnome-mplayer")"
              echo " 3) $(menu_item "parole")"
              echo " 4) $(menu_item "minitube") $AUR"
              echo " 5) $(menu_item "miro")"
              echo " 6) $(menu_item "rosa-media-player") $AUR"
              echo " 7) $(menu_item "smplayer")"
              echo " 8) $(menu_item "vlc")"
              echo " 9) $(menu_item "xbmc")"
              echo ""
              echo " b) BACK"
              echo ""
              VIDEO_PLAYER_OPTIONS+=" b"
              read_input_options "$VIDEO_PLAYER_OPTIONS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    aur_package_install "audience-bzr"
                    ;;
                  2)
                    package_install "gnome-mplayer"
                    ;;
                  3)
                    package_install "parole"
                    ;;
                  4)
                    aur_package_install "minitube"
                    ;;
                  5)
                    package_install "miro"
                    ;;
                  6)
                    aur_package_install "rosa-media-player"
                    ;;
                  7)
                    package_install "smplayer smplayer-themes"
                    ;;
                  8)
                    package_install "vlc"
                    if [[ ${KDE} -eq 1 ]]; then
                      package_install "phonon-vlc"
                    fi
                    ;;
                  9)
                    package_install "xbmc"
                    add_user_to_group ${USER_NAME} xbmc
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=1
            ;;
          2)
            #EDITORS {{{
            while [[ 1 ]]
            do
              print_title "VIDEO EDITORS|TOOLS"
              echo " 1) $(menu_item "avidemux-gtk avidemux-qt" "Avidemux")"
              echo " 2) $(menu_item "arista-transcoder" "Arista") $AUR"
              echo " 3) $(menu_item "transmageddon")"
              echo " 4) $(menu_item "kdeenlive")"
              echo " 5) $(menu_item "openshot")"
              echo " 6) $(menu_item "pitivi")"
              echo " 7) $(menu_item "kazam-bzr") $AUR"
              echo ""
              echo " b) BACK"
              echo ""
              VIDEO_EDITOR_OPTIONS+=" b"
              read_input_options "$VIDEO_EDITOR_OPTIONS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    if [[ ${KDE} -eq 1 ]]; then
                      package_install "avidemux-qt"
                    else
                      package_install "avidemux-gtk"
                    fi
                    ;;
                  2)
                    aur_package_install "arista-transcoder"
                    ;;
                  3)
                    package_install "transmageddon"
                    ;;
                  4)
                    package_install "kdenlive"
                    ;;
                  5)
                    package_install "openshot"
                    ;;
                  6)
                    package_install "pitivi"
                    ;;
                  7)
                    aur_package_install "kazam-bzr"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=2
            ;;
          3)
            package_install "libbluray libquicktime libdvdread libdvdnav libdvdcss cdrdao"
            if [[ $ARCHI == i686 ]]; then
              aur_package_install "codecs"
            else
              aur_package_install "codecs64"
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
      elihw
    done
  }
  #}}}
  #GAMES {{{
  install_games(){
    while [[ 1 ]]
    do
      print_title "GAMES - https://wiki.archlinux.org/index.php/Games"
      echo " 1) Action|Adventure"
      echo " 2) Arcade|Platformer"
      echo " 3) Dungeon"
      echo " 4) Emulators"
      echo " 5) FPS"
      echo " 6) MMO"
      echo " 7) Puzzle"
      echo " 8) RPG"
      echo " 9) Racing"
      echo "10) Simulation"
      echo "11) Strategy"
      echo "12) Steam"
      echo ""
      echo " b) BACK"
      echo ""
      GAMES_OPTIONS+=" b"
      read_input_options "$GAMES_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            #ACTION|ADVENTURE {{{
            while [[ 1 ]]
            do
              print_title "ACTION AND ADVENTURE"
              echo " 1) $(menu_item "astromenace")"
              echo " 2) $(menu_item "counter-strike-2d" "Counter-Strike 2D") $AUR"
              echo " 3) $(menu_item "dead-cyborg-episode1" "Dead Cyborg") $AUR"
              echo " 4) $(menu_item "mars-shooter" "M.A.R.S.") $AUR"
              echo " 5) $(menu_item "nikki") $AUR"
              echo " 6) $(menu_item "opentyrian-hg") $AUR"
              echo " 7) $(menu_item "srb2" "Sonic Robot Blast 2") $AUR"
              echo " 8) $(menu_item "steelstorm") $AUR"
              echo " 9) $(menu_item "yofrankie" "Yo Frankie!") $AUR"
              echo ""
              echo " b) BACK"
              echo ""

              ACTION+=" b"
              read_input_options "$ACTION"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "astromenace"
                    ;;
                  2)
                    aur_package_install "counter-strike-2d"
                    ;;
                  3)
                    aur_package_install "dead-cyborg-episode1"
                    ;;
                  4)
                    aur_package_install "mars-shooter"
                    ;;
                  5)
                    aur_package_install "nikki"
                    ;;
                  6)
                    aur_package_install "opentyrian-hg"
                    ;;
                  7)
                    aur_package_install "srb2"
                    ;;
                  8)
                    aur_package_install "steelstorm"
                    ;;
                  9)
                    aur_package_install "yofrankie"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=1
            ;;
          2)
            #ARCADE|PLATFORMER {{{
            while [[ 1 ]]
            do
              print_title "ARCADE AND PLATFORMER"
              echo " 1) $(menu_item "abuse")"
              echo " 2) $(menu_item "btanks" "Battle Tanks")"
              echo " 3) $(menu_item "bomberclone")"
              echo " 4) $(menu_item "funguloids" "Those Funny Funguloids") $AUR"
              echo " 5) $(menu_item "frogatto")"
              echo " 6) $(menu_item "goonies") $AUR"
              echo " 7) $(menu_item "mari0") $AUR"
              echo " 8) $(menu_item "neverball")"
              echo " 9) $(menu_item "opensonic") $AUR"
              echo "10) $(menu_item "robombs_bin" "Robombs") $AUR"
              echo "11) $(menu_item "smc" "Super Maryo Chronicles")"
              echo "12) $(menu_item "xmoto")"
              echo ""
              echo " b) BACK"
              echo ""
              ARCADE+=" b"
              read_input_options "$ARCADE"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "abuse"
                    ;;
                  2)
                    package_install "btanks"
                    ;;
                  3)
                    package_install "bomberclone"
                    ;;
                  4)
                    aur_package_install "funguloids"
                    ;;
                  5)
                    package_install "frogatto"
                    ;;
                  6)
                    aur_package_install "goonies"
                    ;;
                  7)
                    aur_package_install "mari0"
                    ;;
                  8)
                    package_install "neverball"
                    ;;
                  9)
                    aur_package_install "opensonic"
                    ;;
                  10)
                    aur_package_install "robombs_bin"
                    ;;
                  11)
                    package_install "smc"
                    ;;
                  12)
                    package_install "xmoto"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=2
            ;;
          3)
            #DUNGEON {{{
            while [[ 1 ]]
            do
              print_title "DUNGEON"
              echo " 1) $(menu_item "adom") $AUR"
              echo " 2) $(menu_item "tome4" "Tales of MajEyal") $AUR"
              echo " 3) $(menu_item "lostlabyrinth" "Lost Labyrinth") $AUR"
              echo " 4) $(menu_item "scourge" "S.C.O.U.R.G.E.") $AUR"
              echo " 5) $(menu_item "stone-soupe" "Stone-Soupe")"
              echo ""
              echo " b) BACK"
              echo ""
              DUNGEON+=" b"
              read_input_options "$DUNGEON"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    aur_package_install "adom"
                    ;;
                  2)
                    aur_package_install "tome4"
                    ;;
                  3)
                    aur_package_install "lostlabyrinth"
                    ;;
                  4)
                    aur_package_install "scourge"
                    ;;
                  5)
                    aur_package_install "stone-soup"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=3
            ;;
          4)
            #EMULATORS {{{
            while [[ 1 ]]
            do
              print_title "EMULATORS"
              echo " 1) $(menu_item "bsnes" "BSNES") $AUR"
              echo " 2) $(menu_item "desmume-svn") $AUR"
              echo " 3) $(menu_item "dolphin-emu" "Dolphin") $AUR"
              echo " 4) $(menu_item "epsxe") $AUR"
              echo " 5) $(menu_item "project64") $AUR"
              echo " 6) $(menu_item "vba-m-gtk-svn" "VisualBoyAdvanced") $AUR"
              echo " 7) $(menu_item "wxmupen64plus") $AUR"
              echo " 8) $(menu_item "zsnes")"
              echo ""
              echo " b) BACK"
              echo ""
              EMULATORS+=" b"
              read_input_options "$EMULATORS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    aur_package_install "bsnes"
                    ;;
                  2)
                    aur_package_install "desmume-svn"
                    ;;
                  3)
                    aur_package_install "dolphin-emu"
                    ;;
                  4)
                    aur_package_install "epsxe"
                    ;;
                  5)
                    aur_package_install "project64"
                    ;;
                  6)
                    aur_package_install "vba-m-gtk-svn"
                    ;;
                  7)
                    aur_package_install "wxmupen64plus"
                    ;;
                  8)
                    package_install "zsnes"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=4
            ;;
          5)
            #FPS {{{
            while [[ 1 ]]
            do
              print_title "FPS"
              echo " 1) $(menu_item "alienarena")"
              echo " 2) $(menu_item "warsow")"
              echo " 3) $(menu_item "enemy-territory" "Wolfenstein: Enemy Territory") $AUR"
              echo " 4) $(menu_item "worldofpadman" "World of Padman") $AUR"
              echo " 5) $(menu_item "xonotic")"
              echo ""
              echo " b) BACK"
              echo ""
              FPS+=" b"
              read_input_options "$FPS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "alienarena"
                    ;;
                  2)
                    package_install "warsow"
                    ;;
                  3)
                    aur_package_install "enemy-territory"
                    ;;
                  4)
                    aur_package_install "worldofpadman"
                    ;;
                  5)
                    package_install "xonotic"
                    ;;

                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=5
            ;;
          6)
            #MMO {{{
            while [[ 1 ]]
            do
              print_title "MMO"
              echo " 1) $(menu_item "hon" "Heroes of Newerth") $AUR"
              echo " 2) $(menu_item "manaplus") $AUR"
              echo " 3) $(menu_item "unix-runescape-client" "Runescape") $AUR"
              echo " 4) $(menu_item "savage2") $AUR"
              echo " 5) $(menu_item "spiral-knights") $AUR"
              echo " 6) $(menu_item "wakfu") $AUR"
              echo ""
              echo " b) BACK"
              echo ""
              MMO+=" b"
              read_input_options "$MMO"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    aur_package_install "hon"
                    ;;
                  2)
                    aur_package_install "manaplus"
                    ;;
                  3)
                    aur_package_install "unix-runescape-client"
                    ;;
                  4)
                    aur_package_install "savage2"
                    ;;
                  5)
                    aur_package_install "spiral-knights"
                    ;;
                  6)
                    aur_package_install "wakfu"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=6
            ;;
          7)
            #PUZZLE {{{
            while [[ 1 ]]
            do
              print_title "PUZZLE"
              echo " 1) $(menu_item "frozen-bubble")"
              echo " 2) $(menu_item "puzzle-moppet-bin") $AUR"
              echo " 3) $(menu_item "numptyphysics-svn") $AUR"
              echo ""
              echo " b) BACK"
              echo ""
              PUZZLE+=" b"
              read_input_options "$PUZZLE"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "frozen-bubble"
                    ;;
                  2)
                    aur_package_install "puzzle-moppet-bin"
                    ;;
                  3)
                    aur_package_install "numptyphysics-svn"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=7
            ;;
          8)
            #RPG {{{
            while [[ 1 ]]
            do
              print_title "RPG"
              echo " 1) $(menu_item "ardentryst") $AUR"
              echo " 2) $(menu_item "flare-rpg") $AUR"
              echo " 3) $(menu_item "freedroidrpg" "Freedroid RPG")"
              echo ""
              echo " b) BACK"
              echo ""
              RPG+=" b"
              read_input_options "$RPG"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    aur_package_install "ardentryst"
                    ;;
                  2)
                    aur_package_install "flare-rpg"
                    ;;
                  3)
                    package_install "freedroidrpg"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=8
            ;;
          9)
            #RACING {{{
            while [[ 1 ]]
            do
              print_title "RACING"
              echo " 1) $(menu_item "maniadrive") $AUR"
              echo " 2) $(menu_item "death-rally") $AUR"
              echo " 3) $(menu_item "stuntrally") $AUR"
              echo " 4) $(menu_item "supertuxkart")"
              echo " 5) $(menu_item "speed-dreams")"
              echo ""
              echo " b) BACK"
              echo ""
              RACING+=" b"
              read_input_options "$RACING"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    aur_package_install "maniadrive"
                    ;;
                  2)
                    aur_package_install "death-rally"
                    ;;
                  3)
                    aur_package_install "stuntrally"
                    ;;
                  4)
                    package_install "supertuxkart"
                    ;;
                  5)
                    package_install "speed-dreams"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=9
            ;;
          10)
            #SIMULATION {{{
            while [[ 1 ]]
            do
              print_title "SIMULATION"
              echo " 1) $(menu_item "simutrans")"
              echo " 2) $(menu_item "corsix-th" "Theme Hospital") $AUR"
              echo " 3) $(menu_item "openttd")"
              echo ""
              echo " b) BACK"
              echo ""
              SIMULATION+=" b"
              read_input_options "$SIMULATION"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "simutrans"
                    ;;
                  2)
                    aur_package_install "corsix-th"
                    ;;
                  3)
                    package_install "openttd"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=10
            ;;
          11)
            #STRATEGY {{{
            while [[ 1 ]]
            do
              print_title "STRATEGY"
              echo " 1) $(menu_item "0ad")"
              echo " 2) $(menu_item "hedgewars")"
              echo " 3) $(menu_item "megaglest")"
              echo " 4) $(menu_item "unknown-horizons") $AUR"
              echo " 5) $(menu_item "warzone2100")"
              echo " 6) $(menu_item "wesnoth")"
              echo " 7) $(menu_item "zod") $AUR"
              echo ""
              echo " b) BACK"
              echo ""
              STRATEGY+=" b"
              read_input_options "$STRATEGY"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    package_install "0ad"
                    ;;
                  2)
                    package_install "hedgewars"
                    ;;
                  3)
                    package_install "megaglest"
                    ;;
                  4)
                    package_install "unknow-horizons"
                    ;;
                  5)
                    package_install "warzone2100"
                    ;;
                  6)
                    package_install "wesnoth"
                    ;;
                  7)
                    aur_package_install "commander-zod"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=11
            ;;
          12)
            aur_package_install "steam"
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      elihw
    done
  }
  #}}}
  #WEBSERVER {{{
  install_web_server(){
    create_sites_folder(){
      [[ ! -f  /etc/httpd/conf/extra/httpd-userdir.conf.aui ]] && cp -v /etc/httpd/conf/extra/httpd-userdir.conf /etc/httpd/conf/extra/httpd-userdir.conf.aui
      sed -i 's/public_html/Sites/g' /etc/httpd/conf/extra/httpd-userdir.conf
      su - ${USER_NAME} -c "mkdir -p ~/Sites"
      su - ${USER_NAME} -c "chmod o+x ~/ && chmod -R o+x ~/Sites"
      print_line
      echo "The folder \"Sites\" has been created in your home"
      echo "You can access your projects at \"http://localhost/~username\""
      pause_function
    }
    print_title "WEB SERVER - https://wiki.archlinux.org/index.php/LAMP|LAPP"
    echo " 1) LAMP - APACHE, MYSQL & PHP + ADMINER"
    echo " 2) LAPP - APACHE, POSTGRESQL & PHP + ADMINER"
    echo ""
    echo " b) BACK"
    echo ""
    read_input $WEBSERVER
    case "$OPTION" in
      1)
        package_install "apache mysql php php-apache php-mcrypt php-gd"
        aur_package_install "adminer"
        systemctl enable httpd.service
        systemctl enable mysqld.service
        systemctl start mysqld.service
        #echo "Enter your new mysql root account password"
        #/usr/bin/mysqladmin -u root password
        /usr/bin/mysql_secure_installation
        #CONFIGURE HTTPD.CONF {{{
        if [[ ! -f  /etc/httpd/conf/httpd.conf.aui ]]; then
          cp -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.aui
          echo -e '\n# adminer configuration\nInclude conf/extra/httpd-adminer.conf' >> /etc/httpd/conf/httpd.conf
          echo -e 'application/x-httpd-php5		php php5' >> /etc/httpd/conf/mime.types
          sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
          echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\n\nAddHandler php5-script php' >> /etc/httpd/conf/httpd.conf
          sed -i 's/DirectoryIndex\ index.html/DirectoryIndex\ index.html\ index.php/g' /etc/httpd/conf/httpd.conf
        fi
        #}}}
        #CONFIGURE PHP.INI {{{
        if [[ -f  /etc/php/php.ini.pacnew ]]; then
          mv -v /etc/php/php.ini /etc/php/php.ini.pacold
          mv -v /etc/php/php.ini.pacnew /etc/php/php.ini
          rm -v /etc/php/php.ini.aui
        fi
        [[ -f /etc/php/php.ini.aui ]] && echo "/etc/php/php.ini.aui || cp -v /etc/php/php.ini /etc/php/php.ini.aui";
        sed -i '/mysqli.so/s/^;//' /etc/php/php.ini
        sed -i '/mysql.so/s/^;//' /etc/php/php.ini
        sed -i '/mcrypt.so/s/^;//' /etc/php/php.ini
        sed -i '/gd.so/s/^;//' /etc/php/php.ini
        sed -i '/display_errors=/s/off/on/' /etc/php/php.ini
        sed -i '/skip-networking/s/^/#/' /etc/mysql/my.cnf
        #}}}
        create_sites_folder
        ;;
      2)
        package_install "apache postgresql php php-apache php-pgsql php-gd"
        aur_package_install "adminer"
        chown -R postgres:postgres /var/lib/postgres/
        echo "Enter your new postgres account password:"
        passwd postgres
        if [[ ! -d /var/lib/postgres/data ]]; then
          echo "Enter your postgres account password:"
          su - postgres -c "initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'"
        fi
        sed -i '/PGROOT/s/^#//' /etc/conf.d/postgresql
        systemctl enable httpd.service
        systemctl enable postgresql.service
        systemctl start postgresql.service
        #CONFIGURE HTTPD.CONF {{{
        if [[ ! -f  /etc/httpd/conf/httpd.conf.aui ]]; then
          cp -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.aui
          echo -e '\n# adminer configuration\nInclude conf/extra/httpd-adminer.conf' >> /etc/httpd/conf/httpd.conf
          echo -e 'application/x-httpd-php5		php php5' >> /etc/httpd/conf/mime.types
          sed -i '/LoadModule dir_module modules\/mod_dir.so/a\LoadModule php5_module modules\/libphp5.so' /etc/httpd/conf/httpd.conf
          echo -e '\n# Use for PHP 5.x:\nInclude conf/extra/php5_module.conf\n\nAddHandler php5-script php' >> /etc/httpd/conf/httpd.conf
          sed -i 's/DirectoryIndex\ index.html/DirectoryIndex\ index.html\ index.php/g' /etc/httpd/conf/httpd.conf
        fi
        #}}}
        #CONFIGURE PHP.INI {{{
        if [[ -f  /etc/php/php.ini.pacnew ]]; then
          mv -v /etc/php/php.ini /etc/php/php.ini.pacold
          mv -v /etc/php/php.ini.pacnew /etc/php/php.ini
          rm -v /etc/php/php.ini.aui
        fi
        [[ -f /etc/php/php.ini.aui ]] && echo "/etc/php/php.ini.aui || cp -v /etc/php/php.ini /etc/php/php.ini.aui";
        sed -i '/pgsql.so/s/^;//' /etc/php/php.ini
        sed -i '/mcrypt.so/s/^;//' /etc/php/php.ini
        sed -i '/gd.so/s/^;//' /etc/php/php.ini
        sed -i '/display_errors=/s/off/on/' /etc/php/php.ini
        #}}}
        create_sites_folder
        ;;
    esac
  }
  #}}}
  #FONTS {{{
  install_fonts(){
    while [[ 1 ]]
    do
      print_title "FONTS - https://wiki.archlinux.org/index.php/Fonts"
      echo " 1) $(menu_item "ttf-anka-coder") $AUR"
      echo " 2) $(menu_item "ttf-anonymous-pro") $AUR"
      echo " 3) $(menu_item "ttf-dejavu")"
      echo " 4) $(menu_item "ttf-exljbris") $AUR"
      echo " 5) $(menu_item "ttf-funfonts") $AUR"
      echo " 6) $(menu_item "ttf-google-webfonts") $AUR"
      echo " 7) $(menu_item "ttf-inconsolata")"
      echo " 8) $(menu_item "ttf-liberation")"
      echo " 9) $(menu_item "ttf-ms-fonts") $AUR"
      echo "10) $(menu_item "ttf-source-code-pro") $AUR"
      echo "11) $(menu_item "ttf-vista-fonts") $AUR"
      echo "12) $(menu_item "wqy-microhei") (Chinese/Japanese/Korean Support)"
      echo ""
      echo " b) BACK"
      echo ""
      FONTS_OPTIONS+=" b"
      read_input_options "$FONTS_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            aur_package_install "ttf-anka-coder"
            ;;
          2)
            aur_package_install "ttf-anonymous-pro"
            ;;
          3)
            package_install "ttf-dejavu"
            ;;
          4)
            aur_package_install "ttf-exljbris"
            ;;
          5)
            aur_package_install "ttf-funfonts"
            ;;
          6)
            package_remove ttf-droid
            package_remove ttf-roboto
            package_remove ttf-ubuntu-font-family
            aur_package_install "ttf-google-webfonts"
            ;;
          7)
            package_install "ttf-inconsolata"
            ;;
          8)
            package_install "ttf-liberation"
            ;;
          9)
            aur_package_install "ttf-ms-fonts"
            ;;
          10)
            aur_package_install "ttf-source-code-pro"
            ;;
          11)
            aur_package_install "ttf-vista-fonts"
            ;;
          12)
            package_install "wqy-microhei"
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      elihw
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
  #EXTRA {{{
  install_extra(){
    while [[ 1 ]]
    do
      print_title "EXTRA"
      echo " 1) Elementary Project $AUR"
      echo " 2) Font Configuration $AUR"
      echo ""
      echo " b) BACK"
      echo ""
      EXTRA_OPTIONS+=" b"
      read_input_options "$EXTRA_OPTIONS"
      for OPT in ${OPTIONS[@]}; do
        case "$OPT" in
          1)
            #ELEMENTARY PROJECT {{{
            while [[ 1 ]]
            do
              print_title "ELEMENTARY PROJECT"
              print_warning "\tsome of these programs still in alpha stage and may not work"
              echo " 1) $(menu_item "audience-bzr") (media player)"
              echo " 2) $(menu_item "contractor-bzr") (sharing service)"
              echo " 3) $(menu_item "eidete-bzr") (screencasting)"
              echo " 4) $(menu_item "dexter-contacts-bzr") (contacts manager)"
              echo " 5) $(menu_item "feedler-bzr") (RSS feeds Reader)"
              echo " 6) $(menu_item "pantheon-files-bzr") (file manager)"
              echo " 7) $(menu_item "footnote-bzr") (note taking)"
              echo " 8) $(menu_item "gala-bzr") (compositing manager)"
              echo " 9) $(menu_item "geary-git") (email client)"
              echo "10) $(menu_item "lingo-dictionary-bzr") (dictionary)"
              echo "11) $(menu_item "maya-bzr") (calendar)"
              echo "12) $(menu_item "midori") (web browser)"
              echo "13) $(menu_item "noise-bzr") (audio player)"
              echo "14) $(menu_item "scratch-bzr") (text editor)"
              echo "15) $(menu_item "pantheon-dock-bzr") (dock)"
              echo "16) $(menu_item "pantheon-terminal-bzr") (terminal)"
              echo "17) $(menu_item "slingshot-bzr") (app launcher)"
              echo "18) $(menu_item "snap-elementary-bzr") (photo booth)"
              echo "19) $(menu_item "switchboard-bzr") (desktop settings hub)"
              echo "20) $(menu_item "wingpanel-bzr") (indicators topbar)"
              echo "21) $(menu_item "elementary-icons-bzr" "elementary icons")"
              echo "22) $(menu_item "egtk-bzr" "elementary theme")"
              echo "23) $(menu_item "cerbere-bzr" "session manager")"
              echo ""
              echo " b) BACK"
              echo ""
              ELEMENTARY_OPTIONS+=" b"
              read_input_options "$ELEMENTARY_OPTIONS"
              for OPT in ${OPTIONS[@]}; do
                case "$OPT" in
                  1)
                    aur_package_install "audience-bzr"
                    ;;
                  2)
                    aur_package_install "contractor-bzr"
                    ;;
                  3)
                    aur_package_install "eidete-bzr"
                    ;;
                  4)
                    aur_package_install "dexter-contacts-bzr"
                    ;;
                  5)
                    aur_package_install "feedler-bzr"
                    ;;
                  6)
                    aur_package_install "pantheon-files-bzr tumbler"
                    ;;
                  7)
                    aur_package_install "footnote-bzr"
                    ;;
                  8)
                    aur_package_install "gala-bzr"
                    ;;
                  9)
                    aur_package_install "geary-git"
                    ;;
                  10)
                    aur_package_install "lingo-dictionary-bzr"
                    ;;
                  11)
                    aur_package_install "maya-bzr"
                    ;;
                  12)
                    aur_package_install "midori"
                    ;;
                  13)
                    aur_package_install "noise-bzr"
                    ;;
                  14)
                    aur_package_install "scratch-bzr"
                    ;;
                  15)
                    aur_package_install "pantheon-dock-bzr"
                    ;;
                  16)
                    aur_package_install "pantheon-terminal-bzr"
                    ;;
                  17)
                    aur_package_install "slingshot-bzr"
                    ;;
                  18)
                    aur_package_install "snap-elementary-bzr"
                    ;;
                  19)
                    aur_package_install "switchboard-bzr"
                    ;;
                  20)
                    aur_package_install "wingpanel-bzr"
                    ;;
                  21)
                    aur_package_install "elementary-icons-bzr"
                    gtk-update-icon-cache -f /usr/share/icons/elementary
                    ;;
                  22)
                    aur_package_install "egtk-bzr"
                    ;;
                  23)
                    aur_package_install "cerbere-bzr"
                    ;;
                  "b")
                    break
                    ;;
                  *)
                    invalid_option
                    ;;
                esac
              done
              elihw
            done
            #}}}
            OPT=1
            ;;
          2)
            #FONTS CONFIGURATION {{{
            print_title "FONTS CONFIGURATION - https://wiki.archlinux.org/index.php/Font_Configuration"
            print_warning "\tThese packages may break something or make some programs crash.\n\tUse at your own risk"
            echo " 1) Ubuntu patched packages"
            echo " 2) Infinality patched packages"
            echo " 3) Reverting to unpatched packages"
            echo ""
            echo " b) BACK"
            echo ""
            read_input $FONTSCONFIG_OPTION
            case "$OPTION" in
              1)
                pacman -Rdd --noconfirm cairo fontconfig freetype2 libxft
                aur_package_install "freetype2-ubuntu fontconfig-ubuntu cairo-ubuntu"

                ;;
              2)
                pacman -Rdd --noconfirm freetype2
                aur_package_install "freetype2-infinality fontconfig-infinality-git"
                /etc/profile.d/infinality-settings.sh
                infctl setstyle

                ;;
              3)
                pacman -Rdd freetype2-infinality fontconfig-infinality-git
                pacman -S --asdeps cairo fontconfig freetype2 libxft

                ;;
              *)
                invalid_option
                ;;
            esac
            pause_function
            #}}}
            OPT=2
            ;;
          "b")
            break
            ;;
          *)
            invalid_option
            ;;
        esac
      done
      elihw
    done
  }
  #}}}
  #FINISH {{{
  finish(){
    print_title "WARNING: PACKAGES INSTALLED FROM AUR"
    print_warning "List of packages not officially supported that may kill your cat:"
    pause_function
    pacman -Qm | awk '{print $1}' > aur_pkglist.txt
    less aur_pkglist.txt
    print_title "INSTALL COMPLETED"
    echo -e "Thanks for using the Archlinux Ultimate Install script by helmuthdu\n"
    #REBOOT
    read -p "Reboot yourt system [y/N]: " OPTION
    [[ $OPTION == y ]] && reboot
    exit 0
  }
  #}}}

  welcome
  check_root
  check_archlinux
  check_hostname
  check_connection
  system_upgrade
  language_selector
  configure_sudo
  select_user
  choose_aurhelper
  automatic_mode

  if is_package_installed "kdebase-workspace"; then KDE=1; fi

  while [[ 1 ]]
  do
    print_title "ARCHLINUX ULTIMATE INSTALL - https://github.com/helmuthdu/aui"
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
    echo "14) $(mainmenu_item "${checklist[15]}" "Extra")"
    echo "15) $(mainmenu_item "${checklist[16]}" "Clean Orphan Packages")"
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
          install_ssh
          install_nfs
          install_samba
          install_lmt
          install_preload
          install_zram
          install_xorg
          install_video_cards
          install_cups
          install_additional_firmwares
          install_git_tor
          install_ufw
          checklist[1]=1
          ;;
        2)
          if [[ checklist[1] -eq 0 ]]; then
            print_warning "\nWARNING: YOU MUST RUN THE BASIC SETUP FIRST"
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
          checklist[15]=1
          ;;
        15)
          clean_orphan_packages
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
  ;;
  #}}}
esac
