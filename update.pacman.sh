#! /bin/bash
#
# update.pacman.sh
#
#
#################################################################################
# home dir of pacman scripts
PACMAN_DIR="~/bin/PACMAN"
# TMPDIR set in .bash_profile
#################################################################################
# Update the abs
echo "Updating the Arch Build System local packages"
sudo abs
echo ""; echo ""

# make sure that pacman cache is cleared
echo "Clearing cache of tarballs..."
sudo pacman -Sc
echo ""; echo ""

# update the mirror list
echo "Updating the mirrorlist: /etc/pacman.d/mirrorlist"
# make a temp copy of the new mirrorlist just in case
$PACMAN_DIR"/reflector.sh" > $TMPDIR"/mirrorlist"
sudo mv $TMPDIR"/mirrorlist" /etc/pacman.d/mirrorlist
echo ""; echo ""

# force refresh and sync and update all packages
echo "Refresh, sync, and update all packages"
sudo pacmatic -Syyu
echo ""; echo ""

# backing up list of all installed packages
echo "Creating list of all installed packages in: ~/.config/pacman/installed_pkglist.txt"
mkdir -p ~/.config/pacman
# Query local package database quietly: pacman -Qq
pacman -Qq > ~/.config/pacman/installed_pkglist.txt
# make a copy in tiddlywiki folder in Dropbox
cp ~/.config/pacman/installed_pkglist.txt ~/Dropbox/TW/SCRIPTS/installed_pkglist.txt
echo ""; echo ""

# current list of explicitly ( -e) installed (via pacman aka -n, natively) packages:
#  $ pacman -Qqen > file
echo "Creating list of all explicitly install (via pacman) packages in: ~/.config/pacman/pacman_installed_pkglist.txt"
pacman -Qqen > ~/.config/pacman/pacman_installed_pkglist.txt
cp ~/.config/pacman/pacman_installed_pkglist.txt ~/Dropbox/TW/SCRIPTS/pacman_installed_pkglist.txt
echo ""; echo ""

# installed packages not available in official repositories, -m, for foreign packages
echo "All installed packages not available in official repositories "
pacman -Qem
echo ""; echo ""

# creating list of all orphaned packages
echo "All orphaned packages: Packages that were installed as depedencies but are now not needed"
sudo pacman -Qdt
echo ""; echo ""

#################################################################################
