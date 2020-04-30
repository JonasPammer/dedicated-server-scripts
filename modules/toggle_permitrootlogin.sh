#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized
source_utils "permitrootlogin"
source_utils "sudo"

call_module(){
  case $1 in
    "enable"|"on"|"yes")
      ssh_set_permitrootlogin_enabled "yes"
      ;;
    "disable"|"off"|"no")
      log_info "= Checking if script got run by the ACTUAL 'root' itself..."

      # If no SUDO_-Variables got injected, or if the injected SUDO_USER equals "root", abort.
      if sudo_is_script_executing_using_sudo || [[ "${SUDO_USER}" = "root" ]]; then
        log_error "== Please log out of root and log into an other sudo-user! Aborting..."
        return 1
      fi

      ssh_set_permitrootlogin_enabled "no"
      ;;
  esac

  # Apply config-changes
  ssh_restart_service
}