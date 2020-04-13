#!/bin/bash

# import global utils
source "${SCRIPT_DIR}/utils.sh"
set -eo pipefail
check_is_utils_initialized

# clear last selection
read -p "Press Enter to continue..."
CHOSEN_MENU=""
# Loop until any selection has been made
while [[ -z "$CHOSEN_MENU" ]]; do

  dialog --backtitle "${SCRIPT_NAME}" --nocancel \
    --title "Main Menu" \
    --menu "" 0 0 0 \
      "Basic Secure" "Install/Enable UFW (Firewall) and Fail2Ban + Setup UFW with simple rules" \
      "Make sudo User (INTERACTIVE!)" "Check for existing sudo-users / Create sudo-user / Make user sudo'able" \
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
    . "${SCRIPT_DIR}/modules/basic_secure.sh"
    ;;
  "Make sudo User (INTERACTIVE!)")
    . "${SCRIPT_DIR}/modules/make_sudoer.sh"
    ;;
esac