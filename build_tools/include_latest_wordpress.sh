#!/bin/sh

# Script to replace Lokl's WP version with latest

# rm existing versioned WP2Static plugins from Lokl image builder

# PHP8
cd "$HOME/lokl/php8/installers" || exit 1
rm -f wordpress-*.zip

# PHP7
cd "$HOME/lokl/php7/installers" || exit 1
rm -f wordpress-*.zip

cd /tmp || exit

# rm and download latest WP

rm -f wordpress-latest.zip
curl "https://wordpress.org/latest.zip" -o wordpress-latest.zip

cp wordpress-latest.zip "$HOME/lokl/php8/installers/"
cp wordpress-latest.zip "$HOME/lokl/php7/installers/"
