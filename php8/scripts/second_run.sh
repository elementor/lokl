#!/bin/sh

# Second-run through of our provisiniong process
#
# This runs the first time a user is launching a container from Lokl base image
#
# Our `docker run` command will have replaced our env vars for container's name
# and port, so we'll want to  

#
# This replaces the original image's CMD script, so needs to end with the same
# process, which is to run nginx
#

echo 'Running provisioning script (second run)'

# sitename for subdomain available as $N, port as $P 
name="$N"
port="$P"

# update port in nginx.conf (replace whole matching line, keep comment)
sed -i "/MAIN_NGINX_LISTEN_LINE/c\listen    $port; # MAIN_NGINX_LISTEN_LINE" /etc/nginx/nginx.conf


chown -R nginx:www-data /usr/html

# start php-fpm
mkdir -p /usr/logs/php-fpm
# allow to run as root user
php-fpm8 -R


# TODO: mysql should already be running? else, at least it's already setup
# and we can re-use start n wait commands from first run script

# capture old url for rewriting
OLD_SITE_URL="$(wp option get siteurl)" # something like http://localhost:3456

# remove protocol for better search-replace
OLD_SITE_HOST_PORT="${OLD_SITE_URL##*/}" # localhost:3456

# Change site name, url, home and rewrite URLs
wp option update home "http://localhost:$port"
wp option update siteurl "http://localhost:$port"
wp option update blogname "$name: Lokl WordPress"

# rewrite any old URL references
wp search-replace "$OLD_SITE_HOST_PORT" "localhost:$port" --skip-columns=guid

# start nginx
mkdir -p /usr/logs/nginx
mkdir -p /tmp/nginx

# mark as third run
touch /firstrun

# TODO: does nginx need to be reload here?
# nginx
nginx -s reload -c /etc/nginx/nginx.conf
