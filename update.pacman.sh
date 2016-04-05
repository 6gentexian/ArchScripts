#!/bin/bash
#
#  update.pacman.sh
#
#
#  Dependencies:
#    reflector.sh
#
#  This script will:
#    Update/sync repos and packages downloaded from Arch
#    Create files containing the names of all packages
#    installed on the local system
#
#  Use:
#    Place reflector.sh and update.pacman.sh somewhere in your $PATH, e.g. ~/bin
#    $ ./update.pacman.sh
#
#  n.b.
#    All generic functions used are in .bashrc. They are commented out at
#      the end of this file if you don't want to place them in your startup file.
#    $TMPDIR is set in .bash_profile
#
#  TODO:  Add ability to update private repos vs ABS
#################################################################################
# Local dir for pacman output files
PACMAN_CONFIG_DIR="~/.config/pacman"
# Destination for output -- inside dropbox in this case
DEST_DIR="~/Dropbox/TW/SCRIPTS"

#################################################################################
# Output file names
#
# pacman -Q   List all local packages
# pacman -Qm  List all foreign packages (e.g. manually downloaded and installed)
# pacman -Qn  List all native packages (installed from official sync'd database(s))
PKG_ALL=$PACMAN_CONFIG_DIR"/all_pkgs.txt"
PKG_PAC_ALL=$PACMAN_CONFIG_DIR"/pacman_pkgs.txt"
PKG_FOR_ALL=$PACMAN_CONFIG_DIR"/foreign_pkgs.txt"
# pacman -Qe  List all explicitly installed packages
# pacman -Qen List explicitly installed packages available in the official repos
# pacman -Qem List explicitly installed packages *not* available in official repos
PKG_INSTALL=$PACMAN_CONFIG_DIR"/all_installed_pkgs.txt"
PKG_INSTALL_PAC=$PACMAN_CONFIG_DIR"/pacman_installed_pkgs.txt"
PKG_INSTALL_FOR=$PACMAN_CONFIG_DIR"/foreign_installed_pkgs.txt"

#################################################################################

#################################################################################
RESET='\e[0m'           # Text Reset
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
#################################################################################
## To be used for updating private repos
#UPDATE=""
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

print_line() {
  $1 "%$(tput cols)s\n"|tr ' ' '-'
}
print_title() {
  clear
  print_line $1
  # Move the cursor up 1 line:
  tput cuu1; tput cuu1
  $1 "#   ${Bold}$2${Reset}"
  tput cuu1
  print_line $1
}
#################################################################################
print_title prGreen "Test the title"


exit 0


if [ -f /usr/bin/pacmatic ]; then
    # Refresh and sync all repositories
    prGreen "Refresh, sync, and update all official repos with pacmatic"
    sudo pacmatic -Syy
    echo
    # (AAA) Here we need the function that will
    #         1 load /var/log/arch-news.log
    #         2 use awk to strip "\n" from file
    #         3 use html2text to poop into markdown
    #         4 view news in #EDITOR
    #         5 prompt to continue
    #sudo pacmatic -Su

else
    while true; do
        read -p prYellow "Would you like to use pacmatic to update (recommended)?" yn
        case $yn in
            [Yy]* )
                sudo pacman -S pacmatic
                sudo pacmatic -Syy
                # deploy (AAA)
                #sudo pacmatic -Su
                ;;
            [Nn]* )
                prYellow "Updating with pacman"
                sudo pacman -Syy
                #sudo pacman -Su
                ;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi
echo; echo


prGreen "Updating the Arch Build System local package repo"
# sudo abs
echo; echo

# make sure that cache is cleared
prYellow "Clearing cache of tarballs..."
# sudo pacman -Sc
echo; echo

# Update AUR packages
prGreen "Sync AUR repos and update AUR packages"
#packer -Syu --auronly
echo;  echo

#################################################################################
## Output files
##
# update the mirror list for pacman
prGreen "Updating the mirrorlist: /etc/pacman.d/mirrorlist"
# ~/bin/reflector.sh > $TMPDIR/mirrorlist
# sudo mv $TMPDIR/mirrorlist /etc/pacman.d/mirrorlist
echo; echo

