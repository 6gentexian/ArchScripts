#!/bin/bash
# script will provide cron with all info needed for complete system back up
################################################################################
# HOME -------------------------------------------------------------------------
cd ~/

MAX_BACKUPS=31
SOURCE="/home/edward"
BACKUP_DIR="/backup/home"
LOG="--log-file=.local/logs/backup-home.log"
DEST=$BACKUP_DIR"/backup.0"

## REM: From rsync point of view, exclude path is always relative
EX_DIRS="--exclude=TMP"
EX_DIRS+=" --exclude=.local/share/Trash"
EX_DIRS+=" --exclude=.cache"
EX_DIRS+=" --exclude=.ccache"

EX_DIRS+=" --exclude=Dropbox"
EX_DIRS+=" --exclude=ARCH/SRC_TEMP"
EX_DIRS+=" --exclude=Downloads"
EX_DIRS+=" --exclude=R_LIBS"

EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default/Cache"
EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default/_CACHE_CLEAN_"
EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default/lock"
EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default/thumbnails"

#EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default-backup/Cache"
#EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default-backup/_CACHE_CLEAN_"
#EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default-backup/lock"
#EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default-backup/thumbnails"

EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default-backup-crash*/Cache"
EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default-backup-crash*/_CACHE_CLEAN_"
EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default-backup-crash*/lock"
EX_DIRS+=" --exclude=.moonchild*/pale*/dfckn2bo.default-backup-crash*/thumbnails"


nDir=$(find $BACKUP_DIR -maxdepth 1 -iname "backup*" -type d | wc -l)

# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f ~/.local/logs/backup-home.log ]; then
    mkdir -p ~/.local/logs
    touch ~/.local/logs/backup-home.log
    echo "Home BU log created"
else
    echo "*NEW* home BU log created"
fi


# CASE 1: nDir == 0  ==> CREATE DESTINATION FOLDER
if [ $nDir -eq 0 ]; then
     mkdir -p $DEST
     echo "No BU dir - so "$DEST" was created"

# CASE 2: nDir == 1  ==> COPY DESTINATION FOLDER, DO INCREMENTAL BACKUP
elif [ $nDir -eq 1 ]; then
    cp -al $DEST $BACKUP_DIR"/backup.1"
    echo "ONE BU Directory Found"

# CASE 3: nDir == MAX_BACKUPS  ==> RM OLDEST BACKUP DIR AND RE-CALC FOLDER COUNT
elif [ $nDir -eq $MAX_BACKUPS ]; then
    rm -rf $BACKUP_DIR"/backup.$MAX_BACKUPS"
    echo "nDir == MAX_BACKUPS: $nDir"
    nDir=$(find $BACKUP_DIR -maxdepth 1 -iname "backup*" -type d | wc -l)
    echo "Post: nDir = $nDir"

# CASE 4: nDir < MAX_BACKUPS but  nDir > 1 ==> FOR LOOP FROM nDir TO 1
elif [ $nDir -lt $MAX_BACKUPS ] && [ $nDir -gt 1 ]; then

     ## SUBTRACT 1 FOR "$DEST" FOLDER
     COUNTER=$((nDir-1))
     while [ $COUNTER -gt 0 ]; do
	 echo Moving $BACKUP_DIR"/backup.$COUNTER" to $BACKUP_DIR"/backup.$((COUNTER+1))"
	 mv $BACKUP_DIR"/backup.$COUNTER" $BACKUP_DIR"/backup.$((COUNTER+1))"
	 let COUNTER=COUNTER-1
     done

     cp -al $DEST $BACKUP_DIR"/backup.1"

else
    echo "else --------------------------------------------##"
fi

#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# HOME --------------------------------------------------------------------------
