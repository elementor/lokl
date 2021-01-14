#!/bin/sh

# Script to build all latest snapshots of WP2Static core and add-ons
#   and include those in Lokl's default plugins to install and activate

# list of each WP2Static project's repos:
WP2STATIC_REPOS="leonstafford/wp2static
leonstafford/wp2static-addon-s3
leonstafford/wp2static-addon-zip
leonstafford/wp2static-addon-netlify
leonstafford/wp2static-addon-cloudflare-workers
"

# TODO: guzzle it for php8 compat
# leonstafford/wp2static-addon-advanced-crawling

# cleanup existing temp repos
rm -Rf /tmp/wp2staticloklbuildcache
mkdir -p /tmp/wp2staticloklbuildcache

# rm existing versioned WP2Static plugins from Lokl image builder

# PHP8
cd "$HOME/lokl/php8/installers/default_plugins/" || exit 1
rm -f wp2static*.zip

# PHP7
cd "$HOME/lokl/php7/installers/default_plugins/" || exit 1
rm -f wp2static*.zip

cd /tmp/wp2staticloklbuildcache || exit 1

# iterate each repo
for REPO in $WP2STATIC_REPOS
do
  DIRNAME="$(echo "$REPO" | cut -d\/ -f2)"
  echo ""
  echo "##############################################"
  echo ""
  echo "Processing $DIRNAME..."
  echo ""
  echo "##############################################"
  echo ""

  cd /tmp/wp2staticloklbuildcache || exit 1

  # clone --depth=1 default branch
  git clone --quiet --depth=1 "git@github.com:$REPO.git"

  # cd into repo
  cd "$DIRNAME" || exit 1

  # composer test && composer coverage
  # exit if non-zero
  composer i -q || exit 1
  composer test || exit 1
  composer coverage || echo "No coverage command for this repo"
  echo ""

  # rm ~/Downloads/wp2static-addon-s3.zip
  rm -f "$HOME/Downloads/$DIRNAME.zip"

  # composer build wp2static-addon-s3 (generates ~/Downloads/wp2static-addon-s3.zip)
  composer build "$DIRNAME" || exit 1

  # cp installer to ./installers/default_plugins

  # PHP 8
  cp "$HOME/Downloads/$DIRNAME.zip" "$HOME/lokl/php8/installers/default_plugins/"

  # PHP 7
  cp "$HOME/Downloads/$DIRNAME.zip" "$HOME/lokl/php7/installers/default_plugins/"

  # adjust run script to use ./installers/default_plugins/activate vs install_only

  # run script will install and activate all wp2static plugins (or die trying)

  # commit message on success: "updated WP2Static core and add-on snapshots"
  #  "add to commit details the repo name and ref hash"


done

