#!/bin/bash
#
# @author PixelTutorials
# Comment: The substition ${variable//\'/\\\'} makes sure to escape any "'" with "\'", preventing SQL-Injections
#
set -eo pipefail
check_is_utils_initialized
source_utils "randomization"

# Username of the privileged user that the server-administrator himself uses.
SQL_SERVER_ADMIN_MAINTENANCE_USERNAME="furrynator"
_SQL_SERVER_ADMIN_MAINTENANCE_USERNAME_COMMENT="SQL-User with all privileges that should be used if the Server-Administrator himself wants to do remote maintenance - phpMyAdmin root-login has been disabled!"

#######################################
# Return's:
#   1 (false) if the mysqladmin-ping failed
#######################################
is_mysqldaemon_running() {
 mysqladmin ping &> /dev/null;
 return $?
}

#######################################
# Makes sure mysql is started using `start_mysql_if_stopped_and_wait`, and then
# stops mysql.service.
# Finishes when `is_mysqldaemon_running` returns 1 (false).
#######################################
stop_mysqldaemon_and_wait() {
  start_mysql_if_stopped_and_wait || return 1

  log_info "=== Stopping mysql-service (daemon)..."
  systemctl stop mysql.service || return 1
  while is_mysqldaemon_running; do
    sleep 1
  done
}

#######################################
# Return's:
#   1 (false) if the pgrep-command failed to locate a process with the name of "mysql"
#######################################
is_mysqlserver_running() {
  up=$(pgrep mysql | wc -l);
  if [[ "$up" -ge 1 ]]; then
    return 0
  else
    return 1
  fi
}

#######################################
# Tries to start mysql using systemctl if either the Server or Daemon aren't running.
# Finishes when `is_mysqlserver_running` returns 0 (true).
#
# Return's:
#   1 (false) if `systemctl start` failed
#######################################
start_mysql_if_stopped_and_wait() {
  if ! is_mysqlserver_running || ! is_mysqldaemon_running; then
    log_info "=== Starting mysql..."
    systemctl start mysql || return 1
  fi

  until is_mysqlserver_running; do
    sleep 1
  done
}

#######################################
# Makes sure mysql is started using `start_mysql_if_stopped_and_wait` and then stops mysql using systemctl.
# Finishes when `is_mysqlserver_running` returns 1 (false).
#######################################
stop_mysqlserver_and_wait() {
  start_mysql_if_stopped_and_wait || return 1

  log_info "=== Stopping mysql-server..."
  systemctl stop mysql || return 1
  while is_mysqlserver_running; do
    sleep 1
  done
}

#######################################
# Makes sure that mysql is running using `start_mysql_if_stopped_and_wait` and then injects the given Query using `mysql -N`
#
# Params:
#   @ - SQL-Query to inject
# Return's:
#   1 if `start_mysql_if_stopped_and_wait` exited with an error (returned 1), otherwise the PIPESTATUS from the executed mysql-command
#######################################
query_mysql() {
  start_mysql_if_stopped_and_wait || return 1

  echo "$@" | mysql -N
  return "${PIPESTATUS[1]}"
}

#######################################
# Makes sure that mysql is running using `start_mysql_if_stopped_and_wait` and then injects the given Query using `mysql -N`
#
# Params:
#   @ - SQL-Query to inject
# Return's:
#   1 if `start_mysql_if_stopped_and_wait` exited with an error (returned 1)
# Echo's:
#   The output of the executed mysql-command
#######################################
query_mysql_echo() {
  start_mysql_if_stopped_and_wait || return 1

  local -r result="$(echo "$@" | mysql -N)"
  echo "${result}"
}

#######################################
# Return's:
#   1 if the mysql-query failed
#######################################
query_flush_privileges() {
  query_mysql "FLUSH PRIVILEGES;" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1
}

