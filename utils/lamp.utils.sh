#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized
source_utils "mysql"
source_utils "randomization"
source_utils "certificates"

lamp_install(){
  log_info "= Start installation of Apache2, MariaDB-Server, PHP(+extensions) from the default Debian-Buster repository"
  log_info "== (Unattended) Installing Apache2..."
  apt_get_without_interaction "install" "apache2" | log_debug_output

  log_info "== (Unattended) Installing MariaDB-Server..."
  apt_get_without_interaction "install" "mariadb-server" | log_debug_output

  log_info "== (Unattended) Installing PHP, including it's mods for apache2 and mysql..."
  apt_get_without_interaction "install" "php libapache2-mod-php php-mysql php-pdo-sqlite" | log_debug_output

  log_info "== Start Change some PHP Configuration-Values..."
  lamp_update_php_setting "memory_limit" "1G" # Default: 8M
  lamp_update_php_setting "upload_max_filesize" "500M" # Default: 2M
  lamp_update_php_setting "post_max_size" "512M" # Default: 8M
  lamp_update_php_setting "max_execution_time" "360" # Default: 30

  log_info "== Reloading Apache2..."
  systemctl reload apache2 | log_debug_output
  systemctl status apache2 | log_debug_output
}

lamp_install_phpmyadmin_mods() {
  log_info "= Start installation/configuration of PHPMyAdmin"
  log_info "== (Unattended) Installing recommended PHP extensions for PHPMyAdmin..."
  apt_get_without_interaction "install" "php-mbstring php-zip php-gd php-cgi php-mysqli php-pear php-gettext php-common php-phpseclib" | log_debug_output

  log_info "== Making sure 'mcrypt' and 'mbstring'-modules are enabled"
  phpenmod mcrypt
  phpenmod mbstring
}

lamp_check_if_sql_admin_maintenance_user_exists_and_ask_to_create(){
  log_info "== Checking if SQL-User '${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}' exists (${_SQL_SERVER_ADMIN_MAINTENANCE_USERNAME_COMMENT})..."
  if ! sql_does_user_exist "${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}"; then
    log_info "*** SQL-User '${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}' does not exist!"
    while true; do
      read -s -p "*** Please enter a password for the SQL-User '${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}': " given_password
      echo
      read -s -p "*** Please enter a password for the SQL-User '${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}' (again): " given_password2
      echo

      if [[ "$given_password" = "$given_password2" ]]; then
        sql_create_user_and_grant_all_privileges "${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}" "${given_password}"
        break
      else
       log_error "The given passwords weren't identical. Please try again."
      fi
    done
  fi
}

ask_to_enable_default_https(){

  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  dialog --backtitle "${SCRIPT_NAME}" --title "Enable default HTTPS Configuration" \
    --yesno "Regenerate snakeoil-certificate and enable apache's default-ssl configuration?" 0 0
  local -r dialog_response=$?
  set -e

  if [[ "${dialog_response}" -ne 0 ]]; then # no or ESC
    log_debug "=== Returning back to main-menu..."
    return
  fi

  log_info "= Re-Generate snakeoil-ssl-certificate"
  cert_regenerate_snakeoil_ssl_cert | log_debug_output
  log_info "= Enable Default SSL Apache2-Configuration which uses our (invalid - self generated) \"snakeoil\"-ssl-certificate"
  cert_enable_default_ssl_config | log_debug_output
}


#######################################
# Escape and normalize a string so it can be used safely in file names, etc.
# Originally from: https://github.com/StanAngeloff/vagrant-shell-scripts/blob/master/ubuntu.sh (Mentioned in https://stackoverflow.com/a/23124161)
#
# Params:
#   1 - String to escape
#######################################
system_escape() {
  local glue
  glue=${1:--}
  while read arg; do
    echo "${arg,,}" | sed -e 's#[^[:alnum:]]\+#'"$glue"'#g' \
                          -e 's#^'"$glue"'\+\|'"$glue"'\+$##g'
  done
}

#######################################
# This function locates every "php*.ini"-file inside "/etc" (also known as "Server APIs", like "apache2" "cli" "fpm"), checks to make sure its corresponding "conf.d" directory exists and creates a new file in it that only contains this one line of config-change.
#
# The name of the mentioned file is "0-${settings_name}.ini", where
# * 0 makes sure that it gets highest priority
# * and "settings_name" is the "filesystem-escaped" version of it's content. (see function "system_escape")
# (e.G. "lamp_update_php_setting 'memory_limit' '20M'" creates a file named "0-memory-limit-20m.ini" with the content of "memory_limit=20M")
# (This file then should also be displayed under "Additional .ini files parsed" in "PHP's phpinfo()"-site.)
#
# Originally from: https://github.com/StanAngeloff/vagrant-shell-scripts/blob/master/ubuntu.sh (Mentioned in https://stackoverflow.com/a/23124161)
#
# Params:
#   1 - Name
#   2 - Value
#######################################
lamp_update_php_setting() {
  local args

  args=("$@")
  PREVIOUS_IFS="$IFS"
  IFS='='
  args="${args[*]}"
  IFS="${PREVIOUS_IFS}"

  local -r escaped_settings_name="$(echo "${args}" | system_escape)"
  local current_php_ini_path
  for current_php_ini_path in $(find /etc -type f -iname 'php*.ini'); do
    local current_php_extra_dir_path="$(dirname "${current_php_ini_path}")/conf.d"
    mkdir -p "${current_php_extra_dir_path}"
    echo "${args}" | tee "${current_php_extra_dir_path}/0-${escaped_settings_name}.ini" >/dev/null
  done
}
