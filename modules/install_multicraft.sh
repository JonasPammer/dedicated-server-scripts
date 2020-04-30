#!/bin/bash
#
# @author PixelTutorials
# Procedures originally from xhost.ch GmbH's installation-script, see http://www.multicraft.org/download/linux64
# - Adapted to fit my script-setup
#
set -eo pipefail
check_is_utils_initialized
source_utils "multicraft"
source_utils "mysql"

INSTALL_RESOURCES_DIR="${SCRIPT_DIR}/res/multicraft/"
CFG_FILE="${INSTALL_RESOURCES_DIR}setup.config"
INSTALL_RESOURCES="bin/ jar/ downloader/ launcher/ scripts/ ssl/ templates/ eula.txt multicraft.conf.dist default_server.conf.dist server_configs.conf.dist"


# Check if all resources exist for later-on copying
01_check_resources(){
  log_info "= 01 Check if all installation-resources exist. (${INSTALL_RESOURCES})"
  for res in ${INSTALL_RESOURCES}; do
      if [[ ! -e "${INSTALL_RESOURCES_DIR}${res}" ]]; then
          log_error "Can't find '${INSTALL_RESOURCES_DIR}${res}'! Aborting..."
          mc_end_gracefully
      fi
  done
}

# Check for existing installation-script config (Bash-File with )
02_ask_load_existing_installation_script_config(){
  log_info "= 02 Check for existing config file at '${CFG_FILE}'... "
  if [[ -e "${CFG_FILE}" ]] ; then
    mc_ask "LOAD_CFG" "y" \
      "Found '${CFG_FILE}'. Source/Load settings from this file? [\$def]/n" \
      "-"

    if [[ "${LOAD_CFG}" = "y" ]]; then
      log_debug "== source'ing '${CFG_FILE}'... "
      source "${CFG_FILE}"
      log_debug "=== Done. "
    fi
  else
      log_info "== None found! Continuing... "
  fi
}

# Collect basic information
03_ask_basic_information(){
  log_info "= 03 Collect basic user information "
  mc_ask "MC_MULTIUSER" "y" \
   "Run each Minecraft server under its own user? (Multicraft will create system users): [\$def]/n" \
   "Create system user for each Minecraft server: \$var"

  if [[ "${USER}" = "root" ]]; then
      def="multicraft"
  else
      def="${USER}"
  fi
  mc_ask "MC_USER" "$def" \
    "Run Multicraft under this user: [\$def]" \
    "Multicraft will run as \$var"
  if [[ "`cat /etc/passwd | awk -F: '{ print $1 }' | grep ${MC_USER}`" = "" ]]; then
      mc_ask "MC_CREATE_USER" "y" \
        "User not found. Create user '${MC_USER}' on start of installation? [\$def]/n" \
        "Create user '$MC_USER': \$var"
      if [[ "${MC_CREATE_USER}" != "y" ]]; then
          log_error "Can't find '${INSTALL_RESOURCES_DIR}${res}'! Aborting..."
          mc_end_gracefully
      fi
      MC_USER_EXISTS="n"
  else
      MC_USER_ESISTS="y"
  fi

  mc_ask "MC_DIR" "/home/$MC_USER/multicraft" \
    "Install Multicraft in: [\$def]" \
    "Installation directory: \$var"
  if [[ -e "${MC_DIR}" ]]; then
      mc_ask "MC_DIR_OVERWRITE" "y" "Warning: '${MC_DIR}' exists! Continue installing in this directory? [\$def]/n" "Installing in existing directory: \$var"
      if [[ "${MC_DIR_OVERWRITE}" != "y" ]]; then
          log_error "Won't install in existing directory. Aborting..."
          mc_end_gracefully
      fi
  fi

  mc_ask "MC_KEY" "no" \
    "If you have a license key you can enter it now: [\$def]" \
    "License key: \$var"
  mc_ask "MC_DAEMON_ID" "1" \
    "If you control multiple machines from one web panel you need to assign each daemon a unique number (requires a Dynamic or custom license). Daemon number? [\$def]" \
    "Daemon number: \$var"
  echo
  echo
}

