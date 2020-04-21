#!/usr/bin/env bash
#
# @author (Most parts copied from my version of installimage, which was in-turn originally written by Hetzner)
#
set -eo pipefail
check_is_utils_initialized

#######################################
# Params:
#   1 - Length of the password. Defaults to 16 if no parameter has been given.
# Echo's:
#   A random, 16-character-long string consisting of lower/upper-case characters and digits
#######################################
generate_password() {
  length=$1
  if [[ -z "$length" ]]; then
    length=16
  fi
  echo "$(pwgen -ys ${length} 1)"
}

#######################################
# Echo's:
#   A random, 48-character-long string consisting of all Alphanumeric Characters and Digits
#######################################
generate_random_string() {
  local -r length="${1:-48}"
  tr -cd '[:alnum:][:digit:]' < /dev/urandom | head -c "$length"
}