#!/bin/bash
#
# @author (Most parts copied from my version of installimage, which was in-turn originally written by Hetzner)
#
set -eo pipefail
check_is_utils_initialized
source_utils "randomization"

#######################################
# Return's:
#   The PIPESTATUS of the last mysql command
#######################################
randomize_debian_sys_maint_mysql_password() {
  log_info "== Randomizing debian-sys-maint's mysql-password"

  log_debug "=== Generate password..."
  local -r new_debian_sys_maint_mysql_password="$(generate_password)"
  set_mysql_password debian-sys-maint "$new_debian_sys_maint_mysql_password" || return 1

  log_debug "=== Edit etc/mysql/debian.cnf..."
  sed -i "s/^ *password  *=.*$/password = $new_debian_sys_maint_mysql_password/g" "etc/mysql/debian.cnf" || return 1

  if ! mysql_running; then
    start_mysql || return 1;
  fi

  log_debug "=== Applying..."
  echo QUIT | mysql --defaults-file=/etc/mysql/debian.cnf -u debian-sys-maint |& log_debug_output
  return "${PIPESTATUS[1]}"
}

#######################################
# Return's:
#   1 (false) if the mysqladmin-ping failed
#######################################
mysql_running() {
 mysqladmin ping &> /dev/null;
 return $?
}

#######################################
# Starts mysql using systemctl. Finishes when mysql_running return 0 (true).
#######################################
start_mysql() {
  log_info "== Starting mysql..."
  systemctl start mysql &> log_debug_output || return 1
  until mysql_running; do :; done
}

#######################################
# Stops mysql using systemctl. Finishes when mysql_running returns 1 (false).
#######################################
stop_mysql() {
  log_info "== Stopping mysql..."
  start_mysql || return 1
  systemctl stop mysql &> /dev/null || return 1
  while mysql_running; do :; done
}


#######################################
# Params:
#   @ - SQL-Query to inject
# Return's:
#   1 if start_mysql exited with an error (returned1), otherwise the PIPESTATUS from the executed mysql-command
#######################################
query_mysql() {
  if ! mysql_running; then
    start_mysql || return 1
  fi
  echo "$@" | mysql -N
  return "${PIPESTATUS[1]}"
}

#######################################
# Params:
#   1 - SQL username
# Return's:
#   1 if the query_mysql found 0 users matching the given name
#######################################
mysql_user_exists() {
  local -r mysql_user="$1"
  [[ "$(query_mysql "SELECT COUNT(*) FROM mysql.user WHERE user = '${mysql_user//\'/\\\'}';")" == '0' ]] && return 1
  return
}

#######################################
# Finds out the password_field of the "mysql.user" table,
# updates password_last_changed to the current and $password_field to the provided one,
# and flushes privileges so the changes imminently take affect.
#
# Params:
#   1 - SQL username
#   2 - new password
# Return's:
#   1 if start_mysql exited with an error (aka. returned 1), otherwise the PIPESTATUS from the executed mysql-command
#######################################
set_mysql_password() {
  log_info "== Set mysql-password of user ${1}..."
  local -r user="$1"
  local -r password="$2"
  local password_field

  if ! [[ "$(query_mysql "SELECT plugin FROM mysql.user WHERE user = '${user//\'/\\\'}';")" =~ ^mysql_native_password$|^unix_socket$ ]]; then
    password_field='password'
  else
    password_field='authentication_string'
  fi

  query_mysql "UPDATE mysql.user SET password_last_changed = NOW() WHERE user = '${user//\'/\\\'}';" &> /dev/null
  query_mysql "UPDATE mysql.user SET $password_field = PASSWORD('${password//\'/\\\'}') WHERE user = '${user//\'/\\\'}';" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1
  query_mysql 'FLUSH PRIVILEGES;' |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1
  echo QUIT | mysql -u "$user" -p"$password" |& log_debug_output
  return "${PIPESTATUS[1]}"
}

#######################################
# Params:
#   1 - new password for the sql-user "root"
# Return's:
#   1 if anything failed
#######################################
set_mysql_root_password() {
  log_info "== Reset mysql-password of root-user..."
  local -r new_root_password="$1"
  if ! mysql_running; then
    start_mysql || return 1
  fi
  stop_mysql || return 1

  mkdir -p /var/run/mysqld || return 1
  chown mysql:mysql /var/run/mysqld || return 1
  'mysqld_safe --skip-grant-tables &> /dev/null &'

  until mysql_running; do :; done
  set_mysql_password root "$new_root_password" || return 1

  query_mysql QUIT || return 1
  mysqladmin shutdown &> /dev/null || return 1
  while mysql_running; do :; done
}

#######################################
# Params:
#   1 - SQL username
#   2 - password
# Return's:
#   1 if any of the query_mysql-functions or mysql-commands failed.
#######################################
create_mysql_user_with_all_privileges() {
  local -r user="$1"
  local -r password="$2"

  query_mysql "CREATE USER '${user//\'/\\\'}'@'localhost' IDENTIFIED BY '${password//\'/\\\'}';" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1

  query_mysql "GRANT ALL ON *.* TO '${user//\'/\\\'}'@'localhost' WITH GRANT OPTION;" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1

  query_mysql "FLUSH PRIVILEGES;" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1

  echo QUIT | mysql -u "$user" -p"$password" |& log_debug_output
  return "${PIPESTATUS[1]}"
}