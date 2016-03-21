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
#         add AUR - paclog to check on AUR updates
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
PKG_FOR_ALL=$PACMAN_USER_CONFIG_DIR"/foreign_pkgs.txt"
# pacman -Qe  List all explicitly installed packages
# pacman -Qen  List explicitly installed packages available in the official repos
# pacman -Qem  List explicitly installed packages *not* available in official repos
PKG_INSTALL=$PACMAN_USER_CONFIG_DIR"/all_installed_pkgs.txt"
PKG_INSTALL_PAC=$PACMAN_USER_CONFIG_DIR"/pacman_installed_pkgs.txt"
PKG_INSTALL_FOR=$PACMAN_USER_CONFIG_DIR"/foreign_installed_pkgs.txt"

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

# Refresh and sync all repositories
prGreen "Refresh, sync, and update all repos"
#sudo pacman -Syy
echo; echo

# Update all packages
prGreen "Update all packages ---------------------------"
echo

if [ -f /usr/bin/pacmatic ]; then
    sudo pacmatic -Su
else
    while true; do
        read -p "Would you like to use pacmatic to update (recommended)?" yn
        case $yn in
            [Yy]* ) sudo pacman -S pacmatic; sudo pacmatic -Su; break;;
            [Nn]* ) sudo pacman -Su; exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi
echo; echo

prGreen "Updating the Arch Build System local package repo"
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
prGreen "Updating the mirrorlist: /etc/pacman.d/mirrorlist"
# ~/bin/reflector.sh > $TMPDIR/mirrorlist
# sudo mv $TMPDIR/mirrorlist /etc/pacman.d/mirrorlist
echo; echo

# backing up list of all installed packages
prBlue "Creating list of all installed packages in: ~/.config/pacman/all_pkgs.txt"
# mkdir -p $PACMAN_USER_CONFIG_DIR
# pacman -Qq > $PKG_ALL
# mv $PKG_ALL  $DROPBOX_DIR  #~/Dropbox/TW/SCRIPTS/all_pkgs.txt
echo; echo

#  backup the current list of official repo packages
prBlue "Creating list of all packages from the official repos: ~/.config/pacman/pacman_pkgs.txt"
# pacman -Qqn > $PKG_PAC_ALL
# mv $PKG_PAC_ALL  $DROPBOX_DIR
echo; echo

# backup current list of packages not available in official repositories, -m, for foreign packages
prBlue "Creating list of all foreign packages -- i.e. those *NOT* available in official repositories"
prYellow "in:  ~/.config/pacman/foreign_pkgs.txt"
#pacman -Qqm > $PKG_FOR_ALL
# mv $PKG_FOR_ALL  $DROPBOX_DIR
echo; echo

#  backup the current list of pacman installed packages
prBlue "Creating list of all pacman installed packages in: ~/.config/pacman/pacman_installed_pkgs.txt"
# pacman -Qqen > $PKG_INSTALL_PAC
# mv $PKG_INSTALL_PAC  $DROPBOX_DIR
echo; echo

# installed packages not available in official repositories, -m, for foreign packages
prBlue "All installed foreign packages -- i.e. those *NOT* available in official repositories"
prBlue "in:  ~/.config/pacman/foreign_installed_pkgs.txt"
#pacman -Qqem > $PKG_INSTALL_FOR
# mv $PKG_INSTALL_FOR  $DROPBOX_DIR
echo; echo

# creating list of all orphaned packages
prRed "All orphaned packages: \nPackages installed as depedencies but are now neither dependencies nor optional."
#pacman -Qdt;
echo; echo

prRed "The following packages are optional for some installed package, but are otherwise not needed"
(comm -13 <(pacman -Qdtq) <(pacman -Qdttq))
echo; echo


#############
# Check changelogs easily
# When maintainers update packages, commits are often commented in a useful fashion.
# Users can quickly check these from the command line by installing paclogAUR.
# This utility lists recent commit messages for packages from the official repositories
# or the AUR, by using paclog package
#############


#################################################################################
# Back-up the pacman database ---------------------------------------------------
#
# The following command can be used to back up the local pacman database:
#
# $ tar -cjf pacman_database.tar.bz2 /var/lib/pacman/local
#
#
# n.b. The database can be restored by moving the pacman_database.tar.bz2
#        file into the / directory and executing the following command:
#
# $ sudo tar -xjvf pacman_database.tar.bz2
################################################################################
prGreen "Sync/Upgrade complete!!"
#################################################################################
