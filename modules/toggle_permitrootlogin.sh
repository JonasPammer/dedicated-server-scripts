#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized
source_utils "permitrootlogin"

call_module(){
  case $1 in
    "enable"|"on"|"yes")
      set_permitrootlogin_enabled "yes"
      ;;
    "disable"|"off"|"no")
      log_info "= Checking if script got run by the ACTUAL 'root' itself..."
      if [[ "${USER}" = "root" ]]; then
        log_error "Please log out of root and log into an other sudo-user! Aborting..."
        return 1
      fi

      set_permitrootlogin_enabled "no"
      ;;
  esac

  # Apply config-changes
  restart_ssh_service
}