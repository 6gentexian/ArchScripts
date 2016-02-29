#! /bin/bash
#
#  update.pacman.sh
#
#  This script will update packages downloaded from Arch
#
#  TODO:  Add ability to update private repos vs ABS
#################################################################################
# home dir of pacman scripts
PACMAN_DIR="~/bin/PACMAN"
# TMPDIR set in .bash_profile
PACK_ALL=""
PACK_PAC_ALL=""
PACK_FOR_ALL=""
# -Q
# List all foreign packages (typically manually downloaded and installed): pacman -Qm .
# List all native packages (installed from the sync database(s)): pacman -Qn .
PACK_INSTALL=""
PACK_INSTALL_PAC=""
PACK_INSTALL_FOR=""
# List all explicitly installed packages: pacman -Qe .
# To list explicitly installed packages available in the official repositories: -Qen
# To list explicitly installed packages not available in official repositories: -Qem

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

# force refresh and sync all repositories
prGreen "Refresh, sync, and update all packages"
#sudo pacman -Syyu
echo; echo

# installed packages not available in official repositories, -m, for foreign packages
prYellow "All installed packages *NOT* available in official repositories "
#pacman -Qem
echo; echo

# creating list of all orphaned packages
prYellow "All orphaned packages: \nPackages installed as depedencies but are now neither dependencies nor optional."
#pacman -Qdt; echo ""; echo ""


prGreen "Upgrade complete!!"
#################################################################################


# echo "Updating the Arch Build System local packages"
# sudo abs
# echo ""; echo ""

# # make sure that cache is cleared
# echo "Clearing cache of tarballs..."
# sudo pacman -Sc
# echo ""; echo ""

# # update the mirror list
# echo "Updating the mirrorlist: /etc/pacman.d/mirrorlist"
# /home/edward/bin/reflector.sh > /home/edward/TMP/mirrorlist
# sudo mv /home/edward/TMP/mirrorlist /etc/pacman.d/mirrorlist
# echo ""; echo ""

# # force refresh and sync and update all packages
# echo "Refresh, sync, and update all packages"
# sudo pacmatic -Syyu
# echo ""; echo ""

# # backing up list of all installed packages
# echo "Creating list of all installed packages in: /home/edward/.config/pacman/installed_pkglist.txt"
# mkdir -p /home/edward/.config/pacman
# pacman -Qq > /home/edward/.config/pacman/installed_pkglist.txt
# cp /home/edward/.config/pacman/installed_pkglist.txt /home/edward/Dropbox/TW/SCRIPTS/installed_pkglist.txt
# echo ""; echo ""

# #  backup the current list of pacman installed packages: $ pacman -Qqen > pkglist.txt
# echo "Creating list of all pacman installed packages in: /home/edward/.config/pacman/pacman_installed_pkglist.txt"
# pacman -Qqen > /home/edward/.config/pacman/pacman_installed_pkglist.txt
# cp /home/edward/.config/pacman/pacman_installed_pkglist.txt /home/edward/Dropbox/TW/SCRIPTS/pacman_installed_pkglist.txt
# echo ""; echo ""

# # installed packages not available in official repositories
# echo "All installed packages not available in official repositories "
# pacman -Qem
# echo ""; echo ""


# # creating list of all orphaned packages
# echo "All orphaned packages: Packages that were installed as depedencies but are now not needed"
# sudo pacman -Qdt
# echo ""; echo ""
# ########################################################