04_ask_local_installation(){
  log_info "= 04 Local installation? "

  mc_ask "MC_LOCAL" "y" \
   "Will the web panel run on this machine? [\$def]/n" \
   "Local front end: \$var"

  ## Try to determine local IP address
  IP="$(ip a | grep 'inet ' | grep -v '127.0.0.1' | awk '{ print $2 }' | cut -d/ -f1 | head -n1)"

  if [[ "${IP}" = "" ]]; then
    ### Failed, use localhost instead
    IP="127.0.0.1"
    log_debug "== Failed to determine local IP Adress. Now using: '${IP}'"
  else
    log_debug "== Determined local IP-adress: '${IP}'"
  fi


  if [[ "${MC_LOCAL}" != "y" ]]; then
      export MC_DB_TYPE="mysql"

      mc_mc_ask "MC_DAEMON_IP" "${IP}" \
        "IP the daemon will bind to: [\$def]" \
        "Daemon listening on IP: \$var"
      IP="${MC_DAEMON_IP}"
      mc_mc_ask "MC_DAEMON_PORT" "25465" \
        "Port the daemon to listen on: [\$def]" \
        "Daemon port: \$var"
  else
      default_web_user="www-data"
      default_web_directory="/var/www"
      if [[ ! "`which yum 2>/dev/null`" = "" ]]; then
          default_web_user="apache"
          default_web_directory="/var/www/html"
      elif [[ -d "/var/www/html" ]]; then
          default_web_directory="/var/www/html"
      fi

      mc_mc_ask "MC_WEB_USER" "$default_web_user" \
        "User of the webserver: [\$def]" \
        "Webserver user: \$var"
      mc_mc_ask "MC_WEB_DIR" "$default_web_directory/multicraft" \
        "Location of the web panel files: [\$def]" \
        "Web panel directory: \$var"
      if [[ -e "${MC_WEB_DIR}" ]]; then
          mc_mc_ask "MC_WEB_DIR_OVERWRITE" "y" \
            "Warning: '${MC_WEB_DIR}' exists! Continue installing the web panel in this directory? [\$def]/n" \
            "Installing in existing web panel directory: \$var"
          if [[ "${MC_WEB_DIR_OVERWRITE}" != "y" ]]; then
              log_error "Won't install in existing web-panel directory. Aborting..."
              mc_end_gracefully
          fi
      fi
  fi
  mc_mc_ask "MC_DAEMON_PW" "none" \
    "Please enter a new daemon password (use the same password in the last step of the panel installer)  [\$def]" \
    "Daemon connection password: \$var"

  echo
  echo
}

05_ask_ftp_server(){
  log_info "= 05 FTP-Server "
  mc_mc_ask "MC_FTP_SERVER" "y" \
    "Enable builtin FTP server? [\$def]/n" \
    "Enable builtin FTP server: \$var"

  if [[ "${MC_FTP_SERVER}" = "y" ]]; then
      if [[ "${IP}" = "127.0.0.1" || "${IP}" = "" ]]; then
          log_debug "== No sensible FTP server adress '${IP}'. Listen on all interfaces (0.0.0.0)..."
          IP="0.0.0.0"
      fi

      mc_mc_ask "MC_FTP_IP" "${IP}" \
        "IP the FTP server will listen on (0.0.0.0 for all IPs): [\$def]" \
        "FTP server IP: \$var"
      if [[ "${MC_FTP_IP}" = "0.0.0.0" ]]; then
          # Try determining our external IP address
          EXT_IP="`curl -L http://www.multicraft.org/ip 2> /dev/null`"
          mc_mc_ask "MC_FTP_EXTERNAL_IP" "${EXT_IP}" \
           "IP to use to connect to the FTP server (external IP): [\$def]" \
           "FTP server external IP: \$var"

          if [[ "${MC_FTP_EXTERNAL_IP}" = "" || "${MC_FTP_EXTERNAL_IP}" = "0.0.0.0" ]]; then
              # No valid FTP IP configuration, use defaults
              log_debug "== No valid FTP IP configuration supplied. Using defaults..."
              MC_FTP_EXTERNAL_IP=""
              MC_FTP_IP=""
          fi
      fi
      mc_mc_ask "MC_FTP_PORT" "21" \
        "FTP server port: [\$def]" \
        "FTP server port: \$var"

      mc_mc_ask "MC_PLUGINS" "n" \
        "Block FTP upload of .jar files and other executables (potentially dangerous plugins)? [\$def]/y" \
        "Block .jar and executable upload: \$var"
      echo
  fi

  echo
  echo
}