#######################################
# Params:
#   1 - SQL username
# Return's:
#   1 if the mysql-query found 0 users matching the given name
#######################################
does_mysql_user_exist() {
  local -r mysql_user="$1"
  RESULT="$(mysql -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${mysql_user//\'/\\\'}')")"
  if [[ "$RESULT" = 1 ]]; then
    return 0 # exists
  else
    return 1 # doesnt exist
  fi
}

#######################################
# Params:
#   1 - SQL username
# Echo's:
#   Either "authentication_string" or "password", depending on the 'plugin'-field of the found SQL-User-Entry
#######################################
get_mysql_password_fieldname() {
  local -r user="$1"
  # See https://dba.stackexchange.com/a/224238
  if ! [[ "$(query_mysql "SELECT plugin FROM mysql.user WHERE user = '${user//\'/\\\'}';")" =~ ^mysql_native_password$|^unix_socket$ ]]; then
    password_field='authentication_string'
  else
    password_field='password'
  fi

  echo "${password_field}"
}

#######################################
# Finds out the password_field of the "mysql.user" table,
# changes its value,
# flushes the privileges (so the changes imminently take affect) and
# makes a useless query with the given credentials to make sure everything worked.
#
# Params:
#   1 - SQL username
#   2 - new password
# Return's:
#   1 if any of the executed SQL-Queries failed.
#######################################
set_mysql_password() {
  log_info "== Set mysql-password of user ${1}..."
  local -r user="$1"
  local -r password="$2"
  local -r password_field="$(get_mysql_password_fieldname "${user}")"

# 'password_last_changed' was removed in MySQL 5.7 and greater: https://stackoverflow.com/a/35073129
#  query_mysql "UPDATE mysql.user SET password_last_changed = NOW() WHERE user = '${user//\'/\\\'}';" &> /dev/null
  query_mysql "UPDATE mysql.user SET $password_field = PASSWORD('${password//\'/\\\'}') WHERE user = '${user//\'/\\\'}';" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1

  query_flush_privileges || return 1

  echo QUIT | mysql -u "$user" -p"$password" |& log_debug_output
  return "${PIPESTATUS[1]}"
}

#######################################
# Finds out the password_field of the "mysql.user" table,
# checks if the given user exists and fetches password_field.
#
# Params:
#   1 - SQL username
# Return's:
#   1 if `does_mysql_user_exist` failed (= User doesn't exist). 0 if the query wasn't empty.
#######################################
has_mysql_password() {
  log_info "== Check if mysql-user '${1}' has password..."
  local -r user="$1"
  local -r password_field="$(get_mysql_password_fieldname "${user}")"

  does_mysql_user_exist "$user" || log_error "SQL-User '$user' doesn't exist!" || return 1

  local -r found_password="$(query_mysql_echo "SELECT ${password_field} FROM mysql.user WHERE user = '${user//\'/\\\'}';")" |& log_debug_output

  if [[ -z "${found_password}" ]]; then
    return 1 # empty
  fi
  return 0 # not empty
}

#######################################
# Return's:
#   1 if any of the executed SQL-Queries failed.
#######################################
#randomize_debian_sys_maint_mysql_password() {
#  log_info "== Randomizing debian-sys-maint's mysql-password"
#
#  log_debug "=== Generate password..."
#  local -r new_debian_sys_maint_mysql_password="$(generate_password)"
#  set_mysql_password debian-sys-maint "$new_debian_sys_maint_mysql_password" || return 1
#
#  log_debug "=== Edit etc/mysql/debian.cnf..."
#  sed -i "s/^ *password  *=.*$/password = $new_debian_sys_maint_mysql_password/g" "etc/mysql/debian.cnf" || return 1
#
#  start_mysql_if_stopped_and_wait || return 1;
#
#  log_debug "=== Applying..."
#  echo QUIT | mysql --defaults-file=/etc/mysql/debian.cnf -u debian-sys-maint |& log_debug_output
#  return "${PIPESTATUS[1]}"
#}

