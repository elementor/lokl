#!/bin/sh

for filename in /installers/default_plugins/*.zip; do
	unzip "$filename" -d /usr/html/wp-content/plugins/
done