06_ask_database(){
  log_info "= 06 Database-Settings "
  log_debug "== Skip MC_DB_TYPE-Question. Assume 'mysql'..."
  export MC_DB_TYPE="mysql"
#  echo "MySQL is the recommended database type but it requires you to have a MySQL server available."
#  echo "SQLite is more light weight and it will work fine for small installations up to 10 servers."
#  echo "For multiple daemons on a single panel MySQL is required."
#  echo
#  mc_mc_ask "MC_DB_TYPE" "sqlite" "What kind of database do you want to use? [\$def]/mysql" "Database type: \$var"

  if [[ "${MC_DB_TYPE}" = "mysql" ]]; then
    echo
    echo "NOTE: This is for the daemon config, the front end has an installation routine for database configuration and initialization."
    mc_mc_ask "MC_DB_HOST" "127.0.0.1" \
      "Database host: [\$def]" \
      "Database host: \$var"
    mc_mc_ask "MC_DB_NAME" "multicraft_daemon" \
      "Database name: [\$def]" \
      "Database name: \$var"
    mc_mc_ask "MC_DB_USER" "multicraft" \
      "Database user: [\$def]" \
      "Database user: \$var"
    mc_mc_ask "MC_DB_PASS" "" \
     "Database password: [\$def]" \
     "Database password: \$var"
    echo
  fi
#  elif [[ "$MC_DB_TYPE" = "sqlite" ]]; then
#      echo
#      echo "The database will be located at: '$MC_DIR/data/data.db'"
#  else
#      echo "Unsupported database type '$MC_DB_TYPE'!"
#      echo "Aborting."
#      mc_end_gracefully
#  fi
  log_info "*** Please use the web panel to initialize the database."
  echo
}

07_ask_check_user_group_executables(){
  log_info "= 07 Check user/group create/delete utilities "
  MC_JAVA="`which java`"
  MC_ZIP="`which zip`"
  MC_UNZIP="`which unzip`"
  if [[ "$MC_JAVA" = "" ]]; then
      mc_mc_ask "MC_JAVA" "/usr/bin/java" \
        "Path to java program: [\$def]" \
        "Path to java: \$var"
  fi
  if [[ "$MC_ZIP" = "" ]]; then
      mc_ask "MC_ZIP" "/usr/bin/zip" \
        "Path to zip program: [\$def]" \
        "Path to zip: \$var"
  fi
  if [[ "$MC_UNZIP" = "" ]]; then
      mc_ask "MC_UNZIP" "/usr/bin/unzip" \
        "Path to unzip program: [\$def]" \
        "Path to unzip: \$var"
  fi
  if [[ "${MC_MULTIUSER}" = "y" || "${MC_CREATE_USER}" = "y" ]]; then
      MC_USERADD="`which useradd`"
      MC_GROUPADD="`which groupadd`"
      MC_USERDEL="`which userdel`"
      MC_GROUPDEL="`which groupdel`"
      if [[ "$MC_USERADD" = "" ]]; then
          mc_ask "MC_USERADD" "/usr/sbin/useradd" \
            "Path to useradd program: [\$def]" \
            "Path to useradd program: \$var"
      fi
      if [[ "$MC_GROUPADD" = "" ]]; then
          mc_ask "MC_GROUPADD" "/usr/sbin/groupadd" \
            "Path to groupadd program: [\$def]" \
            "Path to groupadd program: \$var"
      fi
      if [[ "$MC_USERDEL" = "" ]]; then
          mc_ask "MC_USERDEL" "/usr/sbin/userdel" \
            "Path to userdel program: [\$def]" \
            "Path to userdel program: \$var"
      fi
      if [[ "$MC_GROUPDEL" = "" ]]; then
          mc_ask "MC_GROUPDEL" "/usr/sbin/groupdel" \
            "Path to groupdel program: [\$def]" \
            "Path to groupdel program: \$var"
      fi
  fi
}

