#!/bin/bash
#
# script will provide cron with all info needed for complete system back up
################################################################################

# WEG - CONTACTS  -------------------------------------------------------------#
SOURCE="/Users/WEG/Contacts/"
BACKUP_DIR="/archive/CONTACTS"
LOG="--log-file=/home/edward/.local/logs/backup-mac-contacts.log"
DEST=$BACKUP_DIR
EX_DIRS="--exclude=.DS_Store"



# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f /home/edward/.local/logs/backup-mac-contacts.log ]; then
    mkdir -p /home/edward/.local/logs
    touch /home/edward/.local/logs/backup-mac-contacts.log
    echo "Archive BU log created"
else
    echo "*NEW* archive BU log created"
fi

echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -nrlogtpD -e ssh WEG@192.168.1.7:$SOURCE $DEST $LOG
rsync -rlogtpD -e ssh WEG@192.168.1.7:$SOURCE $DEST $LOG
# WEG - CONTACTS  -------------------------------------------------------------#



# WEG - DOCUMENTS  ------------------------------------------------------------#
SOURCE="/Users/WEG/Documents/"
BACKUP_DIR="/archive/DOCUMENTS"
LOG="--log-file=/home/edward/.local/logs/backup-mac-documents.log"
DEST=$BACKUP_DIR
EX_DIRS="--exclude=.DS_Store"



# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f /home/edward/.local/logs/backup-mac-documents.log ]; then
    mkdir -p /home/edward/.local/logs
    touch /home/edward/.local/logs/backup-mac-documents.log
    echo "Archive BU log created"
else
    echo "*NEW* archive BU log created"
fi

echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -nrlogtpD -e ssh WEG@192.168.1.7:$SOURCE $DEST $LOG
rsync -rlogtpD -e ssh WEG@192.168.1.7:$SOURCE $DEST $LOG
#WEG - DOCUMENTS  --------------------------------------------------------------#



# WEG - MUSIC  ----------------------------------------------------------------#
SOURCE="/Users/WEG/Music/"
BACKUP_DIR="/archive/MUSIC/WEG"
LOG="--log-file=/home/edward/.local/logs/backup-mac-music.log"
DEST=$BACKUP_DIR
EX_DIRS="--exclude=.DS_Store"


# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f /home/edward/.local/logs/backup-mac-music.log ]; then
    mkdir -p /home/edward/.local/logs
    touch /home/edward/.local/logs/backup-mac-music.log
    echo "Archive BU log created"
else
    echo "*NEW* archive BU log created"
fi

echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -nrlogtpD -e ssh WEG@192.168.1.7:$SOURCE $DEST $LOG
rsync -rlogtpD -e ssh WEG@192.168.1.7:$SOURCE $DEST $LOG
# WEG - MUSIC   ---------------------------------------------------------------#


# WEG - MOVIES  ---------------------------------------------------------------#
SOURCE="/Users/WEG/Movies/"
BACKUP_DIR="/archive/MOVIES/WEG"
LOG="--log-file=/home/edward/.local/logs/backup-mac-movies.log"
DEST=$BACKUP_DIR
EX_DIRS="--exclude=.DS_Store"


# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f /home/edward/.local/logs/backup-mac-movies.log ]; then
    mkdir -p /home/edward/.local/logs
    touch /home/edward/.local/logs/backup-mac-movies.log
    echo "Archive BU log created"
else
    echo "*NEW* archive BU log created"
fi

echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -nrlogtpD -e ssh WEG@192.168.1.7:$SOURCE $DEST $LOG
rsync -rlogtpD -e ssh WEG@192.168.1.7:$SOURCE $DEST $LOG
# WEG - MOVIES  ---------------------------------------------------------------#


# WEG - PICTURES  -------------------------------------------------------------#
SOURCE="/Users/WEG/Pictures/"
BACKUP_DIR="/archive/PICTURES/WEG"
LOG="--log-file=/home/edward/.local/logs/backup-mac-pictures.log"
DEST=$BACKUP_DIR
EX_DIRS="--exclude=.DS_Store"


# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f /home/edward/.local/logs/backup-mac-pictures.log ]; then
    mkdir -p /home/edward/.local/logs
    touch /home/edward/.local/logs/backup-mac-pictures.log
    echo "Archive BU log created"
else
    echo "*NEW* archive BU log created"
fi

echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -nrlogtpD -e ssh WEG@192.168.1.7:$SOURCE $DEST $LOG
rsync -rlogtpD -e ssh WEG@192.168.1.7:$SOURCE $DEST $LOG
# WEG - PICTURES  -------------------------------------------------------------#
