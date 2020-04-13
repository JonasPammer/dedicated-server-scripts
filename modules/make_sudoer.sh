#!/bin/bash
source "${SCRIPT_DIR}/utils.sh"
set -eo pipefail
check_is_utils_initialized

#
# An other solution would also be to loop over every user and check if they have rights to run "sudo" with:
#   $(sudo -l -U USERNAME sudo) (--> Prints nothing if USER can NOT run the command, otherwise the path to the given executable)
# But because I plan on only using the first method (Creating one user and add it to the group "sudo"), I use this way:
#
log_info "== Checking for users in group 'sudo'..."
detected_sudo_users=()

# From https://www.ostechnix.com/find-sudo-users-linux-system/
fetched_users_in_sudo_group=$(getent group sudo | cut -d: -f4)
if [[ "${fetched_users_in_sudo_group}" ]]; then
  # From: https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash#tab-top
  detected_sudo_users=$(echo "${fetched_users_in_sudo_group}" | tr "," " ")
fi

if [[ ${#detected_sudo_users[@]} -ne 0 ]]; then
  log_error "== There are already users will the group of 'sudo'! (${detected_sudo_users[*]}) (${fetched_users_in_sudo_group})"

  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  dialog --backtitle "${SCRIPT_NAME}" \
    --title "" \
    --yesno "There are already users with the group of 'sudo'! (${detected_sudo_users[*]}) \n \n Do you still want to create/make a sudo-user?" 0 0
  dialog_response=$?
  set -e # Revert to normally-wanted behaviour (Exit immediately if something goes wrong)

  if [[ "${dialog_response}" -ne 0 ]]; then # no or ESC
    log_debug "=== Returning back to main-menu..."
    return
  fi
  log_debug "=== User chose to create sudo-user even though there are already users with the 'sudo'-group - Continuing...! (${detected_sudo_users[*]})"
else
  log_info "== No user with group of 'sudo' found!"
fi


# Either there is no user that is a part of the group "sudo", or the user explicitly chose to add another one:
## Ask for name
log_info "== Asking user to provide a username..."
dialog --backtitle "${SCRIPT_NAME}" \
  --title "Please provide a name for the new User" \
  --inputbox "" 0 0 "furrynator" \
  2>"${TEMP_DIR}/sudo_user-provided_name.choice"

chosen_username=$(cat "${TEMP_DIR}/sudo_user-provided_name.choice")
log_debug "== Checking if given user '${chosen_username}' already exists..."
## Check if given username already exists
if getent passwd "$chosen_username" >/dev/null; then
  log_info "=== Given User '${chosen_username}' does exist. "
else
  log_info "=== Given User '${chosen_username}' does not exist. Running 'adduser ${chosen_username}' interactively..."
  adduser "${chosen_username}"
fi

log_info "== Adding given user ${chosen_username} to group 'sudo'..."
usermod -aG "sudo" "${chosen_username}"