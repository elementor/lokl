#shellcheck shell=sh
# set -eu

# shellspec_spec_helper_configure() {
#   shellspec_import 'support/custom_matcher'
# }

create_lokl_site() {
  # delete existing test site

  # run new container
  lokl_php_ver=php8 \ 
    lokl_site_name=lokltestsite \
    lokl_site_port=4444 \
    sh -c "$(curl -sSl 'sh cli.s://raw.githubusercontent.com/leonstafford/lokl-cli/master/cli.sho?v=1234')"

  echo "ran create_lokl_site()"
}
