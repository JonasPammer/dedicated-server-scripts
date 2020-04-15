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
      # See https://serverfault.com/a/568628 - when running using sudo-command, 4 new environment-variables get injected into the current context.
      # At the start of the script we check if the script got run with superuser privileges. (= either sudo or as just when normally logged in as "root")
      # If no SUDO_-Variables got injected, or if the injected SUDO_USER equals "root", abort.
      if [[ -z "${SUDO_USER}" ]] || [[ "${SUDO_USER}" = "root" ]]; then
        log_error "Please log out of root and log into an other sudo-user! Aborting..."
        return 1
      fi

      set_permitrootlogin_enabled "no"
      ;;
  esac

  # Apply config-changes
  restart_ssh_service
}