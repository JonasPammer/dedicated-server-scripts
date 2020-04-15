#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized
source_utils "file"

declare -r SSHD_CONFIG_FILE="/etc/ssh/sshd_config"

#######################################
# Globals used:
#   SSHD_CONFIG_FILE  -  Path to the sshd_config-file of the system
# Returns & Echo's:
#   0 if "PermitRootLogin" value is "yes"
#######################################
is_permitrootlogin_enabled(){
  cat "${SSHD_CONFIG_FILE}" | grep "^PermitRootLogin yes" >/dev/null
  local -r exit_code=$?
  echo "${exit_code}"
  return ${exit_code}
}

#######################################
# Uncomments and sets SSHd's "PermitRootLogin"-Config-Value to the given value
# Globals used:
#   SSHD_CONFIG_FILE  -  Path to the sshd_config-file of the system
# Params:
#   1 - Either "yes" or "no"
#######################################
set_permitrootlogin_enabled(){
  if [[ $# -eq 0 ]]; then
    log_error "== set_permitrootlogin_enabled needs at least one argument! (either \"yes\" or \"no\")"
    return 1
  fi

  set +e
  log_info "== Uncommenting PermitRootLogin..."
  uncomment_lines_of_file "PermitRootLogin " "${SSHD_CONFIG_FILE}"

  log_info "== Setting PermitRootLogin to ${1}..."
  if [[ "${1}" = "yes" ]]; then
    sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' "${SSHD_CONFIG_FILE}"
  elif [[ "${1}" = "no" ]]; then
    sed -i 's/^PermitRootLogin no/PermitRootLogin yes/' "${SSHD_CONFIG_FILE}"
  fi

  log_info "== PermitRootLogin: $(is_permitrootlogin_enabled)"
  se -e
}

#######################################
# Uses `service` to restart ssh.
# Used to take affect of the changes made to the config.
#######################################
restart_ssh_service(){
  set -e
  service ssh restart
}