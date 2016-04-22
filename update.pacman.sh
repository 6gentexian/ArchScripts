#!/bin/bash
#
#  ~/bin/update.pacman.sh
#
#
#  Dependencies:
#    reflector.sh
#
#  This script will:
#    * Update/sync repos and packages downloaded from Arch
#    * Create files containing the names of all local packages
#
#  Use:
#    Place reflector.sh and update.pacman.sh somewhere in your $PATH, e.g. ~/bin
#    $ ./update.pacman.sh
#
#  n.b.
#    $TMPDIR is set in .bash_profile or /etc/profile
#
#  TODO:  Add ability to update private repos
#################################################################################
# Local dir for pacman output files
PACMAN_CONFIG_DIR="$HOME/.config/pacman"

# Destination for output files -- inside dropbox to archive
DEST_DIR="$HOME/Dropbox/TW/SCRIPTS"

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

#################################################################################
## To be used for updating private repos
#UPDATE=""
#################################################################################
# Custom functions ----
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
  print_line $1
  # Move the cursor up 1 line:
  tput cuu1; tput cuu1
  $1 "#   ${Bold}$2${Reset}"
  tput cuu1
  print_line $1
}

log_to_markdown()
{
  # Here we have the function that will
  #     1 load /var/log/arch-news.log
  #     2 use awk to strip "\n" from file
  #     3 use html2text to poop into markdown
  #     4 view news in #MarkdownReader
  #     5 prompt to continue
  if [ -f /var/log/arch-news.log ]; then

      cp /var/log/arch-news.log $TMPDIR
      sudo chown $USER:users  $TMPDIR/arch-news.log

      awk '{gsub(/\\n/,"\n")}1' $TMPDIR/arch-news.log > $TMPDIR/tmp.html
      html2text $TMPDIR/tmp.html > $TMPDIR/tmp.md

      markdown-reader $TMPDIR/tmp.md
  fi

  while true; do
      echo; prYellow "Would you like to continue?"
      read -p "" yn

      case $yn in
          [Yy]* )
              break
          ;;
          [Nn]* )
              prGreen "Good bye!"
              exit 0
              ;;
          * ) echo "Please answer yes or no.";;
      esac
  done
}
#################################################################################
# Prep for updating
clear

#################################################################################
# Update the mirror list for pacman and select the fastest for your locale.
while true; do
    echo; prYellow "Would you like to update the mirrorlist?"
    read -p "" yn

    case $yn in
        [Yy]* )
            prGreen "Updating the mirrorlist and choosing the fastest mirror: /etc/pacman.d/mirrorlist"
            ~/bin/reflector.sh > $TMPDIR/mirrorlist
            sudo mv $TMPDIR/mirrorlist /etc/pacman.d/mirrorlist
            echo; break
            ;;
        [Nn]* )
            prGreen "Keeping current mirrorlist!"
            echo; break
            ;;
        * ) echo "Please answer yes or no.";;
    esac
done
#################################################################################

# Begin updates: Clear cache of tarballs -> UP pacman -> UP ABS -> UP AUR packages
# 1. make sure that cache is cleared
prYellow "Clearing cache of tarballs..."
sudo pacman -Sc
echo; echo

# Preferably use pacmatic to update things, install if needed.
# Otherwise use pacman
if [ -f /usr/bin/pacmatic ]; then
    # Refresh and sync all repositories
    prGreen "Refresh, sync, and update all official repos with pacmatic"
    sudo pacmatic -Syu

    # Examine latest news from arch-world!
    log_to_markdown
else
    while true; do
        echo; prYellow "Would you like to use pacmatic to update (recommended)?"
        read -p "" yn

        case $yn in
            [Yy]* )
                sudo pacman -S pacmatic
                sudo pacmatic -Syy
                log_to_markdown
                sudo pacmatic -Su; break
                ;;
            [Nn]* )
                prYellow "Updating with pacman"
                sudo pacman -Syy
                sudo pacman -Su; break
                ;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi
echo; echo


# 3. ABS
prGreen "Updating the Arch Build System local package repo"
sudo abs
echo; echo

# 4. Update the AUR packages
prGreen "Sync AUR repos and update AUR packages"
packer -Syu --auronly
echo;  echo


#################################################################################
# Output files to archive - classify packages in various ways and store
# package lists in various files (in order to restore system)

# Backup list of all local packages on this machine
prGreen "Creating list of **all** packages on $HOSTNAME: ~/.config/pacman/all_pkgs.txt"
mkdir -p $PACMAN_CONFIG_DIR
pacman -Qq > $PKG_ALL
mv $PKG_ALL  $DEST_DIR
echo; echo

# Backup list of official repo packages
prGreen "Creating list of packages from the official repos: ~/.config/pacman/pacman_pkgs.txt"
pacman -Qqn > $PKG_PAC_ALL
mv $PKG_PAC_ALL  $DEST_DIR
echo; echo

# Backup list of packages not available in official repositories, -m, for foreign packages
prGreen "Creating list of foreign packages -- i.e. those *NOT* from official repositories:\n  ~/.config/pacman/foreign_pkgs.txt"
pacman -Qqm > $PKG_FOR_ALL
mv $PKG_FOR_ALL  $DEST_DIR
echo; echo

# Backup list of pacman installed packages, not the deps of installed packages
prGreen "Creating list of pacman installed packages, not the deps of installed packages:\n ~/.config/pacman/pacman_installed_pkgs.txt"
pacman -Qqen > $PKG_INSTALL_PAC
mv $PKG_INSTALL_PAC  $DEST_DIR
echo; echo

# Backup list of installed packages not available in official repositories, -m, for foreign packages
prGreen "Creating list of installed foreign packages -- i.e. *NOT* the deps of foreign packages:\n  ~/.config/pacman/foreign_installed_pkgs.txt"
pacman -Qqem > $PKG_INSTALL_FOR
mv $PKG_INSTALL_FOR  $DEST_DIR
echo; echo


#################################################################################
# Remove orphaned and/or optional packages
#
prRed "All orphaned packages: \nPackages installed as depedencies but are now neither dependencies nor optional."
pacman -Qdt;
echo; echo

    while true; do
        echo; prYellow "Would you like to remove the orphans (recommended)?"
        read -p "" yn

        case $yn in
            [Yy]* )
                sudo pacman -Rns $(pacman -Qtdq); break
                ;;
            [Nn]* )
                prGreen "Orphans left alone"; break
                ;;
            * ) echo "Please answer yes or no.";;
        esac
    done


prRed "The following packages are optional for some installed package, but are otherwise not needed"
(comm -13 <(pacman -Qdtq) <(pacman -Qdttq))
echo; echo

    while true; do
        echo; prYellow "Would you like to remove the optional packages?"
        read -p "" yn

        case $yn in
            [Yy]* )
                sudo pacman -Rns $(comm -13 <(pacman -Qdtq) <(pacman -Qdttq)); break
                ;;
            [Nn]* )
                prGreen "Optional packages left alone"; break
                ;;
            * ) echo "Please answer yes or no.";;
        esac
    done


################################################################################
print_title prGreen "Sync/Upgrade complete!!"
#################################################################################




#################################################################################
# Other useful things:  Back-up the pacman database -----------------------------
#
#
# The following command can be used to back up the local pacman database:
#
# $ tar -cjf pacman_database.tar.bz2 /var/lib/pacman/local
#
#
# n.b.
#     The database can be restored by moving the pacman_database.tar.bz2
#     file into the / directory and executing the following command:
#
# $ sudo tar -xjvf pacman_database.tar.bz2
#################################################################################
