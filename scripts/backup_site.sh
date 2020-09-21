#!/bin/sh

cd /usr/html/ || exit 1

# rm previous backups
rm -f "/usr/LOKL_DATABASE_BACKUP.sql"
rm -f "/tmp/LOKL_SITE_BACKUP.tar.gz" 

# dump DB to tmp dir
mysqldump -u root -pbanana wordpress > "/usr/LOKL_DATABASE_BACKUP.sql"

cd /usr/ || exit 1

echo "generating backup for site named $N"

# generate archive of whole html dir and compresssed DB dump
tar cfz "/tmp/${N}_SITE_BACKUP.tar.gz" html LOKL_DATABASE_BACKUP.sql

ls /tmp

