#!/bin/bash
#
# This script gets called over-and-over again until the program has exited
# Presents the user a dialog-menu of available actions. It then calls the appropriate module found in the "/modules"-directory.
#
# @author PixelTutorials
#

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
      "Basic Secure (Automatic)" "Install/Enable UFW (Firewall) and Fail2Ban. Setup UFW with simple rules" \
      "Sudo-User Menu (Interactive)" "Check which user has sudo-priv. Add/Remove priviliges to/from user." \
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
  "Basic Secure"*)
    . "${SCRIPT_DIR}/modules/basic_secure.sh"
    call_module
    ;;
  "Sudo"*)
    . "${SCRIPT_DIR}/modules/manage_sudoers.sh"
    call_module
    ;;
esac