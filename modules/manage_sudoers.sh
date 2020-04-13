#!/bin/bash
source "${SCRIPT_DIR}/utils.sh"
set -eo pipefail
check_is_utils_initialized

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

menu_builder="\
EXIT (BACK_TO_MAINMENU) \
CREATE_USER . \
--- --- "

fetched_system_users=$(cut -d: -f1 /etc/passwd)
sorted_system_users=$(echo "${fetched_system_users}" | sort)
for username in ${sorted_system_users}; do
  if can_user_execute_sudo "${username}"; then
    menu_builder="${menu_builder}${username} (can_execute_sudo) "
  else
    menu_builder="${menu_builder}${username} . "
  fi
done

dialog --backtitle "${SCRIPT_NAME}" \
    --title "" \
    --menu \
      "Please choose the User to remove/add the group 'sudo' from/to:" \
      0 0 0 \
      ${menu_builder} \
      2>"${TEMP_DIR}/sudo_user-chosen.choice"
chosen_entry=$(cat "${TEMP_DIR}/sudo_user-chosen.choice")
echo "${chosen_entry}"

chosen_username=""

case ${chosen_entry} in
  "EXIT"|"---")
    log_info "== User chose to EXIT..."
    return
    ;;
  "CREATE"*)
    log_info "== User chose to CREATE a new user. Prompting for username..."
    dialog --backtitle "${SCRIPT_NAME}" \
      --title "Please provide a name for the new User" \
      --inputbox "" 0 0 "furrynator" \
      2>"${TEMP_DIR}/sudo_user-provided_name.choice"

    name_of_user_to_create=$(cat "${TEMP_DIR}/sudo_user-provided_name.choice")

    ## Check if given username already exists
    log_debug "== Checking if given user '${name_of_user_to_create}' already exists..."
    if getent passwd "$name_of_user_to_create" >/dev/null; then
      log_info "=== Given User '${name_of_user_to_create}' does exist. No need to create... "
    else
      log_info "=== Given User '${name_of_user_to_create}' does not exist. Running 'adduser ${name_of_user_to_create}' to create user interactively..."
      adduser "${name_of_user_to_create}"
    fi

    chosen_username="${name_of_user_to_create}"
    ;;
  *)
    # User chose valid username from list.
    chosen_username="${chosen_entry}"


    ;;
esac

if [[ ! "${chosen_username}" ]]; then
  log_error "== chosen_username is empty?!"
  end_gracefully
fi

if can_user_execute_sudo "${chosen_username}"; then
  log_debug "=== Asking for additional user-confirmation to REMOVE the 'sudo'-group from user '${chosen_username}'..."
  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  dialog --backtitle "${SCRIPT_NAME}" \
    --title "CONFIRM REMOVAL OF GROUP 'sudo'" \
    --yesno "REMOVE user '${chosen_username}' from group 'sudo'?" 0 0
  dialog_response=$?
  set -e # Revert to normally-wanted behaviour (Exit immediately if something goes wrong)

  if [[ "${dialog_response}" -ne 0 ]]; then # no or ESC
    log_debug "=== Returning back to main-menu..."
    return
  fi

  log_info "== Removing given user ${chosen_username} from group 'sudo'..."
  # See https://unix.stackexchange.com/questions/29570/how-do-i-remove-a-user-from-a-group#tab-top
  gpasswd -d "${chosen_username}" "sudo"
else
  log_debug "=== Asking for additional user-confirmation to APPEND the 'sudo'-group to user '${chosen_username}'..."

  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  dialog --backtitle "${SCRIPT_NAME}" \
    --title "CONFIRM APPENDING OF GROUP 'sudo'" \
    --yesno "APPEND group 'sudo' to user '${chosen_username}'?" 0 0
  dialog_response=$?
  set -e # Revert to normally-wanted behaviour (Exit immediately if something goes wrong)

  if [[ "${dialog_response}" -ne 0 ]]; then # no or ESC
    log_debug "=== Returning back to main-menu..."
    return
  fi

  log_info "== Adding given user ${chosen_username} to group 'sudo'..."
  usermod -aG "sudo" "${chosen_username}"
fi