08_ask_should_start_installation(){
  log_info "= 08 Asking if actual Installation should start - otherwise end gracefully."

  log_info
  log_info "NOTE: Any running daemon will be stopped!"
  mc_ask "START_INSTALL" "y" \
    "Ready to install Multicraft. Start installation? [\$def]/n" \
    "-"
  if [[ "${START_INSTALL}" != "y" ]]; then
      echo "Not installing."
      mc_end_gracefully
  fi
}

99_printInstallationComplete(){
  echo
  echo
  log_info "################################################################################"
  log_info "*** Installation complete!"
  log_info "################################################################################"
  echo
  log_info "PLEASE READ-1:"
  echo
  log_info "1) Before starting the daemon you need to run the web panel installer to initialize your database. (example: http://your.address/multicraft/install.php)"
  echo
  log_info "2) After running the web panel installer you can start the daemon as root using the following command:"
  log_info "   sudo $MC_DIR/bin/multicraft start"

  echo
  log_info "READ-2 (Read after steps from READ-1):"
  echo
  log_info "*) You can now proceed to downloading Minecraft and creating your first server:"
  log_info "*) Log in with the username admin and the password admin"
  log_info "*) Change the admin password under \"Users\" and log back in using the new password."
  log_info "*) Go to \"Settings\" -> \"Update Minecraft\""
  log_info "*) Click on \"Download\" to fetch the latest version of Minecraft."
  log_info "*) As soon as it says \"The update is ready to be applied.\" you can click on \"Install\" to put the downloaded file in place".
  log_info "*) It should say \"Update successful\" after that. Minecraft is now installed"
  log_info "*) Create your servers under \"Servers\" -> \"Create Server\""

  echo
  echo
  log_info "For troubleshooting please see:"
  log_info "- Daemon log file:    $MC_DIR/multicraft.log"
  log_info "- Panel log file:     $MC_WEB_DIR/protected/runtime/application.log"
  log_info "- Multicraft Website: http://www.multicraft.org/site/docs/troubleshooting"
  echo
  echo
  read -p "Press [Enter] to continue."
  echo
  echo
  log_info "In case you want to rerun this script you can save the entered settings."
}

98_setup_ufw_if_installed() {
  log_info "== 98 Setup UFW if installed"
  if hash ufw 2>/dev/null; then
    log_info "== Allowing port 25565 and 21 using UFW..."
    ufw allow 25565 # Default Minecraft Port
    ufw allow 21 # FTP
  else
    log_error "== ufw command not found. Skipping this step..."
  fi
}

