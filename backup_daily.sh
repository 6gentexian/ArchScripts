#!/bin/bash
#
#  script will provide daily back ups to a usb drive

#DATA="/home /root /usr/local/httpd"
SOURCE="/home/edward/tmp2/"
SOURCE_ALL="source_dirs_all.txt"
SOURCE_FILTERED="source_dirs_filtered.txt"

#DEST="/mnt/sdd1/BACKUP"
DEST="/home/edward/tmp/BACKUP/"
DEST_ALL="dest_dirs_all.txt"
DEST_FILTERED="dest_dirs_filtered.txt"

#CONFIG="/etc /var/lib /var/named"
#LIST="/tmp/backlist_$$.txt"


## MAKE SURE THAT THE DEST DRIVE IS MOUNTED
#if grep -c "$DEST" /proc/mounts; then 
#        echo "/mnt/sdd1 already mounted"
#else        
#        mount "$DEST"
#        echo "/mnt/sdd1 is now mounted"
#fi


## CREATE DESTINATION FOLDER ON USB DRIVE
if [ ! -d $DEST ]; then
  mkdir $DEST
fi
chmod 777 $DEST


## FIRST: 
##   OUTPUT SOURCE DIR STRUCTURE
##   -- GET *ALL* SOURCE
##   -- rm DIRS LIKE '/home/edward/R_LIBS' THAT ONLY CONTAIN NON-DATA FILES
##   -- rm ANY EMPTY DIRS

## PIPE RESULTS INTO "source_dirs_all.txt", etc
cd $DEST
find $DEST -type d > $DEST_ALL

#find /home/edward/ -type d                                          \
# ! -path /home/edward/Dropbox/.metadata\*                           \
# ! -path /home/edward/Dropbox/JAVA/workspaceJavaFD_5/.metadata\*    \
# ! -path /home/edward/Dropbox/JAVA/.metadata\*                      \
# ! -path /home/edward/Dropbox/.dropbox\*                            \
# ! -path /home/edward/Old_stuff\*                                   \
# ! -path /home/edward/.macromedia\*                                 \
# ! -path /home/edward/.wine\*                                       \
# ! -path /home/edward/.icedtea\*                                    \
# ! -path /home/edward/R_LIBS/2_15\*                                 \
# ! -path /home/edward/R_LIBS/3_0\*                                  \
# ! -path /home/edward/.local/share/Trash\*                          \ 
# ! -path /home/edward/BME/wiki/GDP/FRED2_txt_2\*                    \
# ! -path /home/edward/Documents/.metadata\*                         \
# ! -path /home/edward/HIMCO/GDP/FRED2_txt_2\*                       \
# ! -path /home/edward/Python/wxGTK-2.8.12\*                         \
# ! -path /home/edward/Python/wxPython-src-2.8.12.1\*                \
# ! -path /home/edward/Python/usr\*                                  \
# ! -path /home/edward/eclipse/features\*                            \
# ! -path /home/edward/workspace/.metadata\*                         \
# ! -path /home/edward/workspace/workspaceJavaFD_5/.metadata\*       \
# ! -path /home/edward/My_eBooks/Aptana_Studio_3\*                  \
# -not -empty > $SOURCE_ALL 

find $SOURCE -type d \
     -not -path /home/edward/tmp2/dir1 \
     -not -empty > $SOURCE_ALL
#     -not -path /home/edward/tmp2/backup_20130514 \

less ~/tmp/BACKUP/source_dirs_all.txt
less ~/tmp/BACKUP/dest_dirs_all.txt

## rm ANYH OLD COPIES OF THE FILTERED FILES
if [ -r $SOURCE_FILTERED -a -f $SOURCE_FILTERED ] ; then
  echo "removing old SOURCE_FILTERED"
  rm $SOURCE_FILTERED
else
  echo "OK, SOURCE_FILTERED file does not exist"
fi ;
if [ -r $DEST_FILTERED -a -f $DEST_FILTERED ] ; then
  echo "removing old DEST_FILTERED file"
  rm $DEST_FILTERED
else
  echo "OK, DEST_FILTERED file does not exist"
fi ;


