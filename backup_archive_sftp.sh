#!/bin/bash
#
# script will provide cron with all info needed for complete system back up
################################################################################

# ARCHIVE ----------------------------------------------------------------------
MAX_BACKUPS=31
SOURCE="/archive"
BACKUP_DIR="/backup/archive"
LOG="--log-file=/home/edward/.local/logs/backup-archive.log"
DEST=$BACKUP_DIR"/backup.0"

# REM: From rsync point of view, exclude path is always relative
EX_DIRS="--exclude=tmp/"
EX_DIRS+=" --exclude=lost+found/"
EX_DIRS+=" --exclude=OLD_STUFF/"
EX_DIRS+=" --exclude=PICTURES/"


cd $SOURCE

nDir=$(find $BACKUP_DIR -maxdepth 1 -iname "backup*" -type d | wc -l)
echo "Initial:  $nDir"



# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f ~/.local/logs/backup-archive.log ]; then
    mkdir -p ~/.local/logs
    touch ~/.local/logs/backup-archive.log
    echo "Archive BU log created"
else
    #BU_NAME="backup-archive.$(date +"%Y.%m.%d.%H.%M")"
    #mv ~/.local/logs/backup-archive.log ~/.local/logs/"$BU_NAME".log
    #touch ~/.local/logs/backup-archive.log
    echo "*NEW* archive BU log created"
fi


# CASE 1: nDir == 0  ==> CREATE DESTINATION FOLDER
if [ $nDir -eq 0 ]; then
     mkdir -p $DEST
     echo "No BU dir - so "$DEST" was created"
     #echo "$(ls -al $BACKUP_DIR)"
# CASE 2: nDir == 1  ==> COPY DESTINATION FOLDER, DO INCREMENTAL BACKUP
elif [ $nDir -eq 1 ]; then
    cp -al $DEST $BACKUP_DIR"/backup.1"
    echo "ONE BU Directory Found"
    # echo "$(ls -al $BACKUP_DIR)"
# CASE 3: nDir == MAX_BACKUPS  ==> RM OLDEST BACKUP DIR AND RE-CALC FOLDER COUNT
elif [ $nDir -eq $MAX_BACKUPS ]; then
    rm -rf $BACKUP_DIR"/backup.$MAX_BACKUPS"
    echo "nDir == MAX_BACKUPS: $nDir"
    nDir=$(find $BACKUP_DIR -maxdepth 1 -iname "backup*" -type d | wc -l)
    echo "Post: nDir = $nDir"
    #echo "$(ls -al $BACKUP_DIR)"
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
     #echo "$(ls -al $BACKUP_DIR)"
else
    echo "else --------------------------------------------##"
    #echo "$(ls -al $BACKUP_DIR)"
fi


echo
echo "SOURCE:  $SOURCE"
echo "EX:  $EX_DIRS"
echo "DEST: $DEST"
echo


#rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
# ARCHIVE ----------------------------------------------------------------------



echo
echo
echo



# ARCHIVE PICTURES ------------------------------------------------------------
MAX_BACKUPS=31
SOURCE="/archive/PICTURES"
BACKUP_DIR="/backup/home/PICTURES"
LOG="--log-file=/home/edward/.local/logs/backup-pictures.log"
DEST=$BACKUP_DIR"/backup.0"


cd $SOURCE

nDir=$(find $BACKUP_DIR -maxdepth 1 -iname "backup*" -type d | wc -l)
echo "Initial:  $nDir"



# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f ~/.local/logs/backup-pictures.log ]; then
    mkdir -p ~/.local/logs
    touch ~/.local/logs/backup-pictures.log
    echo "pictures BU log created"
else
    echo "*NEW* pictures BU log created"
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


#rsync -naPhsAX --stats $LOG  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG  $SOURCE  $DEST
# ARCHIVE PICTURES ------------------------------------------------------------



echo
echo
echo



