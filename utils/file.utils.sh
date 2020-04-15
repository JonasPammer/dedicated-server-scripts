#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized

#######################################
#
# Parameters:
#   1 - Path to file
#######################################
backup_file_if_not_already_backed_up(){
  # Check if file exists , read permission is granted and size is greater than zero
  if [[ -r "$1" ]] && [[ -s "$1" ]]; then
    # Check if Backup hasn't already been created
    if [[ ! -r "$1.bak" ]]; then
      # Do Backup
      log_info "== Backing up file $1"
      cp "$1" "$1.bak" | log_debug_output
    fi
  fi
}

#######################################
# Runs `sed` to edit the given file ($2) in-place.
#
# The sed-script searches for all lines starting with the given expression ($1).
# It then puts an "#" in front of the line
#
# Parameters:
#   1 - e.G: "2,4" to affect lines 2 and 4, "hello" to affect the line that starts with "hello"
#   2 - Path to File to affect
#######################################
comment_lines_of_file(){
  # Source: https://unix.stackexchange.com/a/128595
  sed -i "$1"' s/^/#/' "$2"
}

#######################################
# Runs `sed` to edit the given file ($2) in-place.
#
# The sed-script searches for all lines whom match the given expression ($1) AND contain an "#" in front of the line.
# It then replaces the line with a version that doesn't start with "#".
#
# Parameters:
#   1 - e.G: "2,4" to affect lines 2 and 4, "hello" to affect the line that starts with "#hello"
#   2 - Path to File to affect
#######################################
uncomment_lines_of_file(){
  sed -i "$1"' s/^#//' "$2"
}