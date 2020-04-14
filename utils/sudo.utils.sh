#!/bin/bash
#
# @author PixelTutorials
#

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
  usermod -aG "sudo" "${1}"
}