####################################### TODO doesnt work
# DEPRECATED - SQL-Password of user 'root' should NOT be changed.
# See _SQL_SERVER_ADMIN_MAINTENANCE_USERNAME_COMMENT for an explanation of this decision
#
# STOPS!! the SQL-Server, restarts it with the option to skip-grant-tables (takes out auth),
# sets the password, unsets the environment variable and restarts again
#
# Params:
#   1 - new password for the sql-user "root"
# Return's:
#   1 if anything failed
#######################################
#set_mysql_root_password() {
#  log_info "= Set password of mysql-user 'root'..."
#  local -r new_root_password="$1"
#
#  if ! has_mysql_password "root"; then
#    # no password = anyone with superuser privileges (aka. root itself or any sudo user) can just use the mysql command
#    log_info "== SQL-User 'root' has no password at all. No need to do any workaround - just changing the password..."
#    set_mysql_password "root" "$new_root_password" || return 1
#  else
#    log_info "== #1 Make sure MySQL-Server Process is stopped"
#    start_mysql_if_stopped_and_wait || return 1
#    stop_mysqlserver_and_wait || return 1
#
#    log_info "== #2 Restart Server without permission checks"
#    systemctl set-environment MYSQLD_OPTS="--skip-grant-tables --skip-networking"
#    start_mysql_if_stopped_and_wait || return 1
#
#    log_info "== #3 Actually changing the root Password"
#    query_flush_privileges || return 1
#  #  query_mysql "UPDATE mysql.user SET plugin = '' WHERE user = 'root';"
#    set_mysql_password "root" "$new_root_password" || return 1
#
#    log_info "== #4 Reverting to normal settings"
#    systemctl unset-environment MYSQLD_OPTS || return 1
#    systemctl restart mariadb
#  fi
#
#  log_info "== Making a useless query to see if it fails. "
#  query_mysql "QUIT" || return 1
#}

#######################################
# Params:
#   1 - SQL username
#   2 - password
# Return's:
#   1 if the mysql-query failed
#######################################
create_mysql_user() {
  local -r user="$1"

  does_mysql_user_exist "$user" && log_error "== MySQL-User '${user}' already exists. Skipping creation-command..." && return 0

  local -r password="$2"
  log_info "== Creating SQL-User '$user'..."
  query_mysql "CREATE USER '${user//\'/\\\'}'@'localhost' IDENTIFIED BY '${password//\'/\\\'}';" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1
}

#######################################
# Params:
#   1 - SQL username
#   2 - password
# Return's:
#   1 if any of the mysql-queries failed
#######################################
create_mysql_user_with_all_privileges() {
  log_info "= Create SQL-User '$1' + Grant ALL!! PRIVILEGES"
  local -r user="$1"
  local -r password="$2"

  create_mysql_user "$user" "$password" || return 1

  query_mysql "GRANT ALL PRIVILEGES ON *.* TO '${user//\'/\\\'}'@'localhost' WITH GRANT OPTION;" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1

  query_flush_privileges || return 1

  echo QUIT | mysql -u "$user" -p"$password" |& log_debug_output
  return "${PIPESTATUS[1]}"
}

#######################################
# Params:
#   1 - SQL username
# Return's:
#   nothing - even if the mysql-query failed
#######################################
create_database_if_not_exists(){
  local -r database="$1"
  local escaped_database="${database//\'/\\\'}" # Escape "'"
#       escaped_database="${escaped_database//_/\\_}" # Escape "_" TODO is this needed?

  log_info "== Creating database with the name '${escaped_database}' if it doesn't already exist..."
  query_mysql "CREATE DATABASE IF NOT EXISTS \`${escaped_database}\`;" |& log_debug_output
}

