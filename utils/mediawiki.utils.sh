#!/bin/bash
#
# @author PixelTutorials
# Using snippets from
# https://github.com/samwilson/MediaWiki_Backup/blob/master/backup.sh,
# https://gist.github.com/pklaus/737577 and
# https://www.mediawiki.org/wiki/Manual:Backing_up_a_wiki/de
#
# Note: "MW[B][R]_" is an abbreviation of "MediaWiki[Backup][Restore]_".
# If a variable gets used in both cases it should have both "B" and "R". Otherwise only the one its being used in.
#
set -eo pipefail
check_is_utils_initialized

MW_DEFAULT_INSTALL_DIR="/var/lib/mediawiki"

# Folder where all backups created by this script get stored in
MWBR_PARENT_FOLDER="${SCRIPT_DIR}/MWBACKUPS/"
# User-chosen path to mediawiki-instance to backup from/restore to
MWBR_INSTALL_DIR=""

## See mwbr_fetch_localsettings_vars for the following 6 variables:
MWBR_INSTALL_LOCALSETTINGS_PATH=""
MWBR_DB_HOST=""
MWBR_DB_NAME=""
MWBR_DB_USER=""
MWBR_DB_PASS=""
MWBR_DB_CHARSET="binary"

#######################################
# Parse required values out of MWBR_INSTALL_DIR's LocalSetttings.php
#######################################
mwbr_fetch_localsettings_vars() {
  MWBR_INSTALL_LOCALSETTINGS_PATH="${MWBR_INSTALL_DIR}/LocalSettings.php"
  log_info "= Get Database-Settings from LocalSettings.php-File '${MWBR_INSTALL_LOCALSETTINGS_PATH}'."

  if [[ ! -e "$MWBR_INSTALL_LOCALSETTINGS_PATH" ]];then
      log_error "== LocalSettings-File '$MWBR_INSTALL_LOCALSETTINGS_PATH' not found. Aborting.."
      return 1
  fi
  log_info "== Reading settings from '$MWBR_INSTALL_LOCALSETTINGS_PATH'..."
  MWBR_DB_HOST=$(grep '^\$wgDBserver' "$MWBR_INSTALL_LOCALSETTINGS_PATH" | cut -d\" -f2)
  MWBR_DB_NAME=$(grep '^\$wgDBname' "$MWBR_INSTALL_LOCALSETTINGS_PATH"  | cut -d\" -f2)
  MWBR_DB_USER=$(grep '^\$wgDBuser' "$MWBR_INSTALL_LOCALSETTINGS_PATH"  | cut -d\" -f2)
  MWBR_DB_PASS=$(grep '^\$wgDBpassword' "$MWBR_INSTALL_LOCALSETTINGS_PATH"  | cut -d\" -f2)
  log_info "=== Going to log into MySQL as user ${MWBR_DB_USER} to host ${MWBR_DB_HOST} to backup database ${MWBR_DB_NAME}"

  # Try to extract default character set from LocalSettings.php but default to binary
  DBTableOptions=$(grep '$wgDBTableOptions' "$MWBR_INSTALL_LOCALSETTINGS_PATH")
  MWBR_DB_CHARSET=$(echo ${DBTableOptions} | sed -E 's/.*CHARSET=([^"]*).*/\1/')
  if [[ -z ${MWBR_DB_CHARSET} ]]; then
      MWBR_DB_CHARSET="binary"
  fi

  log_info "=== Character set in use: $MWBR_DB_CHARSET."
}


#######################################
# Add $wgReadOnly to LocalSettings.php
# Kudos to http://www.mediawiki.org/wiki/User:Megam0rf/WikiBackup
#
# PARAMS:
#   1 - Either "ON" or "OFF"
#######################################
mwbr_toggle_read_only() {
  local -r msg="\$wgReadOnly = 'Backup in progress.';"
  log_info "= Toggle wgReadOnly ${1}"

  # Don't do anything if we can't write to LocalSettings.php
  if [[ ! -w "$MWBR_INSTALL_LOCALSETTINGS_PATH" ]]; then
      log_error "== Cannot control read-only mode. Aborting..."
      return 1
  fi

  # Verify if it is already read only
  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  grep "$msg" "$MWBR_INSTALL_LOCALSETTINGS_PATH" > /dev/null
  local -r is_msg_present_in_file=$?

  if [[ $1 == "ON" ]]; then
    if [[ ${is_msg_present_in_file} -ne 0 ]]; then
      log_info "== Entering read-only mode..."

      grep "?>" "$MWBR_INSTALL_LOCALSETTINGS_PATH" > /dev/null

      if [[ $? -eq 0 ]]; then
        sed -i "s/?>/\n$msg/ig" "$MWBR_INSTALL_LOCALSETTINGS_PATH"
      else
        echo "$msg" >> "$MWBR_INSTALL_LOCALSETTINGS_PATH"
      fi
    else
      log_info "== Already in read-only mode! Doing nothing."
    fi
  elif [[ $1 == "OFF" ]]; then
    # Remove read-only message
    if [[ ${is_msg_present_in_file} -eq 0 ]]; then
      log_info "== Returning to write mode..."
      sed -i "s/$msg//ig" "$MWBR_INSTALL_LOCALSETTINGS_PATH"
    else
      log_info "== Already in write mode! Doing nothing."
    fi
  fi

  set -e
}