# ARCHIVE OLD_STUFF ------------------------------------------------------------
MAX_BACKUPS=31
SOURCE="/archive/OLD_STUFF"
BACKUP_DIR="/backup/home/OLD_STUFF"
LOG="--log-file=/home/edward/.local/logs/backup-old-stuff.log"
DEST=$BACKUP_DIR"/backup.0"

# REM: From rsync point of view, exclude path is always relative
EX_DIRS=" --exclude=EBG/edward_larry/edward/.cache"
EX_DIRS+=" --exclude=EBG/edward_larry/edward/.mozilla/firefox/hjg1akph.default/cache2"
EX_DIRS+=" --exclude=EBG/edward_larry/edward/LAPTOP_WIN/Local/Mozilla/Firefox/Profiles"

EX_DIRS+=" --exclude=EBG/edward_larry/edward/LAPTOP_WIN/Local/Temp"
EX_DIRS+=" --exclude=EBG/edward_larry/edward/.meteor"
EX_DIRS+=" --exclude=EBG/edward_larry/edward/R"

EX_DIRS+=" --exclude=EBG/edward_larry/edward/LAPTOP_WIN/Local/Microsoft/Windows/Temporary*"
EX_DIRS+=" --exclude=EBG/edward_larry/edward/LAPTOP_WIN/Local/Opera/Opera/cache"

EX_DIRS+=" --exclude=EBG/edward_moe/edward/.cache"
EX_DIRS+=" --exclude=EBG/edward_moe/edward/.mozilla/firefox/gnfgdfwb.default/Cache"
EX_DIRS+=" --exclude=EBG/edward_moe/edward/.wine"

EX_DIRS+=" --exclude=EBG/LAPTOP-WIN/Praxeum/Local/Temp"
EX_DIRS+=" --exclude=EBG/LAPTOP-WIN/Praxeum/Local/Mozilla/Firefox/Profiles/60x3fb9o.default/Cache"
EX_DIRS+=" --exclude=EBG/LAPTOP-WIN/Praxeum/Local/Opera/Opera/cache"

EX_DIRS+=" --exclude=EBG/Old_stuff/R-2.7.1"
EX_DIRS+=" --exclude=EBG/Old_stuff/R-2.8.1"
EX_DIRS+=" --exclude=EBG/Old_stuff/R-2.9.0"

EX_DIRS+=" --exclude=EBG/BME/wiki/GDP/FRED2_txt_2"
EX_DIRS+=" --exclude=EBG/DEV"
EX_DIRS+=" --exclude=EBG/HIMCO/GDP/FRED2_txt_2"


cd $SOURCE

nDir=$(find $BACKUP_DIR -maxdepth 1 -iname "backup*" -type d | wc -l)
echo "Initial:  $nDir"



# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f ~/.local/logs/backup-old-stuff.log ]; then
    mkdir -p ~/.local/logs
    touch ~/.local/logs/backup-old-stuff.log
    echo "old-stuff BU log created"
else
    echo "*NEW* old-stuff BU log created"
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
# ARCHIVE OLD_STUFF ------------------------------------------------------------



echo
echo
echo



# SFTP -------------------------------------------------------------------------
MAX_BACKUPS=31
SOURCE="/sftp"
BACKUP_DIR="/backup/sftp"
LOG="--log-file=/home/edward/.local/logs/backup-sftp.log"
DEST=$BACKUP_DIR"/backup.0"

## REM: From rsync point of view, exclude path is always relative
EX_DIRS="--exclude=lost+found/"

cd $SOURCE

nDir=$(find $BACKUP_DIR -maxdepth 1 -iname "backup*" -type d | wc -l)
echo "Initial:  $nDir"



# CREATE LOG FILE IF NEEDED  --------------------------------------------------#
if [ ! -f ~/.local/logs/backup-sftp.log ]; then
    mkdir -p ~/.local/logs
    touch ~/.local/logs/backup-sftp.log
    echo "SFTP BU log created"
else
    echo "*NEW* sftp BU log created"
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


# #rsync -naPhsAX --stats $LOG $EX_DIRS  $SOURCE  $DEST
rsync -qaPhsAX --stats $LOG $EX_DIRS $SOURCE  $DEST