97_ask_create_needed_sql_users_and_databases() {
# TODO test if this works!
  log_info "== 97 Ask if the needed SQL-Users/Databases should be created."

  if [[ "${MC_DB_NAME}" == "${MC_DB_USER}_"* ]]; then
    log_error "== The database name of the daemon (${MC_DB_NAME}) needs to start with \"${MC_DB_USER}_\" in order for this step to proceed. "
  fi

  if sql_does_user_exist "${MC_DB_USER}"; then
    log_error "=== SQL-User '${MC_DB_USER}' already exists. Skipping step 97..."
    return
  else
    log_debug "=== SQL-User '${MC_DB_USER}' does not exist."

    set +e # Do NOT quit if the following EXIT-CODE is other than 0
    dialog --backtitle "${SCRIPT_NAME}" --title "" \
      --yesno "Create SQL-User '${MC_DB_USER}' and grant all privileges on all Databases starting with his name?" 0 0
    local dialog_response=$?
    set -e

    if [[ "${dialog_response}" -ne 0 ]]; then # no or ESC
      log_debug "=== User chose not to automatically create SQL-User '${MC_DB_USER}' and grant all privileges on all Databases starting with his name."
      return
    fi

    sql_create_user_and_grant_him_privileges_on_databases_starting_with_his_name "${MC_DB_USER}" "${MC_DB_PASS}"
    sql_create_database_if_not_exists "${MC_DB_NAME}"
  fi

  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  dialog --backtitle "${SCRIPT_NAME}" --title "" \
    --yesno "Create Database 'multicraft_panel' (on which the user '${MC_DB_USER}' has all privileges)?" 0 0
  local dialog_response=$?
  set -e

  if [[ "${dialog_response}" -ne 0 ]]; then # no or ESC
    log_debug "=== User chose not to Create Database 'multicraft_panel' (on which the user '${MC_DB_USER}' has all privileges)."
    return
  fi

  sql_create_database_if_not_exists "multicraft_panel"
}

11_stop_deamons() {
  log_info "= 11 Stop Multicraft and FTP Deamons using '${MC_DIR}/bin/multicraft'"
  if [[ -e "${MC_DIR}/bin/multicraft" ]]; then
      log_debug "== Stopping daemon if running:"
      "${MC_DIR}/bin/multicraft" stop
      "${MC_DIR}/bin/multicraft" stop_ftp
      sleep 1
  fi
}

12_mc_and_user_directory_setup() {
  # Multicraft user & directory setup
  log_info "= 12 Multicraft user & directory setup"

  if [[ "$MC_USER_EXISTS" = "n" ]]; then
      echo
      log_debug -n "== Creating user '$MC_USER'... "
      "$MC_GROUPADD" "${MC_USER}"
      if [[ ! "$?" = "0" ]]; then
          log_error "=== Can't create group '$MC_USER'! Please create this group manually and re-run the setup script."
      fi

      "$MC_USERADD" "${MC_USER}" -g "${MC_USER}" -s /bin/false
      if [[ ! "$?" = "0" ]]; then
          log_error "=== Can't create user '$MC_USER'! Please create this user manually and re-run the setup script."
      fi
      log_debug "=== Done."
  fi

  echo
  log_debug -n "== Creating directory '$MC_DIR'... "
  mkdir -p "$MC_DIR"
  echo "=== Done. "

  echo
  log_debug "== Ensuring the home directory exists and is owned and writable by the user... "
  MC_HOME="`grep "^$MC_USER:" /etc/passwd | awk -F":" '{print $6}'`"
  mkdir -p "$MC_HOME"
  chown "${MC_USER}":"${MC_USER}" "$MC_HOME"
  chmod u+rwx "$MC_HOME"
  chmod go+x "$MC_HOME"
  log_debug "=== Done."

  echo
  if [[ -e "${MC_DIR}/bin" && "$( cd "bin/" && pwd )" != "$( cd "${MC_DIR}/bin" 2>/dev/null && pwd )" ]]; then
      log_debug "== Backing up existing 'bin' directory... "
      mv "${MC_DIR}/bin" "${MC_DIR}/bin.bak"
      log_debug "=== Done."
  fi
  for res in ${INSTALL_RESOURCES}; do
      log_debug "== Installing '${INSTALL_RESOURCES_DIR}$res' to '$MC_DIR/'... "
      cp -a "${INSTALL_RESOURCES_DIR}$res" "${MC_DIR}/"
      log_debug "=== Done."
  done
  log_debug "== Cleaning up files... "
  rm -f "${MC_DIR}/bin/_weakref.so"
  rm -f "${MC_DIR}/bin/collections.so"
  rm -f "${MC_DIR}/bin/libpython2.5.so.1.0"
  rm -f "${MC_DIR}/bin/"*-py2.5*.egg
  log_debug "=== Done."

  if [[ "${MC_KEY}" != "no" ]]; then
      echo
      log_debug "== Installing license key... "
      echo "${MC_KEY}" > "${MC_DIR}/multicraft.key"
      log_debug "=== Done."
  fi
}

