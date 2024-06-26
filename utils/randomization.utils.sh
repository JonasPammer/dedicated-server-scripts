#!/usr/bin/env bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized

#######################################
# Params:
#   1 - Length of the password. Defaults to 16 if no parameter has been given.
# Echo's:
#   A random, 16-character-long string consisting of lower/upper-case characters and digits
#######################################
rand_generate_password_without_symbols() {
  length=${1:-16}
  echo "$(pwgen -s ${length} 1)"
}

rand_generate_password_with_symbols() {
  length=${1:-16}
  echo "$(pwgen -ys ${length} 1)"
}

#######################################
# Echo's:
#   A random, 48-character-long string consisting of all Alphanumeric Characters and Digits
#######################################
rand_generate_long_string() {
  local -r length="${1:-48}"
  tr -cd '[:alnum:][:digit:]' < /dev/urandom | head -c "$length"
}