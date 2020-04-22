#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized

#######################################
# If this script runs as sudo, it executes the given command using a "reverse sudo" (using sudo and providing the variable SUDO_USER as it's "user" (-u) argument)
# Otherwise, it gets sudo'ed using the user "root".
#
# Params:
#   * - Command to evaluate
#######################################
execute_as_sudoing_user(){
  if is_script_executing_under_sudo; then
    sudo -u "${SUDO_USER}" $*
  else
    sudo -u "root" $*
  fi
}

#######################################
# See https://serverfault.com/a/568628 - when running using sudo-command, 4 new environment-variables get injected into the current context.
# At the start of the script we make sure that the script got run with superuser privileges. (= either sudo or as just when normally logged in as "root")
# If one of these variables do exist, it means that this script is being run using sudo.
#
# Returns:
#   0 if variable SUDO_USER has been set.
#######################################
is_script_executing_under_sudo(){
  if [[ -z "${SUDO_USER}" ]]; then
    return 0
  else
    return 1
  fi
}

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