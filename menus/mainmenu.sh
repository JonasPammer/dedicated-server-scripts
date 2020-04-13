#!/bin/bash

# import global utils
source "${SCRIPT_DIR}/utils.sh"

# clear last selection
CHOSEN_MENU=""
# Loop until any selection has been made
while [[ -z "$CHOSEN_MENU" ]]; do

  dialog --backtitle "${SCRIPT_NAME}" --nocancel \
    --title "Main Menu" \
    --menu "" 0 0 0 \
      "Basic Secure" "Setup UFW (Firewall) and Fail2Ban" \
      "exit" "." 2>${TEMP_DIR}/mainmenu.chosen
  CHOSEN_MENU=$(cat "${TEMP_DIR}/mainmenu.chosen")

done

# ${CHOSEN_MENU} has now been filled in
log_info "= Main-Menu Choice: ${CHOSEN_MENU}"
case $CHOSEN_MENU in
  "exit")
    log_info "== Exiting gracefully..."
    backup_log
    exit 0
    ;;
  "Basic Secure")
    log_info "== Install UFW"
    apt_without_interaction "install" "ufw" | log_debug_output

    # See https://talk.lowendspirit.com/discussion/290/resolved-ufw
#    log_info "== Updating alternatives (Use iptables[6]-legacy)"
#    update-alternatives --set iptables /usr/sbin/iptables-legacy
#    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

    log_info "== Allowing Basic Ports (22, 80, 443, 10000)"
    ufw allow 22 # SSH (and therefore also SFTP)
    ufw allow 80 # HTTP
    ufw allow 443 # HTTPS
    ufw allow 10000 # Webmin

    log_info "== Set default 'outgoing'-rule to 'allow'"
    ufw default allow outgoing

    log_info "== Install Fail2Ban"
    apt_without_interaction "install" "fail2ban" | log_debug_output

    log_info "== Enable & Start Fail2Ban"
    systemctl enable fail2ban | log_debug_output
    systemctl start fail2ban | log_debug_output
    ;;
esac