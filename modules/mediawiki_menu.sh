#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized
source_utils "mediawiki"

call_module(){
  set -e
  # clear last selection
  read -p "Press Enter to continue to mediawiki-menu..."
  CHOSEN_MEDIAWIKI_MENU=""
  # Loop until any selection has been made
  while [[ -z "${CHOSEN_MEDIAWIKI_MENU}" ]]; do

    menu_builder=()
    menu_builder+=("Install MediaWiki 1.34.1 (Interactive)" "")
    menu_builder+=("Backup Mediawiki-Instance (Interactive)" "")
    menu_builder+=("Restore Mediawiki-Instance (Interactive)" "")
    menu_builder+=("exit" \
                   ".")

    dialog --backtitle "${SCRIPT_NAME}" --nocancel \
      --title "MediaWiki Menu" \
      --menu "" 0 0 0 \
        "${menu_builder[@]}" \
      2>"${TEMP_DIR}/mediawikimenu.chosen"
    CHOSEN_MEDIAWIKI_MENU=$(cat "${TEMP_DIR}/mediawikimenu.chosen")
  done

  # ${CHOSEN_MEDIAWIKI_MENU} has now been filled in
  log_info "= MediaWiki-Menu Choice: ${CHOSEN_MEDIAWIKI_MENU}"
  case ${CHOSEN_MEDIAWIKI_MENU} in
    "exit")
      end_gracefully
      ;;

    *"Install"*)
      . "${SCRIPT_DIR}/modules/mediawiki_install.sh"
      call_module
      ;;

    "Backup"*)
      . "${SCRIPT_DIR}/modules/mediawiki_backup.sh"
      call_module
      ;;
    "Restore"*)
      . "${SCRIPT_DIR}/modules/mediawiki_restore.sh"
      call_module
      ;;
  esac
}