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
export LOG_LATEST="${LOG_FILES_DIR}latest.log";
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
# Return:
#   0 if at least the first parameter was given
#######################################
apt_get_without_interaction() {
if [[ ! -z "${1}" ]]; then
  /usr/bin/env DEBIAN_FRONTEND=noninteractive apt-get ${1} -y -o Dpkg::Options::="--force-confdef" ${2}
  return 0
fi
return 1
}


check_is_utils_initialized() {
  if [[ -d "${SCRIPT_DIR}" ]] && [[ -d "${LOG_FILES_DIR}" ]] && [[ -d "${TEMP_DIR}" ]]; then
    return 0
  fi
  log_error "You can't just run any script file! You need to run the file 'start', located in the roots of the script-directory!"
  end_gracefully
}

#######################################
# Makes one last log that states that the program exited gracefully.
# It then Backs up the latest-log-file using backup_log and exit's the program with code 0
#######################################
end_gracefully() {
log_info "Exiting gracefully! Backing up latest log and exiting with code 0..."
backup_log
exit 0
}

#######################################
# Makes one last log that states that the program exited with the cause that the program has trapped a SIGINT-signal.
# It then Backs up the latest-log-file using backup_log and exit's the program with code 0
#######################################
end_sigint() {
log_error "Exiting - SIGINT received/trapped! Backing up latest log and exiting with code 0..."
backup_log
exit 0
}