#!/usr/bin/env bash
#
# @author (Most parts copied from my version of installimage, which was in-turn originally written by Hetzner)
#
set -eo pipefail
check_is_utils_initialized

#######################################
# Echo's:
#   A random, 16-character-long string consisting of lower/upper-case characters and digits
#######################################
generate_password() {
  local -r length="${1:-16}"
  local password=''
  until echo "$password" | grep '[[:lower:]]' | grep '[[:upper:]]' | grep -q '[[:digit:]]'; do
    password="$(tr -cd '[:alnum:][:digit:]' < /dev/urandom | head -c "$length")"
  done
  echo "$password"
}

#######################################
# Echo's:
#   A random, 48-character-long string consisting of all Alphanumeric Characters and Digits
#######################################
generate_random_string() {
  local -r length="${1:-48}"
  tr -cd '[:alnum:][:digit:]' < /dev/urandom | head -c "$length"
}