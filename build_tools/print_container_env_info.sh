#!/bin/sh

# TODO: accept arg for container name

echo "###############################################################"
echo ""
echo "                Lokl Environment info"
echo ""
echo "        Used to show what a release version contains"
echo ""
echo "###############################################################"


read -r -d '' PRINT_INFO_SCRIPT <<'ENDSCRIPT'
  wp cli info && wp plugin list && wp config list | head -n 10
ENDSCRIPT

echo $PRINT_INFO_SCRIPT

# print OS, PHP and WordPress information
docker exec -it new7testlocally /bin/sh -c "$PRINT_INFO_SCRIPT"
