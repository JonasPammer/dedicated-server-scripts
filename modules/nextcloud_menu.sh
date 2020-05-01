#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized

call_module(){
  set -e
  # clear last selection
  read -p "Press Enter to continue to nextcloud-menu..."
  CHOSEN_NEXTCLOUD_MENU=""
  # Loop until any selection has been made
  while [[ -z "${CHOSEN_NEXTCLOUD_MENU}" ]]; do

    menu_builder=()
    menu_builder+=("Install NextCloud 18.0.4 (Interactive)" "")
    menu_builder+=("exit" \
                   ".")

    dialog --backtitle "${SCRIPT_NAME}" --nocancel \
      --title "NextCloud Menu" \
      --menu "" 0 0 0 \
        "${menu_builder[@]}" \
      2>"${TEMP_DIR}/nextcloud_menu.chosen"
    CHOSEN_NEXTCLOUD_MENU=$(cat "${TEMP_DIR}/nextcloud_menu.chosen")
  done

  # ${CHOSEN_NEXTCLOUD_MENU} has now been filled in
  log_info "= NextCloud-Menu Choice: ${CHOSEN_NEXTCLOUD_MENU}"
  case ${CHOSEN_NEXTCLOUD_MENU} in
    "exit")
      end_gracefully
      ;;

    *"Install"*)
      . "${SCRIPT_DIR}/modules/nextcloud_install.sh"
      call_module
      ;;
  esac
}