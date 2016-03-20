#! /bin/bash
#
#  update.pacman.sh
#
#  This script will:
#    Update/sync repos and packages downloaded from Arch
#    Create files containing the names of all packages
#    installed on the local system
#
#  TODO:  Add ability to update private repos vs ABS
#         test for and install pacmatic
#         add option to delete orphaned packages
#################################################################################
# home dir of pacman scripts
PACMAN_USER_SCRIPT_DIR="~/bin/PACMAN"
PACMAN_USER_CONFIG_DIR="~/.config/pacman"
# n.b. TMPDIR is set in .bash_profile
DROPBOX_DIR="~/Dropbox/TW/SCRIPTS"

#################################################################################
# pacman -Q   List all local packages
# pacman -Qm  List all foreign packages (typically manually downloaded and installed)
# pacman -Qn  List all native packages (installed from official sync'd database(s))
PKG_ALL=$PACMAN_USER_CONFIG_DIR"/all_pkgs.txt"
PKG_PAC_ALL=$PACMAN_USER_CONFIG_DIR"/pacman_pkgs.txt"
PKG_FOR_ALL=$PACMAN_USER_CONFIG_DIR"/for_pkgs.txt"
# pacman -Qe  List all explicitly installed packages
# pacman -Qe  List explicitly installed packages available in the official repos
# pacman -Qe  List explicitly installed packages *not* available in official repos
PKG_INSTALL=$PACMAN_USER_CONFIG_DIR"/all_installed_pkgs.txt"
PKG_INSTALL_PAC=$PACMAN_USER_CONFIG_DIR"/pacman_installed_pkgs.txt"
PKG_INSTALL_FOR=$PACMAN_USER_CONFIG_DIR"/for_installed_pkgs.txt"

#################################################################################
echo $TMPDIR
echo
echo $R_HOME
#################################################################################
RESET='\e[0m'           # Text Reset
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
#################################################################################
UPDATE=""
prYellow()
{
    echo
    printf "${BYellow}$1${RESET}\n"
    echo
}
prRed()
{
    echo
    printf "${BRed}$1${RESET}\n"
    echo
}
prBlue()
{
    echo
    printf "${BBlue}$1${RESET}\n"
    echo
}
prGreen()
{
    echo
    printf "${BGreen}$1${RESET}\n"
    echo
}

# Refresh and sync all repositories and packages
prGreen "Refresh, sync, and update all repos and packages"
#sudo pacmatic -Syyu
echo; echo

prYellow "Updating the Arch Build System local package repo"
# sudo abs
echo; echo

# make sure that cache is cleared
prRed "Clearing cache of tarballs..."
# sudo pacman -Sc
echo; echo

#################################################################################
## Output files
##
# update the mirror list for pacman
prYellow "Updating the mirrorlist: /etc/pacman.d/mirrorlist"
# ~/bin/reflector.sh > $TMPDIR/mirrorlist
# sudo mv $TMPDIR/mirrorlist /etc/pacman.d/mirrorlist
echo; echo

# backing up list of all installed packages
prYellow "Creating list of all installed packages in: ~/.config/pacman/installed_pkglist.txt"
# mkdir -p $PACMAN_USER_CONFIG_DIR
# pacman -Qq > $PKG_ALL
# cp $PKG_ALL  $DROPBOX_DIR  #~/Dropbox/TW/SCRIPTS/installed_pkglist.txt

#  backup the current list of pacman installed packages: $ pacman -Qqen > pkglist.txt
prYellow "Creating list of all pacman installed packages in: ~/.config/pacman/pacman_installed_pkglist.txt"
# pacman -Qqen > $PKG_PAC_ALL
# cp $PKG_PAC_ALL  $DROPBOX_DIR   #~/Dropbox/TW/SCRIPTS/pacman_installed_pkglist.txt

# installed packages not available in official repositories, -m, for foreign packages
prYellow "All installed foreign packages -- i.e. those *NOT* available in official repositories "
#pacman -Qem > $PKG_FOR_ALL
echo; echo

# creating list of all orphaned packages
prRed "All orphaned packages: \nPackages installed as depedencies but are now neither dependencies nor optional."
#pacman -Qdt;
echo; echo


prGreen "Sync/Upgrade complete!!"
#################################################################################
