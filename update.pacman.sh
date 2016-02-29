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
#################################################################################

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
sudo pacman -Syyu
echo; echo

# installed packages not available in official repositories, -m, for foreign packages
prYellow "All installed packages *NOT* available in official repositories "
pacman -Qem
echo; echo

# creating list of all orphaned packages
prYellow "All orphaned packages: \nPackages installed as depedencies but are now neither dependencies nor optional."
pacman -Qdt; echo ""; echo ""


prGreen "Upgrade complete!!"
#################################################################################
