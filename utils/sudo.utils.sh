#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized

#######################################
# Echo's:
#   Each system-user's name in a seperate line. Great for array-use.
#######################################
fetch_system_users(){
  echo "$(cut -d: -f1 /etc/passwd)"
}

#######################################
# Params:
#   1 - Username
# Return:
#   0 if the given user can execute the program "sudo", Otherwise 1.
#######################################
can_user_execute_sudo(){
  if sudo -l -U ${1} sudo; then
    return 0;
  else
    return 1;
  fi
}

#######################################
# Params:
#   1 - The name of the user to give sudo-privileges
#######################################
make_user_sudoer(){
  log_info "== Adding given user ${1} to group 'sudo'..."
  usermod -aG "sudo" "${1}" | log_debug_output
}

#######################################
# Params:
#   1 - The name of the user to take away sudo-privileges
#######################################
unmake_user_sudoer(){
  log_info "== Removing given user ${1} to group 'sudo'..."
  # See https://unix.stackexchange.com/questions/29570/how-do-i-remove-a-user-from-a-group#tab-top
  gpasswd -d "${1}" "sudo" | log_debug_output
}