13_generate_actual_config() {
  CFG="${MC_DIR}/multicraft.conf"
  log_debug "= 13 Generate actual config (${CFG})"
  echo

  if [[ -e "${CFG}" ]]; then
      mc_ask "OVERWRITE_CONF" "n" \
        "The 'multicraft.conf' file already exists, overwrite? y/[\$def]" \
        "-"
  fi

  if [[ "$MC_DB_TYPE" = "mysql" ]]; then
      DB_STR="mysql:host=$MC_DB_HOST;dbname=$MC_DB_NAME"
  fi

  if [[ ! -e "${CFG}" || "$OVERWRITE_CONF" = "y" ]]; then
      if [[ -e "${CFG}" ]]; then
          log_debug "== Multicraft.conf exists, backing up... "
          cp -a "${CFG}" "$CFG.bak"
          log_debug "=== Done."
      fi

      log_debug "== Generating 'multicraft.conf' (at '${CFG}')... "
      > "${CFG}"

      SECTION=""
      cat "$CFG.dist" | while IFS="" read -r LINE
      do
          if [[ "`echo ${LINE} | grep "^ *\[\w\+\] *$"`" ]]; then
              SECTION="$LINE"
              SETTING=""
          else
              SETTING="`echo ${LINE} | sed -n 's/^ *\#\? *\([^ ]\+\) *=.*/\1/p'`"
          fi

          case "$SECTION" in
          "[multicraft]")
              case "$SETTING" in
              "user")         repl "${MC_USER}" ;;
              "ip")           if [[ "$MC_LOCAL" != "y" ]]; then repl "$MC_DAEMON_IP";       fi ;;
              "port")         if [[ "$MC_LOCAL" != "y" ]]; then repl "$MC_DAEMON_PORT";     fi ;;
              "password")     repl "$MC_DAEMON_PW" ;;
              "id")           repl "$MC_DAEMON_ID" ;;
              "database")     if [[ "$MC_DB_TYPE" = "mysql" ]]; then repl "$DB_STR";        fi ;;
              "dbUser")       if [[ "$MC_DB_TYPE" = "mysql" ]]; then repl "$MC_DB_USER";    fi ;;
              "dbPassword")   if [[ "$MC_DB_TYPE" = "mysql" ]]; then repl "$MC_DB_PASS";    fi ;;
              "webUser")      if [[ "$MC_DB_TYPE" = "mysql" ]]; then repl "";               else repl "$MC_WEB_USER"; fi ;;
              "baseDir")      repl "$MC_DIR" ;;
              esac
          ;;
          "[ftp]")
              case "$SETTING" in
              "enabled")          if [[ "$MC_FTP_SERVER" = "y" ]]; then repl "true";    else repl "false"; fi ;;
              "ftpIp")            if [[ ! "$MC_FTP_IP" = "" ]]; then repl "$MC_FTP_IP"; fi ;;
              "ftpExternalIp")    if [[ ! "$MC_FTP_EXTERNAL_IP" = "" ]]; then repl "$MC_FTP_EXTERNAL_IP"; fi ;;
              "ftpPort")          repl "$MC_FTP_PORT" ;;
              "forbiddenFiles")   if [[ "$MC_PLUGINS" = "n" ]]; then repl "";           fi ;;
              esac
          ;;
          "[minecraft]")
              case "$SETTING" in
              "java") repl "$MC_JAVA" ;;
              esac
          ;;
          "[system]")
              case "$SETTING" in
              "unpackCmd")    repl "$MC_UNZIP"' -quo "{FILE}"' ;;
              "packCmd")      repl "$MC_ZIP"' -qr "{FILE}" .' ;;
              esac
              if [[ "$MC_MULTIUSER" = "y" ]]; then
                  case "$SETTING" in
                  "multiuser")    repl "true" ;;
                  "addUser")      repl "$MC_USERADD"' -c "Multicraft Server {ID}" -d "{DIR}" -g "{GROUP}" -s /bin/false "{USER}"' ;;
                  "addGroup")     repl "$MC_GROUPADD"' "{GROUP}"' ;;
                  "delUser")      repl "$MC_USERDEL"' "{USER}"' ;;
                  "delGroup")     repl "$MC_GROUPDEL"' "{GROUP}"' ;;
                  esac
              fi
          ;;
          "[backup]")
              case "$SETTING" in
              "command")  repl "$MC_ZIP"' -qr "{WORLD}-tmp.zip" . -i "{WORLD}"*/*' ;;
              esac
          ;;
          esac
          echo "$LINE" >> "${CFG}"
      done
      log_debug "=== Done."
  fi
}

