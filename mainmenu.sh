#!/bin/bash
#
# This script gets called over-and-over again until the program has exited
# Presents the user a dialog-menu of available actions. It then calls the appropriate module found in the "/modules"-directory.
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized
source_utils "permitrootlogin"

set +e # Do NOT quit if the following EXIT-CODE is other than 0
if [[ ! -z "$FORCED_NEXT_MENU" ]]; then
  CHOSEN_MENU="$FORCED_NEXT_MENU"
  unset FORCED_NEXT_MENU
  set -e
else
  set -e
  # clear last selection
  read -p "Press Enter to continue to main-menu..."
  CHOSEN_MENU=""
  # Loop until any selection has been made
  while [[ -z "$CHOSEN_MENU" ]]; do

    menu_builder=()
    menu_builder+=("Sudo-User Menu (Interactive)" \
                  "Check which user has sudo-priv. Add/Remove priviliges to/from user.")

    set +e # Do NOT quit if the following EXIT-CODE is other than 0
    if ssh_is_permitrootlogin_enabled; then
      menu_builder+=("Disable PermitRootLogin (Automatic)" \
                     ".")
    else
      menu_builder+=("Enable PermitRootLogin (Automatic)" \
                     ".")
    fi
    set -e

    if hash ufw 2>/dev/null; then
      menu_builder+=("(Re-Run) Basic Secure (Automatic)")
    else
      menu_builder+=("Basic Secure (Automatic)")
    fi
    menu_builder+=("Install/Enable UFW (Firewall) and Fail2Ban. Setup UFW with simple rules.")

    if [[ -d "/usr/share/phpmyadmin/" ]]; then
      menu_builder+=("(Re-Run) Install & Configure LAMPP (Semi-Automatic)")
    else
      menu_builder+=("Install & Configure LAMPP (Semi-Automatic)")
    fi
    menu_builder+=("Install Apache2, MariaDB, PHP and PHPMyAdmin + Configure/Setup PHPMyAdmin")

    menu_builder+=("MediaWiki-Menu" \
                   "")

    menu_builder+=("NextCloud-Menu" \
                   "")

    menu_builder+=("Install Multicraft (Manual or Load from Config)" \
                   "")

    menu_builder+=("exit" \
                   ".")

    dialog --backtitle "${SCRIPT_NAME}" --nocancel \
      --title "Main Menu" \
      --menu "" 0 0 0 \
        "${menu_builder[@]}" \
      2>"${TEMP_DIR}/mainmenu.chosen"
    CHOSEN_MENU=$(cat "${TEMP_DIR}/mainmenu.chosen")

  done
fi

# ${CHOSEN_MENU} has now been filled in
log_info "= Main-Menu Choice: ${CHOSEN_MENU}"
case $CHOSEN_MENU in
  "exit")
    end_gracefully
    ;;

  *"Basic Secure"*|"basic_secure")
    . "${SCRIPT_DIR}/modules/basic_secure.sh"
    call_module
    ;;

  "Sudo"*|"manage_sudoers")
    . "${SCRIPT_DIR}/modules/manage_sudoers.sh"
    call_module
    ;;

  "Disable PermitRootLogin"*|"disable_permitrootlogin")
    . "${SCRIPT_DIR}/modules/toggle_permitrootlogin.sh"
    call_module "off"
    ;;
  "Enable PermitRootLogin"*|"enable_permitrootlogin")
    . "${SCRIPT_DIR}/modules/toggle_permitrootlogin.sh"
    call_module "on"
    ;;

  "(Re-Run) Install & Configure LAMPP"*)
    # Ask if he really wants to install the complete LAMPP-Stack again
    set +e # Do NOT quit if the following EXIT-CODE is other than 0
    dialog --backtitle "${SCRIPT_NAME}" --title "'/usr/share/phpmyadmin/' already exists" \
      --yesno "Do you really want to start the installation and configuration-procedure again?" 0 0
    dialog_response=$?
    set -e

    if [[ "${dialog_response}" -ne 0 ]]; then # no or ESC
      log_debug "=== Returning back to main-menu..."
      return
    fi

    . "${SCRIPT_DIR}/modules/install_lampp.sh"
    call_module
    ;;

  "Install & Configure LAMPP"*|"install_configure_lampp")
    . "${SCRIPT_DIR}/modules/install_lampp.sh"
    call_module
    ;;

  *"MediaWiki"*)
    . "${SCRIPT_DIR}/modules/mediawiki_menu.sh"
    call_module
    ;;

  *"NextCloud"*)
    . "${SCRIPT_DIR}/modules/nextcloud_menu.sh"
    call_module
    ;;

  *"Multicraft"*)
    . "${SCRIPT_DIR}/modules/install_multicraft.sh"
    call_module
    ;;
esac