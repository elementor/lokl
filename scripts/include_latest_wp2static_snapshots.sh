#!/bin/sh

# Script to build all latest snapshots of WP2Static core and add-ons
#   and include those in Lokl's default plugins to install and activate

# pseudo-code

# list of each WP2Static project's repos:
#   ie leonstafford/wp2static
#      leonstafford/wp2static-addon-s3
#      ...

# iterate each repo

# clone --depth=1

# cd into repo

# composer i

# composer test && composer coverage

# exit if non-zero

# rm ~/Downloads/wp2static-addon-s3.zip

# composer build wp2static-addon-s3 (generates ~/Downloads/wp2static-addon-s3.zip)

# cp installer to ./installers/default_plugins 

# adjust run script to use ./installers/default_plugins/activate vs install_only

# run script will install and activate all wp2static plugins (or die trying)

# commit message on success: "updated WP2Static core and add-on snapshots"
#  "add to commit details the repo name and ref hash"


