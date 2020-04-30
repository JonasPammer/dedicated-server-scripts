#!/bin/bash
#
# Functions/Variables used in EVERY script.
# For more specific-utils, see "/utils".
#
# @author PixelTutorials
#

# Check if running as superuser (root)
if [[ "$EUID" -ne 0 ]]; then
#  log_error "Please run the script as root."
  echo "PLEASE RUN THE SCRIPT AS SUPER-USER (Using 'sudo ./start')."
#  log_do_backup
  exit 1
fi

if [[ -z "${SCRIPT_DIR}" ]]; then
  export SCRIPT_DIR="$(pwd)"
fi

# GLOBAL VARIABLES
#======================================
export SCRIPT_NAME="PixelTutorials Dedicated Server Scripts";
export TEMP_DIR="${SCRIPT_DIR}/.tmp/";

# GLOBAL FUNCTIONS
#======================================

#######################################
# Parameters:
#   1 - The simple name of the util inside the "/utils"-directory to source. (aka. the filename without ".utils.sh")
#######################################
source_utils() {
  source "${SCRIPT_DIR}/utils/${1}.utils.sh"
}

#######################################
# This command just calls the `dialog`-command with all given parameters attached to it,
# but always sets at least to --backtitle refer to the SCRIPT_NAME.
#
# Parameters:
#   * - Gets appended at the end of the `dialog`-comment
#######################################
dialog_pixeltutorials() {
  dialog --backtitle "${SCRIPT_NAME}" ${*}
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
  return "${PIPESTATUS[0]}" # TODO does this work properly?
fi
return 1
}


check_is_utils_initialized() {
  if [[ -d "${SCRIPT_DIR}" ]] && [[ -d "${LOG_FILES_DIR}" ]] && [[ -d "${TEMP_DIR}" ]]; then
    echo ""
  else
    log_error "You can't just run any script file! You need to run the file 'start', located in the roots of the script-directory!"
    end_gracefully
  fi
}

#######################################
# Makes one last log that states that the program exited gracefully.
# It then Backs up the latest-log-file using log_do_backup and exit's the program with code 0
#######################################
end_gracefully() {
  log_info "Exiting gracefully! Backing up latest log and exiting with code 0..."
  log_do_backup
  exit 0
}

#######################################
# Makes one last log that states that the program exited with the cause that the program has trapped a SIGINT-signal.
# It then Backs up the latest-log-file using log_do_backup and exit's the program with code 0
#######################################
end_sigint() {
  log_error "Exiting - SIGINT received/trapped! Backing up latest log and exiting with code 0..."
  log_do_backup
  exit 0
}





# Always include logging-utils (needed everywhere!)
source_utils "logging"