14_set_permissions() {
  log_info "= 14 Set permissions (using chmod and chown)"
  echo
  log_debug "== Setting owner of '$MC_DIR' to '$MC_USER'... "
  chown "${MC_USER}":"${MC_USER}" "$MC_DIR"
  log_debug "=== Done."
  log_debug "== Setting special daemon permissions... "
  chown -R "${MC_USER}":"${MC_USER}" "${MC_DIR}/bin"
  chown -R "${MC_USER}":"${MC_USER}" "${MC_DIR}/downloader"
  chmod 555 "${MC_DIR}/downloader/downloader"
  chown -R "${MC_USER}":"${MC_USER}" "${MC_DIR}/launcher"
  chmod 555 "${MC_DIR}/launcher/launcher"
  chown -R "${MC_USER}":"${MC_USER}" "${MC_DIR}/jar"
  chown -R "${MC_USER}":"${MC_USER}" "${MC_DIR}/scripts"
  chmod 555 "${MC_DIR}/scripts/getquota.sh"
  chown -R "${MC_USER}":"${MC_USER}" "${MC_DIR}/ssl"
  chown -R "${MC_USER}":"${MC_USER}" "${MC_DIR}/templates"
  chown "${MC_USER}":"${MC_USER}" "${MC_DIR}/default_server.conf.dist"
  chown "${MC_USER}":"${MC_USER}" "${MC_DIR}/server_configs.conf.dist"

  if [[ "$MC_MULTIUSER" = "y" ]]; then
      chown 0:"${MC_USER}" "${MC_DIR}/bin/useragent"
      chmod 4550 "${MC_DIR}/bin/useragent"
  fi
  set +e # Don't exit if no .jar was found
  chmod 755 "${MC_DIR}/jar/"*.jar 2> /dev/null
  set +e
  log_debug "=== Done."
  echo
}

