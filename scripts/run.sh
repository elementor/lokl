#!/bin/sh

echo 'running script'

[ -f /run-pre.sh ] && /run-pre.sh

if [ ! -d /usr/html ] ; then
  echo "[i] Creating directories..."
  mkdir -p /usr/html
  echo "[i] Fixing permissions..."
  chown -R nginx:nginx /usr/html
else
  echo "[i] Fixing permissions..."
  chown -R nginx:nginx /usr/html
fi

chown -R nginx:www-data /usr/html

# start php-fpm
mkdir -p /usr/logs/php-fpm
php-fpm7


# start mysql and send to background
exec /usr/bin/mysqld --user=root &

# wait for mysql to be ready
while ! mysqladmin ping -h localhost --silent; do
    echo 'waiting for mysql to be available...'
    sleep 1
done

# add root@localhost user
/usr/bin/mysql < /mysql_user.sql

cd /usr/html
# setup WP
sudo -u nginx wp core config --dbhost=localhost --dbname=wordpress --dbuser=root --dbpass=banana
rm wp-config-sample.php

sudo -u nginx wp core install --url=http://localhost:4444 --title='Welcome to Lokl' --admin_user=admin --admin_password=admin --admin_email=me@example.com

# start nginx
mkdir -p /usr/logs/nginx
mkdir -p /tmp/nginx
chown nginx /tmp/nginx
nginx
