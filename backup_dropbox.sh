#!/bin/bash
#
# script will provide cron with all info needed for complete system back up
################################################################################

# ARCHIVE ----------------------------------------------------------------------
SOURCE="/archive/"
BACKUP_DIR="/home/edward/Dropbox/moe"
LOG="--log-file=/home/edward/.local/logs/backup-dropbox.log"
DEST=$BACKUP_DIR"/archive"

# REM: From rsync point of view, exclude path is always relative
EX_DIRS="--exclude=tmp/"
EX_DIRS+=" --exclude=lost+found/"

EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_larry/edward/.cache"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_larry/edward/.mozilla/firefox/hjg1akph.default/cache2"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_larry/edward/LAPTOP_WIN/Local/Mozilla/Firefox/Profiles"

EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_larry/edward/LAPTOP_WIN/Local/Temp"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_larry/edward/.meteor"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_larry/edward/LAPTOP_WIN/Local/Microsoft/Windows/Temporary*"

EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_larry/edward/LAPTOP_WIN/Local/Opera/Opera/cache"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_larry/edward/R"

EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_moe/edward/.cache"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_moe/edward/.mozilla/firefox/gnfgdfwb.default/Cache"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/edward_moe/edward/.wine"

EX_DIRS+=" --exclude=OLD_STUFF/EBG/LAPTOP-WIN/Praxeum/Local/Temp"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/LAPTOP-WIN/Praxeum/Local/Mozilla/Firefox/Profiles/60x3fb9o.default/Cache"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/LAPTOP-WIN/Praxeum/Local/Opera/Opera/cache"

EX_DIRS+=" --exclude=OLD_STUFF/EBG/Old_stuff/R-2.7.1"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/Old_stuff/R-2.8.1"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/Old_stuff/R-2.9.0"

EX_DIRS+=" --exclude=OLD_STUFF/EBG/BME/wiki/GDP/FRED2_txt_2"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/DEV"
EX_DIRS+=" --exclude=OLD_STUFF/EBG/HIMCO/GDP/FRED2_txt_2"



# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f ~/.local/logs/backup-dropbox.log ]; then
    mkdir -p ~/.local/logs
    touch ~/.local/logs/backup-dropbox.log
    echo "Dropbox BU log created"
else
    echo "*NEW* Dropbox BU log created"
fi


echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# ARCHIVE ----------------------------------------------------------------------



# SFTP -------------------------------------------------------------------------
SOURCE="/sftp/"
DEST=$BACKUP_DIR"/sftp"


echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# SFTP -------------------------------------------------------------------------


# HOME -------------------------------------------------------------------------
SOURCE="/home/edward/"
DEST=$BACKUP_DIR"/edward"
EX_DIRS="--exclude=TMP"
EX_DIRS+=" --exclude=.local/share/Trash"
EX_DIRS+=" --exclude=.cache"
EX_DIRS+=" --exclude=.ccache"
EX_DIRS+=" --exclude=Dropbox"
EX_DIRS+=" --exclude=ARCH/SRC_TEMP"
EX_DIRS+=" --exclude=Downloads"
EX_DIRS+=" --exclude=R_LIBS"


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# HOME --------------------------------------------------------------------------



# var     ----------------------------------------------------------------------
SOURCE="/var/"
DEST=$BACKUP_DIR"/var"
EX_DIRS="--exclude=tmp"
EX_DIRS+=" --exclude=cache"
EX_DIRS+=" --exclude=games"
EX_DIRS+=" --exclude=abs"

echo
echo
echo "#####################################################################"
echo "                              /var                                   "
echo "#####################################################################"
echo
echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# var     ----------------------------------------------------------------------



# /usr/local -------------------------------------------------------------------
SOURCE="/usr/local/"
DEST=$BACKUP_DIR"/local"
EX_DIRS="--exclude=games/"
EX_DIRS+=" --exclude=lost+found/"


echo
echo
echo "#####################################################################"
echo "                              /usr/local                             "
echo "#####################################################################"
echo
echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# /usr/local -------------------------------------------------------------------



# /etc       -------------------------------------------------------------------
SOURCE="/etc/"
DEST=$BACKUP_DIR"/etc"
EX_DIRS="--exclude=sudoers.d/"
EX_DIRS+=" --exclude=tmpfiles.d/"


echo
echo
echo "#####################################################################"
echo "                              /etc                                   "
echo "#####################################################################"
echo
echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# /etc       -------------------------------------------------------------------



# /boot      -------------------------------------------------------------------
SOURCE="/boot/"
DEST=$BACKUP_DIR"/boot"
EX_DIRS="--exclude=lost+found"


echo
echo
echo "#####################################################################"
echo "                              /boot                                  "
echo "#####################################################################"
echo
echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# /boot      -------------------------------------------------------------------