## FILTER THE PARENT DIRS FROM EACH FILE
TMP=$DEST$SOURCE_ALL
while read line
  do
    echo ${line#$SOURCE} >> $SOURCE_FILTERED
  done < $TMP

TMP=$DEST$DEST_ALL
while read line
  do
    echo ${line#$DEST} >> $DEST_FILTERED
  done < $TMP

## rm ANY BLANK LINES
grep -v '^$' $SOURCE_FILTERED > output.txt
mv output.txt $SOURCE_FILTERED

grep -v '^$' $DEST_FILTERED > output.txt
mv output.txt $DEST_FILTERED

less ~/tmp/BACKUP/source_dirs_filtered.txt
less ~/tmp/BACKUP/dest_dirs_filtered.txt


## RUN DIFF ON DIR STRUCTURES
## -- rm EXTRA DEST DIRS
## -- mkdir ANY MISSING DIRS
sort $SOURCE_FILTERED -u -o $SOURCE_FILTERED
sort $DEST_FILTERED -u -o $DEST_FILTERED

comm -13 --check-order $SOURCE_FILTERED $DEST_FILTERED > rm_from_2.txt
comm -23 --check-order $SOURCE_FILTERED $DEST_FILTERED > add_to_2.txt

less ~/tmp/BACKUP/rm_from_2.txt
less ~/tmp/BACKUP/add_to_2.txt

cd $DEST
while read line
  do
    echo $line
    if [ -d $line ]; then
      rm -rf $line
    fi
  done < rm_from_2.txt
while read line
  do
    if [ ! -d $line ]; then
      mkdir $line
    fi
  done < add_to_2.txt

########################################################
## RE-RUN INITIAL DIR STRUCTURE AND DO FINAL COMPARE
cd $DEST
find $DEST -type d > $DEST_ALL

if [ -r $DEST_FILTERED -a -f $DEST_FILTERED ] ; then
  echo "Final Compare --removing initial DEST_FILTERED"
  rm $DEST_FILTERED
else
  echo "OK, DEST_FILTERED does not exist"
fi ;

TMP=$DEST$DEST_ALL
while read line
  do
    echo ${line#$DEST} >> $DEST_FILTERED
  done < $TMP

sort $DEST_FILTERED -u -o $DEST_FILTERED
## rm ANY BLANK LINES
grep -v '^$' $DEST_FILTERED > output.txt
mv output.txt $DEST_FILTERED


comm -13 $SOURCE_FILTERED $DEST_FILTERED > rm_from_2.txt
comm -23 $SOURCE_FILTERED $DEST_FILTERED > add_to_2.txt

grep -v '^$' rm_from_2.txt > output.txt
mv output.txt rm_from_2.txt
grep -v '^$' add_to_2.txt > output.txt
mv output.txt add_to_2.txt

if [[ -s add_to_2.txt ]] ; then
  echo "ERROR:: add_to_2.txt is NOT empty"
else
  echo "OK to delete add_to_2.txt"
  rm add_to_2.txt
fi ;
if [[ -s rm_from_2.txt ]] ; then
  echo "ERROR:: rm_from_2.txt is NOT empty"
else
  echo "OK to delete rm_from_2.txt"
  rm rm_from_2.txt
fi ;

less ~/tmp/BACKUP/source_dirs_filtered.txt
less ~/tmp/BACKUP/dest_dirs_filtered.txt


## Now rm all '.bz2' files from DEST



##############################################################
## loop thru SOURCE directory(s)
## - tar and zip files
## - mv *.tar.bzip2 to DEST directory

#paste $SOURCE_ALL $DEST_ALL | while read source dest;
#  do
#    cd $dest
#    rmcount=`ls -1 *.bz2 2>/dev/null | wc -l`
#    if [ $count != 0 ]; then
#      rm *.bz2
#    fi 
#    cd $source
#    nFiles=$(find . -maxdepth 1 -type f | wc -l)
#    if [ $nFiles -gt 0 ]; then
#      echo $source
#      echo $nFiles
#      find . -maxdepth 1 -type f -exec tar -cvjf $(date +%Y%m%d).tar.bz2 {} + # or \;
#      mv *.tar.bz2 $dest
#    fi
#  done





#if test "$1" = "Sun" ; then
        # weekly a full backup of all data and config. settings:
        #
#        tar cfz "/mnt/backup/data/data_full_$6-$2-$3.tgz" $DATA
#        rm -f /mnt/backup/data/data_diff*
        #
#        tar cfz "/mnt/backup/config/config_full_$6-$2-$3.tgz" $CONFIG
#        rm -f /mnt/backup/config/config_diff*
#else
        # incremental backup:
        #
#        find $DATA -depth -type f \( -ctime -1 -o -mtime -1 \) -print > $LIST
#        tar cfzT "/mnt/backup/data/data_diff_$6-$2-$3.tgz" "$LIST"
#        rm -f "$LIST"
        #
#        find $CONFIG -depth -type f  \( -ctime -1 -o -mtime -1 \) -print > $LIST
#        tar cfzT "/mnt/backup/config/config_diff_$6-$2-$3.tgz" "$LIST"
#        rm -f "$LIST"
#fi
#



#if grep -c "$DEST" /proc/mounts; then 
#    umount "$DEST"
#    echo "/mnt/sdd1 is now unmounted"
#else        
#    echo "/mnt/sdd1 already unmounted"
#fi


