#!/bin/sh

# TODO: accept arg for container name
CONTAINER_TO_INSPECT="$1"

echo "###############################################################"
echo ""
echo "                Lokl Environment info"
echo ""
echo "        Used to show what a release version contains"
echo ""
echo "###############################################################"

# TODO: make POSIX friendly
# shellcheck disable=SC2039
read -r -d '' PRINT_INFO_SCRIPT <<'ENDSCRIPT'
  echo "" && \
  echo "### WordPress version:" && \
  echo "" && \
  wp core version && \
  echo "" && \
  echo "### MariaDB (MySQL) version:" && \
  echo "" && \
  mysql --version && \
  echo "" && \
  echo "### WordPress environment, plugins and DB credentials:" && \
  echo "" && \
  wp cli info && wp plugin list && wp config list | head -n 10 && \
  echo "" && \
  echo "### PHPMyAdmin version:" && \
  echo "" && \
  wget -q "localhost:$P/phpmyadmin" -O - | grep 'Version' && \
  echo "" && \
  echo "### Enabled PHP features:" && \
  echo "" && \
  php -i | grep enabled && \
  echo "" && \
  echo "### Installed Alpine packages:" && \
  echo "" && \
  apk info
  echo ""
ENDSCRIPT

# print OS, PHP and WordPress information
docker exec -it "$CONTAINER_TO_INSPECT" /bin/sh -c "$PRINT_INFO_SCRIPT"