# backing up list of all installed packages
prGreen "Creating list of all installed packages in: ~/.config/pacman/all_pkgs.txt"
# mkdir -p $PACMAN_CONFIG_DIR
# pacman -Qq > $PKG_ALL
# mv $PKG_ALL  $DEST_DIR  #~/Dropbox/TW/SCRIPTS/all_pkgs.txt
echo; echo

#  backup the current list of official repo packages
prGreen "Creating list of all packages from the official repos: ~/.config/pacman/pacman_pkgs.txt"
# pacman -Qqn > $PKG_PAC_ALL
# mv $PKG_PAC_ALL  $DEST_DIR
echo; echo

# backup current list of packages not available in official repositories, -m, for foreign packages
prGreen "Creating list of all foreign packages -- i.e. those *NOT* available in official repositories in:\n  ~/.config/pacman/foreign_pkgs.txt"
#pacman -Qqm > $PKG_FOR_ALL
# mv $PKG_FOR_ALL  $DEST_DIR
echo; echo

#  backup the current list of pacman installed packages
prGreen "Creating list of all pacman installed packages in: ~/.config/pacman/pacman_installed_pkgs.txt"
# pacman -Qqen > $PKG_INSTALL_PAC
# mv $PKG_INSTALL_PAC  $DEST_DIR
echo; echo

# installed packages not available in official repositories, -m, for foreign packages
prGreen "All installed foreign packages -- i.e. those *NOT* available in official repositories in:\n  ~/.config/pacman/foreign_installed_pkgs.txt"
#pacman -Qqem > $PKG_INSTALL_FOR
# mv $PKG_INSTALL_FOR  $DEST_DIR
echo; echo


#################################################################################
# Remove orphaned and/or optional packages
#
prRed "All orphaned packages: \nPackages installed as depedencies but are now neither dependencies nor optional."
pacman -Qdt;
echo; echo

    while true; do
        read -p prYellow "Would you like to remove the orphans (recommended)?" yn
        case $yn in
            [Yy]* )
                sudo pacman -Rns $(pacman -Qtdq)
                ;;
            [Nn]* )
                prGreen "Orphans left alone"
                ;;
            * ) echo "Please answer yes or no.";;
        esac
    done


prRed "The following packages are optional for some installed package, but are otherwise not needed"
(comm -13 <(pacman -Qdtq) <(pacman -Qdttq))
echo; echo

    while true; do
        read -p prYellow "Would you like to remove the optional packages?" yn
        case $yn in
            [Yy]* )
                sudo pacman -Rns $(comm -13 <(pacman -Qdtq) <(pacman -Qdttq))
                ;;
            [Nn]* )
                prGreen "Optional packages left alone"
                ;;
            * ) echo "Please answer yes or no.";;
        esac
    done

################################################################################
prGreen "Sync/Upgrade complete!!"
#################################################################################


#################################################################################
# Other useful things
#
#
#
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


# #################################################################################
# RESET='\e[0m'           # Text Reset
# BRed='\e[1;31m'         # Red
# BGreen='\e[1;32m'       # Green
# BYellow='\e[1;33m'      # Yellow
# BBlue='\e[1;34m'        # Blue
# #################################################################################
# ## To be used for updating private repos
# #UPDATE=""
# prYellow()
# {
#     echo
#     printf "${BYellow}$1${RESET}\n"
#     echo
# }
# prRed()
# {
#     echo
#     printf "${BRed}$1${RESET}\n"
#     echo
# }
# prBlue()
# {
#     echo
#     printf "${BBlue}$1${RESET}\n"
#     echo
# }
# prGreen()
# {
#     echo
#     printf "${BGreen}$1${RESET}\n"
#     echo
# }
# print_line() {
#   $1 "%$(tput cols)s\n"|tr ' ' '-'
# }
# print_title() {
#   clear
#   print_line $1
#   echo -e "# ${Bold}$2${Reset}"
#   print_line $1
#   echo
# }
