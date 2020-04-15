#!/bin/bash
#
# Presents the user a dialog-menu of all system-users. Each entry also informs if the associative-user has sudo-privileges.
# After selecting a specific system-user, the user must confirm the APPENDING/REMOVAL of the "sudo"-group.
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized
source_utils "sudo"

CHOSEN_USERNAME=""

ask_and_remove_chosen_user_from_sudo(){
  set -e
  log_debug "=== Asking for additional user-confirmation to REMOVE the 'sudo'-group from user '${CHOSEN_USERNAME}'..."

  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  dialog --backtitle "${SCRIPT_NAME}" --title "CONFIRM REMOVAL OF GROUP 'sudo'" \
    --yesno "REMOVE user '${CHOSEN_USERNAME}' from group 'sudo'?" 0 0
  local -r dialog_response=$?
  set -e # Revert to normally-wanted behaviour (Exit immediately if something goes wrong)

  if [[ "${dialog_response}" -ne 0 ]]; then # no or ESC
    log_debug "=== Returning back to main-menu..."
    return
  fi

  log_info "== Removing given user ${CHOSEN_USERNAME} from group 'sudo'..."
  # See https://unix.stackexchange.com/questions/29570/how-do-i-remove-a-user-from-a-group#tab-top
  gpasswd -d "${CHOSEN_USERNAME}" "sudo"
}

ask_and_add_chosen_user_to_sudo(){
  set -e
  log_debug "=== Asking for additional user-confirmation to APPEND the 'sudo'-group to user '${CHOSEN_USERNAME}'..."

  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  dialog --backtitle "${SCRIPT_NAME}" --title "CONFIRM APPENDING OF GROUP 'sudo'" \
    --yesno "APPEND group 'sudo' to user '${CHOSEN_USERNAME}'?" 0 0
  local -r dialog_response=$?
  set -e # Revert to normally-wanted behaviour (Exit immediately if something goes wrong)

  if [[ "${dialog_response}" -ne 0 ]]; then # no or ESC
    log_debug "=== Returning back to main-menu..."
    return
  fi

  make_user_sudoer "${CHOSEN_USERNAME}"
}

call_module(){
  local menu_builder="\
  EXIT (BACK_TO_MAINMENU) \
  CREATE_USER . \
  --- --- "

  local sorted_system_users=$(echo "$(fetch_system_users)" | sort)
  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  for username in ${sorted_system_users}; do
    if can_user_execute_sudo "${username}"; then
      menu_builder="${menu_builder}${username} (can_execute_sudo) "
    else
      menu_builder="${menu_builder}${username} . "
    fi
  done
  set -e

  dialog --backtitle "${SCRIPT_NAME}" --title "" \
      --menu \
        "Please choose the User to remove/add the group 'sudo' from/to:" \
        0 0 0 \
        ${menu_builder} \
        2>"${TEMP_DIR}/sudo_user-chosen.choice"
  local -r chosen_entry=$(cat "${TEMP_DIR}/sudo_user-chosen.choice")

  CHOSEN_USERNAME=""

  case ${chosen_entry} in
    "EXIT"|"---")
      log_info "== User chose to EXIT..."
      return
      ;;
    "CREATE"*)
      log_info "== User chose to CREATE a new user. Prompting for username..."
      dialog --backtitle "${SCRIPT_NAME}" --title "Please provide a name for the new User" \
        --inputbox "" 0 0 "furrynator" \
        2>"${TEMP_DIR}/sudo_user-provided_name.choice"

      local -r name_of_user_to_create=$(cat "${TEMP_DIR}/sudo_user-provided_name.choice")

      ## Check if given username already exists
      log_debug "== Checking if given user '${name_of_user_to_create}' already exists..."
      if getent passwd "$name_of_user_to_create" >/dev/null; then
        log_info "=== Given User '${name_of_user_to_create}' does exist. No need to create... "
      else
        log_info "=== Given User '${name_of_user_to_create}' does not exist. Running 'adduser ${name_of_user_to_create}' to create user interactively..."
        adduser "${name_of_user_to_create}"
      fi

      CHOSEN_USERNAME="${name_of_user_to_create}"
      ;;
    *)
      # User chose valid username from list.
      CHOSEN_USERNAME="${chosen_entry}"
      ;;
  esac

  if [[ ! "${CHOSEN_USERNAME}" ]]; then
    log_error "== chosen_username is empty?!"
    end_gracefully
  fi

  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  if can_user_execute_sudo "${CHOSEN_USERNAME}"; then
    ask_and_remove_chosen_user_from_sudo
  else
    ask_and_add_chosen_user_to_sudo
  fi
  set -e
}