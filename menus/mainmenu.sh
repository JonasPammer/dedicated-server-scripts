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
      "exit" "." 2>${TEMP_DIR}/mainmenu.chosen
  CHOSEN_MENU=$(cat "${TEMP_DIR}/mainmenu.chosen")

done

# ${CHOSEN_MENU} has now been filled in
log_info "= Main-Menu Choice: ${CHOSEN_MENU}"
case $CHOSEN_MENU in
  "exit")
    log_info "== Exiting gracefully..."
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
esac