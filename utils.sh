#!/bin/bash
#
# Functions/Variables used in every script.
# Depends on variable "SCRIPT_DIR" to be set
#

if [[ -z "${SCRIPT_DIR}" ]]; then
  export SCRIPT_DIR="$(pwd)"
fi

# VARIABLES
#======================================
export LOG_FILES_DIR="${SCRIPT_DIR}/.logs/";
export LOG_LATEST="${LOG_FILES_DIR}latest.log.txt";
export TEMP_DIR="${SCRIPT_DIR}/.tmp/";

export SCRIPT_NAME="PixelTutorials Dedicated Server Scripts";


# FUNCTIONS
#======================================

#######################################
# Echo's:
#   The output of the used `date`-command
#######################################
get_formatted_log_date() {
  echo "$(date +'%Y-%m-%dT%H:%M:%S')"
}

#######################################
# Prepends date/time-information, echo's the resulting text to STDERR (>&2) and to our LOG_LATEST-File
# Arguments:
#   *   - Actual Text
#######################################
log_error() {
  local -r line="[$(get_formatted_log_date) - ERROR]: $*"
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
  local -r line="[$(get_formatted_log_date) - INFO]: $*"
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
  local -r line="[$(get_formatted_log_date) - DEBUG]: $*"
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
backup_log() {
  cp "${LOG_LATEST}" "${LOG_FILES_DIR}$(date +'%Y-%m-%dT%H-%M-%S').log.bak"
}

#######################################
# Makes the LOG_FILES_DIR-Folder and touches the LOG_LATEST-File
# Globals used:
#   LOG_LATEST        -  Path of the latest log
#   LOG_FILES_DIR  -  Path to the folder to store the dump/backup-file in
#######################################
init_log() {
  mkdir -p "${LOG_FILES_DIR}"#
  if [[ -f "${LOG_LATEST}" ]];
    then rm "${LOG_LATEST}"
  fi
  touch "${LOG_LATEST}"
}


#######################################
# Uses various flags and variables to make "apt install" do its thing without any user-interaction.
# (Assume yes, Force default configuration options, pretending to be in an noninteractive-environment)
#
# Parameters:
#   1 - Gets appended after "apt", aka. should be the action to perform (e.G: "install", "update")
#   2 - Gets appended to the end of the command, aka. should be the packages
#######################################
apt_without_interaction() {
if [[ ! -z "${1}" ]]; then
  /usr/bin/env DEBIAN_FRONTEND=noninteractive apt ${1} -y -o Dpkg::Options::="--force-confdef" ${2}
  return 0
fi
return 1
}