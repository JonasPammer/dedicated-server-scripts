#!/bin/bash
#
# @author PixelTutorials
#
# VARIABLES
#======================================
export LOG_FILES_DIR="${SCRIPT_DIR}/.logs/";
export LOG_LATEST="${LOG_FILES_DIR}latest.log";

# FUNCTIONS
#======================================

#######################################
# Echo's:
#   The output of the used `date`-command
#######################################
log_get_formatted_log_date() {
  echo "$(date +'%Y-%m-%dT%H:%M:%S')"
}

#######################################
# Prepends date/time-information, echo's the resulting text to STDERR (>&2) and to our LOG_LATEST-File
# Arguments:
#   *   - Actual Text
#######################################
log_error() {
  local -r line="[$(log_get_formatted_log_date) - ERROR]: $*"
  echo "${line}" >>"${LOG_LATEST}"
  echo -e "\e[41m${line}\e[49m" >&2
}

#######################################
# Prepends date/time-information, echo's the resulting text to STDOUT (>&1) and to our LOG_LATEST-File
# Globals used:
#   LOG_LATEST  -  Path of the file to append to
# Arguments:
#   *   - Actual Text
#######################################
log_info() {
  local -r line="[$(log_get_formatted_log_date) - INFO]: $*"
  echo "${line}" >>"${LOG_LATEST}"
  if [[ -x "$(command -v /usr/games/lolcat)" ]]; then
    echo "${line}" | /usr/games/lolcat -a -d 6
  else
    echo "${line}"
  fi
}

#######################################
# Prepends date/time-information and echo's the resulting text to our LOG_LATEST-File
# Globals used:
#   LOG_LATEST  -  Path of the file to append to
# Arguments:
#   *   - Actual Text
#######################################
log_debug() {
  local -r line="[$(log_get_formatted_log_date) - DEBUG]: $*"
  echo "${line}" >>"${LOG_LATEST}"
  echo "${line}"
}

#######################################
# Loops through each given line and calls log_debug for each line
# Globals used:
#   LOG_LATEST  -  Path of the file to append to
# Arguments:
#   (Used as a pipe)
#######################################
log_debug_output() {
  while read -r line_in; do
    log_debug "${line_in}"
  done
}

#######################################
# Copies the current LOG_LATEST-File to a new file inside the LOG_FILES_DIR-folder
# The name of the new file contains the current date and time information and ends with `log.bak`
# Globals used:
#   LOG_LATEST        -  Path of the latest log
#   LOG_FILES_DIR  -  Path to the folder to store the dump/backup-file in
#######################################
log_do_backup() {
  local -r generated_backup_log_file=${LOG_FILES_DIR}$(date +'%Y-%m-%dT%H-%M-%S').log.bak
  log_info "Backing up ${LOG_LATEST} to ${generated_backup_log_file}..."
  cp "${LOG_LATEST}" "${generated_backup_log_file}"
}


#######################################
# Makes the LOG_FILES_DIR-Folder and touches the LOG_LATEST-File
# Globals used:
#   LOG_LATEST        -  Path of the latest log
#   LOG_FILES_DIR  -  Path to the folder to store the dump/backup-file in
#######################################
log_do_init() {
  mkdir -p "${LOG_FILES_DIR}"#
  if [[ -f "${LOG_LATEST}" ]];
    then rm "${LOG_LATEST}"
  fi
  touch "${LOG_LATEST}"
}