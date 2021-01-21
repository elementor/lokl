#!/bin/sh

if [ -f /second_run ]
then
  sh /second_run.sh
elif [ -f /third_run ]
then
  echo 'Running provisioning script (third, n+ run)'
  # just launch daemon, don't change anything else
  nginx
else
  echo 'Running provisioning script (first run)'

  # sitename for subdomain available as $N, port as $P 
  name="$N"
  port="$P"

  # use public DNS to workaround sporadic Docker issues
  echo 'nameserver 8.8.4.4' > /etc/resolv.conf

  # set port in nginx
  sed -i "s/NGINX_LISTEN_PORT/$port/g" /etc/nginx/nginx.conf


  # TODO: if expected envs aren's set, show default nginx page with warning to try again

  [ -f /run-pre.sh ] && /run-pre.sh

  if [ ! -d /usr/html ] ; then
    echo "[i] Creating directories..."
    mkdir -p /usr/html
    echo "[i] Fixing permissions..."
    chown -R root:root /usr/html
  else
    echo "[i] Fixing permissions..."
    chown -R root:root /usr/html
  fi

  chown -R root:root /usr/html

  # start php-fpm
  mkdir -p /usr/logs/php-fpm
  # allow to run as root user
  php-fpm7 -R


  # start mysql and send to background
  exec /usr/bin/mysqld --user=root &

  # wait for mysql to be ready
  while ! mysqladmin ping -h localhost --silent; do
      echo 'waiting for mysql to be available...'
      sleep 1
  done

  # add root@localhost user
  /usr/bin/mysql < /mysql_user.sql

  # setup WP
  cd /usr/html || exit

  wp core config --dbhost=localhost --dbname=wordpress --dbuser=root --dbpass=banana
  rm wp-config-sample.php

  wp core install --url="http://localhost:$port" --title="$name: Lokl WordPress" --admin_user=admin --admin_password=admin --admin_email=me@example.com

  wp rewrite structure '/%postname%/'
  wp option update blogdescription "Your fast, secure local WP environment"
  wp post update 1 --post_content="Use this site as your starting point or import content from an existing site. <a href='/wp-admin'>View Dashboard</a>"
  wp post update 1 --post_title="Getting started"

  # delete useless plugins
  wp plugin delete hello
  wp plugin delete akismet

  # activate default plugins
  wp plugin activate static-html-output
  wp plugin activate simplerstatic
  wp plugin activate wp2static
  wp plugin activate wp2static-addon-zip
  wp plugin activate wp2static-addon-s3
  wp plugin activate wp2static-addon-netlify
  # wp plugin activate wp2static-addon-advanced-crawler
  # wp plugin activate wp2static-addon-cloudflare-workers

  # mark this as first run
  touch /second_run

  # start nginx
  mkdir -p /usr/logs/nginx
  mkdir -p /tmp/nginx
  chown root /tmp/nginx
  nginx
fi

