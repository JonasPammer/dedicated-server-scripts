#!/bin/bash
#
# @author PixelTutorials
# Installs Apache2, MariaDB-Server, PHP (and some recommended extensions) from the default Debian-Buster repository
# Downloads PHPMyAdmin from the official Website,
# dynamically generates its config.inc.php (including pma/blowfish-secrets),
# dynamically generates a .htaccess and .htpasswd (including password)
#

set -eo pipefail
check_is_utils_initialized
source_utils "mysql"
source_utils "randomization"
source_utils "certificates"

PHPMYADMIN_VERSION_TO_INSTALL="4.9.5"

install_lamp(){
  log_info "= Start installation of Apache2, MariaDB-Server, PHP(+extensions) from the default Debian-Buster repository"
  log_info "== (Unattended) Installing Apache2..."
  apt_get_without_interaction "install" "apache2" | log_debug_output

  log_info "== (Unattended) Installing MariaDB-Server..."
  apt_get_without_interaction "install" "mariadb-server" | log_debug_output

  log_info "== (Unattended) Installing PHP, including it's mods for apache2 and mysql..."
  apt_get_without_interaction "install" "php libapache2-mod-php php-mysql php-pdo-sqlite" | log_debug_output

  log_info "== Reloading Apache2..."
  sudo systemctl reload apache2 | log_debug_output
  sudo systemctl status apache2 | log_debug_output

  log_info "= Start installation/configuration of PHPMyAdmin"
  log_info "== (Unattended) Installing recommended PHP extensions for PHPMyAdmin..."
  apt_get_without_interaction "install" "php-mbstring php-zip php-gd php-cgi php-mysqli php-pear php-gettext php-common php-phpseclib" | log_debug_output

  log_info "== Making sure 'mcrypt' and 'mbstring'-modules are enabled"
  phpenmod mcrypt
  phpenmod mbstring
}

check_if_sql_admin_maintenance_user_exists_and_create(){
  log_info "== Checking if SQL-User '${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}' exists (${_SQL_SERVER_ADMIN_MAINTENANCE_USERNAME_COMMENT})..."
  if ! does_mysql_user_exist "${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}"; then
    log_info "*** SQL-User '${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}' does not exist!"
    while true; do
      read -s -p "*** Please enter a password for the SQL-User '${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}': " given_password
      echo
      read -s -p "*** Please enter a password for the SQL-User '${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}' (again): " given_password2
      echo

      if [[ "$given_password" = "$given_password2" ]]; then
        create_mysql_user_with_all_privileges "${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}" "${given_password}"
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
  regenerate_snakeoil_ssl_certificate | log_debug_output
  log_info "= Enable Default SSL Apache2-Configuration which uses our (invalid - self generated) \"snakeoil\"-ssl-certificate"
  enable_default_ssl_configuration | log_debug_output
}

