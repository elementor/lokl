#!/bin/sh

cd /usr/html/ || exit 1

# backup DB to parent dir
mysqldump -u root -pbanana wordpress > "../$N_DATABASE_BACKUP.sql"
tar cfz "../$N_DATABASE_BACKUP.sql.tar.gz" "../$N_DATABASE_BACKUP.sql"
rm "../$N_DATABASE_BACKUP.sql"

# backup whole html dir

cd /usr/ || exit 1
tar cfz "/tmp/$N_SITE_BACKUP.tar.gz" html

rm "../$N_DATABASE_BACKUP.sql.tar.gz"
