#!/bin/sh

cd /usr/html/ || exit 1

# rm previous backups
rm -f "/tmp/LOKL_DATABASE_BACKUP.sql"
rm -f "/tmp/LOKL_DATABASE_BACKUP.sql.tar.gz"
rm -f "/tmp/LOKL_SITE_BACKUP.tar.gz" 

# dump DB to tmp dir
mysqldump -u root -pbanana wordpress > "/tmp/LOKL_DATABASE_BACKUP.sql"

# compress DB dump
tar cfz "/tmp/LOKL_DATABASE_BACKUP.sql.tar.gz" "/tmp/LOKL_DATABASE_BACKUP.sql"

# rm uncompressed DB dump
rm "/tmp/LOKL_DATABASE_BACKUP.sql"

cd /usr/ || exit 1

# generate archive of whole html dir and compresssed DB dump
tar cfz "/tmp/LOKL_SITE_BACKUP.tar.gz" html /tmp/LOKL_DATABASE_BACKUP.sql.tar.gz