install_and_dynamically_configure_phpmyadmin() {
  log_info "= Start installation and configuration of PHPMyAdminb v${PHPMYADMIN_VERSION_TO_INSTALL}"
  log_info "== Downloading 'phpMyAdmin-${PHPMYADMIN_VERSION_TO_INSTALL}-all-languages.tar.gz'..."
  wget -O "${TEMP_DIR}phpMyAdmin-${PHPMYADMIN_VERSION_TO_INSTALL}-all-languages.tar.gz" \
          "https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION_TO_INSTALL}/phpMyAdmin-${PHPMYADMIN_VERSION_TO_INSTALL}-all-languages.tar.gz" | log_debug_output

  log_info "== Extracting '${TEMP_DIR}phpMyAdmin-${PHPMYADMIN_VERSION_TO_INSTALL}-all-languages.tar.gz'..."
  tar xf "${TEMP_DIR}phpMyAdmin-${PHPMYADMIN_VERSION_TO_INSTALL}-all-languages.tar.gz" -C "${TEMP_DIR}" | log_debug_output

  if [[ -e "/usr/share/phpmyadmin" ]]; then
    log_error "/usr/share/phpmyadmin already exists! Move extracted folder anyways (Configuration will be lost!)? [Y/n]"
    read -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      return 0 # exit to mainmenu
    fi
    cp -r "/usr/share/phpmyadmin" "/usr/share/phpmyadmin-bak"
    rm -rf "/usr/share/phpmyadmin"
  fi

  log_info "== Moving extracted folder to '/usr/share/phpmyadmin'..."
  sudo mv -f "${TEMP_DIR}phpMyAdmin-${PHPMYADMIN_VERSION_TO_INSTALL}-all-languages/" /usr/share/phpmyadmin

  log_info "== Making directory '/var/lib/phpmyadmin/tmp' and setting 'www-data' as the owner (group and user)..."
  mkdir -p /var/lib/phpmyadmin/tmp
  chown -R www-data:www-data /var/lib/phpmyadmin

  local -r generated_blowfish_secret="$(generate_password 32)"
  local -r generated_pma_pw="$(generate_password 16)"

  log_info "== Generating phpMyAdmin-Configuration at '/usr/share/phpmyadmin/config.inc.php'..."
cat << EOF > /usr/share/phpmyadmin/config.inc.php
<?php
/* vim: set expandtab sw=4 ts=4 sts=4: */

//
// DYNAMICALLY GENERATED BY ${SCRIPT_NAME} on $(date)
// (Used config-example shipped with v4.9.5 as a base.)
//

/**
 * phpMyAdmin sample configuration, you can use it as base for
 * manual configuration. For easier setup you can use setup/
 *
 * All directives are explained in documentation in the doc/ folder
 * or at <https://docs.phpmyadmin.net/>.
 *
 * @package PhpMyAdmin
 */

/**
 * This is needed for cookie based authentication to encrypt password in
 * cookie. Needs to be 32 chars long.
 */
/** UNCOMMENTED BY ${SCRIPT_NAME}
 * (Password was dynamically generated)
 */
\$cfg['blowfish_secret'] = '${generated_blowfish_secret}'; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */

/**
 * Servers configuration
 */
\$i = 0;

/**
 * First server
 */
\$i++;
/* Authentication type */
\$cfg['Servers'][\$i]['auth_type'] = 'cookie';
/* Server parameters */
\$cfg['Servers'][\$i]['host'] = 'localhost';
\$cfg['Servers'][\$i]['compress'] = false;
\$cfg['Servers'][\$i]['AllowNoPassword'] = false;
/** ADDED BY | SET TO FALSE BY ${SCRIPT_NAME}
 * SQL-User "${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}" should be used to do remote maintenance!
 */
\$cfg['Servers'][\$i]['AllowRoot'] = FALSE;

/**
 * phpMyAdmin configuration storage settings.
 */

/* User used to manipulate with storage */
// \$cfg['Servers'][\$i]['controlhost'] = '';
// \$cfg['Servers'][\$i]['controlport'] = '';

/** UNCOMMENTED BY ${SCRIPT_NAME}
 * (Password was dynamically generated)
 */
\$cfg['Servers'][\$i]['controluser'] = 'pma';
\$cfg['Servers'][\$i]['controlpass'] = '${generated_pma_pw}';

/* Storage database and tables */
/** UNCOMMENTED BY ${SCRIPT_NAME}
 * This section includes a number of directives that define the phpMyAdmin configuration storage, a database and several tables used by the administrative pma database user.
 * These tables enable a number of features in phpMyAdmin, including Bookmarks, comments, PDF generation, and more.
 */
\$cfg['Servers'][\$i]['pmadb'] = 'phpmyadmin';
\$cfg['Servers'][\$i]['bookmarktable'] = 'pma__bookmark';
\$cfg['Servers'][\$i]['relation'] = 'pma__relation';
\$cfg['Servers'][\$i]['table_info'] = 'pma__table_info';
\$cfg['Servers'][\$i]['table_coords'] = 'pma__table_coords';
\$cfg['Servers'][\$i]['pdf_pages'] = 'pma__pdf_pages';
\$cfg['Servers'][\$i]['column_info'] = 'pma__column_info';
\$cfg['Servers'][\$i]['history'] = 'pma__history';
\$cfg['Servers'][\$i]['table_uiprefs'] = 'pma__table_uiprefs';
\$cfg['Servers'][\$i]['tracking'] = 'pma__tracking';
\$cfg['Servers'][\$i]['userconfig'] = 'pma__userconfig';
\$cfg['Servers'][\$i]['recent'] = 'pma__recent';
\$cfg['Servers'][\$i]['favorite'] = 'pma__favorite';
\$cfg['Servers'][\$i]['users'] = 'pma__users';
\$cfg['Servers'][\$i]['usergroups'] = 'pma__usergroups';
\$cfg['Servers'][\$i]['navigationhiding'] = 'pma__navigationhiding';
\$cfg['Servers'][\$i]['savedsearches'] = 'pma__savedsearches';
\$cfg['Servers'][\$i]['central_columns'] = 'pma__central_columns';
\$cfg['Servers'][\$i]['designer_settings'] = 'pma__designer_settings';
\$cfg['Servers'][\$i]['export_templates'] = 'pma__export_templates';

/**
 * End of servers configuration
 */

/**
 * Directories for saving/loading files from server
 */
\$cfg['UploadDir'] = '';
\$cfg['SaveDir'] = '';

/**
 * Whether to display icons or text or both icons and text in table row
 * action segment. Value can be either of 'icons', 'text' or 'both'.
 * default = 'both'
 */
//\$cfg['RowActionType'] = 'icons';

/**
 * Defines whether a user should be displayed a "show all (records)"
 * button in browse mode or not.
 * default = false
 */
//\$cfg['ShowAll'] = true;

/**
 * Number of rows displayed when browsing a result set. If the result
 * set contains more rows, "Previous" and "Next".
 * Possible values: 25, 50, 100, 250, 500
 * default = 25
 */
//\$cfg['MaxRows'] = 50;

/**
 * Disallow editing of binary fields
 * valid values are:
 *   false    allow editing
 *   'blob'   allow editing except for BLOB fields
 *   'noblob' disallow editing except for BLOB fields
 *   'all'    disallow editing
 * default = 'blob'
 */
//\$cfg['ProtectBinary'] = false;

/**
 * Default language to use, if not browser-defined or user-defined
 * (you find all languages in the locale folder)
 * uncomment the desired line:
 * default = 'en'
 */
//\$cfg['DefaultLang'] = 'en';
//\$cfg['DefaultLang'] = 'de';

/**
 * How many columns should be used for table display of a database?
 * (a value larger than 1 results in some information being hidden)
 * default = 1
 */
//\$cfg['PropertiesNumColumns'] = 2;

/**
 * Set to true if you want DB-based query history.If false, this utilizes
 * JS-routines to display query history (lost by window close)
 *
 * This requires configuration storage enabled, see above.
 * default = false
 */
//\$cfg['QueryHistoryDB'] = true;

/**
 * When using DB-based query history, how many entries should be kept?
 * default = 25
 */
//\$cfg['QueryHistoryMax'] = 100;

/**
 * Whether or not to query the user before sending the error report to
 * the phpMyAdmin team when a JavaScript error occurs
 *
 * Available options
 * ('ask' | 'always' | 'never')
 * default = 'ask'
 */
//\$cfg['SendErrorReports'] = 'always';

/**
 * You can find more configuration options in the documentation
 * in the doc/ folder or at <https://docs.phpmyadmin.net/>.
 */


/* ADDED BY ${SCRIPT_NAME} */
\$cfg['TempDir'] = '/var/lib/phpmyadmin/tmp';
EOF

  # This SQL file contains all the commands needed to create the configuration storage database and tables phpMyAdmin needs to function correctly.
  start_mysql_if_stopped_and_wait
  log_info "== Executing SQL-Queries from '/usr/share/phpmyadmin/sql/create_tables.sql'..."
  sudo mariadb < /usr/share/phpmyadmin/sql/create_tables.sql

  log_info "== Dropping and Creating SQL-User 'pma' with all privileges..."
  query_mysql "DROP USER 'pma'@'localhost';" || true
  create_mysql_user_with_all_privileges "pma" "${generated_pma_pw}"

  # Configuring Apache to Serve phpMyAdmin
  log_info "== Generating apache2-Configuration to serve phpMyAdmin in '/etc/apache2/conf-available/phpmyadmin.conf'..."

cat << EOF > /etc/apache2/conf-available/phpmyadmin.conf
# phpMyAdmin default Apache configuration (Copied from Ubuntu)
Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php
    # Added by ${SCRIPT_NAME} (Enable the use of .htaccess file overrides):
    AllowOverride All

    <IfModule mod_php5.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>
    <IfModule mod_php.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>

</Directory>

# Authorize for setup
<Directory /usr/share/phpmyadmin/setup>
    <IfModule mod_authz_core.c>
        <IfModule mod_authn_file.c>
            AuthType Basic
            AuthName "phpMyAdmin Setup"
            AuthUserFile /etc/phpmyadmin/htpasswd.setup
        </IfModule>
        Require valid-user
    </IfModule>
</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>
EOF

  log_info "== Generating custom .htaccess '/usr/share/phpmyadmin/.htaccess'..."
  local -r generated_htaccess_file="$(generate_password 16)"

cat << EOF > /usr/share/phpmyadmin/.htaccess
AuthType Basic
AuthName "Restricted Access"
AuthUserFile /usr/share/phpmyadmin/.htpasswd
Require valid-user
EOF

  log_info "== Generating .htpasswd '/usr/share/phpmyadmin/.htpasswd'..."
  echo "*** Generated password: ${generated_htaccess_file}"
  log_info "PLEASE NOTE/WRITE/REMEMBER THE ABOVE MENTIONED PASSWORD! Username is 'phpmyadmin'."
  read -p "Press Enter to continue..."
  echo "${generated_htaccess_file}" | htpasswd -ic /usr/share/phpmyadmin/.htpasswd phpmyadmin

  log_info "= Enabling phpmyadmin.conf and reloading apache to take immediate effect of changes made..."
  a2enconf phpmyadmin.conf | log_debug_output
  systemctl reload apache2 | log_debug_output
}

# Original Steps from https://www.digitalocean.com/community/tutorials/how-to-install-phpmyadmin-from-source-debian-10#step-4-—-securing-your-phpmyadmin-instance (Additionally recommended packages for phpMyAdmin from https://computingforgeeks.com/install-phpmyadmin-with-apache-on-debian-10-buster/)
# (Converted into my script as an semi-automatic procedure)
call_module(){
  install_lamp
  check_if_sql_admin_maintenance_user_exists_and_create
  ask_to_enable_default_https

  install_and_dynamically_configure_phpmyadmin
}