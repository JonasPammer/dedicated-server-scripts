#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized

#######################################
# It copies the given file "$1" to "$1.bak", but only if it doesn't already exist and the given file can be read and isn't empty
# If the given file exists, read permissions are granted and it's size is greather than 0,
# AND if there's not already a file with the name of "$1.bak", it copies the given file ($1) in archive-mode (-a) to "$1.bak".
#
# Parameters:
#   1 - Path to file
#######################################
backup_file_if_not_already_backed_up(){
  # Check if file exists , read permission is granted and size is greater than zero
  if [[ -r "$1" ]] && [[ -s "$1" ]]; then
    # Check if Backup-File hasn't already been created
    if [[ ! -r "$1.bak" ]]; then
      # Do Backup
      log_info "== Backing up file $1"
      cp -a "$1" "$1.bak" | log_debug_output
    fi
  fi
}

#######################################
# Runs `sed` to edit the given file ($2) in-place.
#
# The sed-script searches for all lines starting (^) with the given expression ($1).
# It then puts an "#" in front of that line(s).
#
# Parameters:
#   1 - e.G: "hello" to affect the line that starts with "hello"
#   2 - Path to File to affect
#######################################
comment_lines_of_file(){
  # Source: https://unix.stackexchange.com/a/128595
  sed -i "$1"' s/^/#/' "$2"
}

#######################################
# Runs `sed` to edit the given file ($2) in-place.
#
# The sed-script searches for all lines that match the given expression ($1) AND contain an "#" in front of the line (^).
# It then replaces the line with a version that doesn't start with "#".
#
# Parameters:
#   1 - e.G: "hello" to affect the line that starts with "#hello"
#   2 - Path to File to affect
#######################################
uncomment_lines_of_file(){
  sed -i "/^#$1"' /s/^#//' "$2"
}