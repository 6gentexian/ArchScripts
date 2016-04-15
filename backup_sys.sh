#!/bin/bash
#
# script will provide cron with all info needed for complete system back up
################################################################################
MAX_BACKUPS=31

# var     ----------------------------------------------------------------------
SOURCE="/var"
BACKUP_DIR="/backup/sys/var"
LOG="--log-file=/home/edward/.local/logs/backup-var.log"
DEST=$BACKUP_DIR"/backup.0"

# REM: From rsync point of view, exclude path is always relative
EX_DIRS="--exclude=tmp"
EX_DIRS+=" --exclude=cache"
EX_DIRS+=" --exclude=games"
EX_DIRS+=" --exclude=abs"
# REM: Filter out symlinks too
EX_DIRS+=" --exclude=lock"
EX_DIRS+=" --exclude=mail"
EX_DIRS+=" --exclude=run"
EX_DIRS+=" --exclude=lib/texmf/fonts/map"

cd $SOURCE
nDir=$(find $BACKUP_DIR -maxdepth 1 -iname "backup*" -type d | wc -l)
echo "Initial:  $nDir"

echo
echo
echo
echo "#####################################################################"
echo "                              /var                                   "
echo "#####################################################################"
echo
echo
echo

# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f ~/.local/logs/backup-var.log ]; then
    mkdir -p ~/.local/logs
    touch ~/.local/logs/backup-var.log
    echo "var BU log created"
else
    echo "*NEW* var BU log created"
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


echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# var     ----------------------------------------------------------------------



echo
echo
echo
echo "#####################################################################"
echo "                              /usr/local                             "
echo "#####################################################################"
echo
echo
echo

# /usr/local -------------------------------------------------------------------
SOURCE="/usr/local"
BACKUP_DIR="/backup/sys/local"
DEST=$BACKUP_DIR"/backup.0"
LOG="--log-file=/home/edward/.local/logs/backup-local.log"

cd $SOURCE

# REM: From rsync point of view, exclude path is always relative
EX_DIRS="--exclude=games/"
EX_DIRS+=" --exclude=lost+found/"


# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f ~/.local/logs/backup-local.log ]; then
    mkdir -p ~/.local/logs
    touch ~/.local/logs/backup-local.log
    echo "local BU log created"
else
    echo "*NEW* local BU log created"
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


echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# /usr/local -------------------------------------------------------------------


echo
echo
echo
echo "#####################################################################"
echo "                              /etc                                   "
echo "#####################################################################"
echo
echo
echo

# /etc       -------------------------------------------------------------------
SOURCE="/etc"
BACKUP_DIR="/backup/sys/etc"
DEST=$BACKUP_DIR"/backup.0"
LOG="--log-file=/home/edward/.local/logs/backup-etc.log"

cd $SOURCE

# REM: From rsync point of view, exclude path is always relative
EX_DIRS="sudoers.d/"
EX_DIRS+="tmpfiles.d/"
EX_DIRS+="ssl/"
EX_DIRS+="ca-certificates/"
EX_DIRS+="systemd/system/"
EX_DIRS+="fonts/conf.d/"

# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f ~/.local/logs/backup-etc.log ]; then
    mkdir -p ~/.local/logs
    touch ~/.local/logs/backup-etc.log
    echo "etc BU log created"
else
    echo "*NEW* etc BU log created"
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


echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# /etc       -------------------------------------------------------------------


echo
echo
echo
echo "#####################################################################"
echo "                              /boot                                  "
echo "#####################################################################"
echo
echo
echo

# /boot      -------------------------------------------------------------------
SOURCE="/boot"
BACKUP_DIR="/backup/sys/boot"
DEST=$BACKUP_DIR"/backup.0"
LOG="--log-file=/home/edward/.local/logs/backup-boot.log"

cd $SOURCE
# REM: From rsync point of view, exclude path is always relative
EX_DIRS="--exclude=lost+found"


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


echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# /boot      -------------------------------------------------------------------