15_install_php_frontend() {
  log_info "= 15 Install PHP Frontend."
  if [[ "$MC_LOCAL" = "y" ]]; then
    echo

    if [[ -e "$MC_WEB_DIR" && -e "$MC_WEB_DIR/protected/data/data.db" ]]; then
        log_debug "== Web directory exists, backing up 'protected/data/data.db'... "
        cp -a "$MC_WEB_DIR/protected/data/data.db" "$MC_WEB_DIR/protected/data/data.db.bak"
        log_debug "=== Done."
    fi

    log_debug "== Creating directory '$MC_WEB_DIR'... "
    mkdir -p "$MC_WEB_DIR"
    log_debug "=== Done."

    log_debug "== Installing web panel files from 'panel/' to '$MC_WEB_DIR'... "
    cp -a ${INSTALL_RESOURCES_DIR}panel/* "$MC_WEB_DIR"
    cp -a ${INSTALL_RESOURCES_DIR}panel/.ht* "$MC_WEB_DIR"
    log_debug "=== Done."

    log_debug "== Setting owner of '$MC_WEB_DIR' to '$MC_WEB_USER'... "
    chown -R "$MC_WEB_USER":"$MC_WEB_USER" "$MC_WEB_DIR"
    log_debug "=== Done."

    log_debug "Setting permissions of '$MC_WEB_DIR'... "
    chmod -R o-rwx "$MC_WEB_DIR"
    log_debug "=== Done."

    echo
    # SELinux related settings
    CHCON="`which chcon 2>/dev/null`"
    RESTORECON="`which restorecon 2>/dev/null`"
    SETSEBOOL="`which setsebool 2>/dev/null`"
    if [[ ! "$CHCON" = "" && ! "$RESTORECON" = "" && ! "$SETSEBOOL" = "" ]]; then
        log_debug "== Applying SELinux contexts... "
        {
        ${RESTORECON} -R "$MC_WEB_DIR"
        ${CHCON} -R --type=httpd_sys_rw_content_t "$MC_WEB_DIR/assets"
        ${CHCON} -R --type=httpd_sys_rw_content_t "$MC_WEB_DIR/protected/config"
        ${CHCON} -R --type=httpd_sys_rw_content_t "$MC_WEB_DIR/protected/data"
        ${CHCON} -R --type=httpd_sys_rw_content_t "$MC_WEB_DIR/protected/runtime"
#        if [[ "$MC_DB_TYPE" = "sqlite" ]]; then
#            ${CHCON} -R --reference="$MC_WEB_DIR/assets" "${MC_DIR}/data/data.db"
#        fi
        ${SETSEBOOL} -P httpd_can_network_connect 1
        } 2>/dev/null
        log_debug "=== Done."
    fi

    log_debug "== Generating '/etc/apache2/conf-available/multicraft.conf'... "
    cat << EOF > /etc/apache2/conf-available/multicraft.conf
# DYNAMICALLY GENERATED BY ${SCRIPT_NAME} on $(date)
<Directory ${MC_WEB_DIR}>
  AllowOverride All
</Directory>
EOF
    log_debug "=== Enabling conf and reloading apache2... "
    a2enconf multicraft.conf && systemctl reload apache2
    log_debug "=== Done. "
  else
      ## PHP frontend not on local machine
      echo
      log_error "=* NOTE: The web panel (PHP Frontend) will not be installed on this machine. \
                Please put the contents of the directory 'panel/' in a web accessible directory of the machine you want to run the web panel on and run the installer (install.php)."
  fi
  echo
}

10_startInstallation(){
  echo
  log_info "################################################################################"
  log_info "*** 10 STARTING INSTALLATION"
  log_info "################################################################################"
  echo

  11_stop_deamons
  12_mc_and_user_directory_setup
  13_generate_actual_config
  14_set_permissions
  15_install_php_frontend

  log_info "= Temporarily starting daemon to set DB permissions:"
  "${MC_DIR}/bin/multicraft" set_permissions

  97_ask_create_needed_sql_users_and_databases
  98_setup_ufw_if_installed
  99_printInstallationComplete
  mc_end_gracefully
}

call_module(){
  cd "${INSTALL_RESOURCES_DIR}"

  01_check_resources
  02_ask_load_existing_installation_script_config
  03_ask_basic_information
  04_ask_local_installation
  05_ask_ftp_server
  06_ask_database
  07_ask_check_user_group_executables

  08_ask_should_start_installation

  10_startInstallation

  cd "${SCRIPT_DIR}"
}

