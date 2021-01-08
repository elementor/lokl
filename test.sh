#!/bin/sh
#
# lokl: shell script checker
#
# License: The Unlicense, https://unlicense.org
#
# Usage: execute this script from the project root
#
#     $   sh tests.sh
#

# run ShellCheck to catch syntactical errors and promote best practice
find . -type f -not -path '*/\.git/*' -name '*.sh' \
  -exec shellcheck {} \;

# run ShellSpec unit/integration tests and generate coverage report
shellspec --kcov