#######################################
# Inspired by the query produced when creating a new user in phpMyAdmin (when leaving everything by default, aka. when every Field in "Resource constraints" is filled in with 0)
# Params:
#   1 - SQL username
# Return's:
#   1 if the mysql-query failed
#######################################
grant_all_usage_without_restrictions() {
  local -r user="$1"
  local escaped_user="${user//\'/\\\'}" # Escape "'"

  log_info "== Granting *.* usage to user '${escaped_user}' without ANY Resource constraints..."
  query_mysql "GRANT USAGE ON *.* TO '${escaped_user}'@'localhost' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1
}


#######################################
# Params:
#   1 - SQL username
#   2 - password
#   3 - Name of SQL-Database to create and grant privileges to
# Return's:
#   1 if any of the mysql-queries failed
#######################################
create_mysql_user_and_database_and_grant_privileges(){
  log_info "= Create SQL-User '$1' + Create Database '$3' (if not already exists) and grant the mentioned user all privileges on it."
  local -r user="$1"
  local escaped_user="${user//\'/\\\'}" # Escape "'"
  local -r password="$2"
  local -r database="$3"
  local escaped_database="${database//\'/\\\'}" # Escape "'"
#       escaped_database="${escaped_database//_/\\_}" # Escape "_" TODO is this needed?

  create_mysql_user "$user" "$password" || return 1

  grant_all_usage_without_restrictions "$user" || return 1

  create_database_if_not_exists "$database"

  log_info "== Granting user '${escaped_user}' ALL privileges on Database '${escaped_database}'..."
  query_mysql "GRANT ALL PRIVILEGES ON \`${escaped_database}\`.* TO '${escaped_user}'@'localhost';" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1
}

#######################################
# Inspired by the option "Create a database with the same name and grant all privileges." when creating a new user in phpMyAdmin, which produces these queries:
# CREATE USER '${escaped_user}'@'localhost' IDENTIFIED VIA mysql_native_password USING '${escaped_password}'; \
# GRANT USAGE ON *.* TO '${escaped_user}'@'localhost' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0; \
# CREATE DATABASE IF NOT EXISTS `${escaped_user}`; \
# GRANT ALL PRIVILEGES ON `${escaped_user}\_daemon`.* TO '${escaped_user}'@'localhost';
#
# See also create_mysql_user_and_database_and_grant_privileges
#
# Params:
#   1 - SQL username (which will also be chosen to be the name of the database)
#   2 - password
# Return's:
#   1 if any of the mysql-queries failed
#######################################
create_mysql_user_and_same_name_database_and_grant_privileges(){
  create_mysql_user_and_database_and_grant_privileges "$1" "$2" "$1"
}


#######################################
# Inspired by the option "Grant all rights to databases starting with the user name (username\_%)." when creating a new user phpMyAdmin, which produces these queries:
# CREATE USER '${escaped_user}'@'localhost' IDENTIFIED VIA mysql_native_password USING '${escaped_password}';
# GRANT USAGE ON *.* TO '${escaped_user}'@'localhost' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
# GRANT ALL PRIVILEGES ON `${escaped_user}\_%`.* TO '${escaped_user}'@'localhost';
#
# Params:
#   1 - SQL username
#   2 - password
# Return's:
#   1 if any of the mysql-queries failed
#######################################
create_mysql_user_and_grant_him_privileges_on_databases_starting_with_his_name(){
  log_info "= Create SQL-User '$1' + Grant ALL privileges on Databases starting with his name."
  local -r user="$1"
  local escaped_user="${user//\'/\\\'}" # Escape "'"
  local -r password="$2"
  local -r database="$user"
  local escaped_database="${database//\'/\\\'}" # Escape "'"

  create_mysql_user "$user" "$password" || return 1

  grant_all_usage_without_restrictions "$user" || return 1

  log_info "== Granting user '${escaped_user}' ALL privileges on Databases starting with his name..."
  query_mysql "GRANT ALL PRIVILEGES ON \`${escaped_database}\_%\`.* TO '${escaped_user}'@'localhost';" |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) || return 1
}