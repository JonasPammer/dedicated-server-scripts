#!/bin/bash

# import global utils
source "${SCRIPT_DIR}/utils.sh"


# clear last selection
read -p "Press Enter to continue..."
CHOSEN_MENU=""
# Loop until any selection has been made
while [[ -z "$CHOSEN_MENU" ]]; do

  dialog --backtitle "${SCRIPT_NAME}" --nocancel \
    --title "Main Menu" \
    --menu "" 0 0 0 \
      "Basic Secure" "Install/Enable UFW (Firewall) and Fail2Ban + Setup UFW with simple rules" \
      "Make sudo User (INTERACTIVE!)" " Check for existing sudo-user / Create sudo-user / Make user sudo'able" \
      "exit" "." \
    2>"${TEMP_DIR}/mainmenu.chosen"
  CHOSEN_MENU=$(cat "${TEMP_DIR}/mainmenu.chosen")

done

# ${CHOSEN_MENU} has now been filled in
log_info "= Main-Menu Choice: ${CHOSEN_MENU}"
case $CHOSEN_MENU in
  "exit")
    end_gracefully
    ;;
  "Basic Secure")
    log_info "== Install UFW"
    apt_get_without_interaction "install" "ufw" | log_debug_output

    log_info "== Allowing Basic Ports (22, 80, 443, 10000)"
    ufw allow 22 | log_debug_output # SSH (and therefore also SFTP)
    ufw allow 80 | log_debug_output # HTTP
    ufw allow 443 | log_debug_output # HTTPS
    ufw allow 10000 | log_debug_output # Webmin

    log_info "== Set default 'outgoing'-rule to 'allow'"
    ufw default allow outgoing | log_debug_output

    log_info "== Install Fail2Ban"
    apt_get_without_interaction "install" "fail2ban" | log_debug_output

    log_info "== Enable & Start Fail2Ban"
    systemctl enable fail2ban | log_debug_output
    systemctl start fail2ban | log_debug_output
    ;;
  "Make sudo User (INTERACTIVE!)")
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

      dialog --backtitle "${SCRIPT_NAME}" \
        --title "Do you still want to create a new sudo-user?" \
        --yesno "There are already users will the group of 'sudo'! (${detected_sudo_users[*]})" 0 0 \
        2>"${TEMP_DIR}/sudo_user-create_additional.choice"

      response=$(cat "${TEMP_DIR}/sudo_user-create_additional.choice")
      case ${response} in
         0) # yes
          log_debug "=== User chose to create sudo-user even though there are already users with the 'sudo'-group - Continuing...! (${detected_sudo_users[*]})"
          ;;
         *) # no or ESC
          log_debug "=== Returning back to main-menu..."
          return
          ;;
      esac
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
    ;;
esac