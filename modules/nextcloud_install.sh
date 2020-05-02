#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized
source_utils "lamp"
source_utils "file"

export NC_DEFAULT_INSTALL_DIR="/var/lib/nextcloud"
export NC_DIR_TO_INSTALL_IN="${NC_DEFAULT_INSTALL_DIR}"
export NC_DEFAULT_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS="nextcloud"
export NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS="${NC_DEFAULT_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}"

# As described in https://docs.nextcloud.com/server/18/admin_manual/installation/source_installation.html#prerequisites-for-manual-installation
install_packages(){
  log_info "= Start install prerequisites for manual NextCloud-Installation"

  # Note:
  # "php-simplexml php-xmlreader php-xmlwriter php-dom" are bundled in "php7.3-xml" (https://packages.debian.org/buster/php7.3-xml)
  # "php-iconv php-posix php-ctype php-fileinfo"  are bundled in "php7.3-common" (https://packages.debian.org/buster/php7.3-common)
  log_info "== Installing Required PHP-Modules..."
  apt_get_without_interaction "install" "php-curl php-gd php-json php-mbstring php-xml php-zip" | log_debug_output

  # Note: "php-exif" (for image rotation in pictures app) is already bundled in "php7.3-common" (https://packages.debian.org/buster/php7.3-common)
  # bz2: recommended, required for extraction of apps
  # intl: recommended, increases language translation performance and fixes sorting of non-ASCII characters
  # apcu: Alternative PHP Cache for increased perfomance
  log_info "== Installing Recommended PHP-Modules..."
  apt_get_without_interaction "install" "php-bz2 php-intl php-apcu" | log_debug_output

  log_info "== Installing additional Packages used for preview generation..."
  apt_get_without_interaction "install" "php-imagick ffmpeg libreoffice" | log_debug_output
}

ask_installation_directory() {
  log_info "= Ask for empty directory to install NextCloud in... "
  dialog --backtitle "${SCRIPT_NAME}" --title "Choose Destination-Folder of NextCloud Installation. (Needs to be empty)" \
        --fselect "${NC_DEFAULT_INSTALL_DIR}" 10 0 0 \
        2>"${TEMP_DIR}/nextcloud_install-install_location.choice"
  NC_DIR_TO_INSTALL_IN=$(cat "${TEMP_DIR}/nextcloud_install-install_location.choice")

  if [[ -d "${NC_DIR_TO_INSTALL_IN}" ]]; then
    # Check if directory is empty if it exists..
    if [[ "$(ls -A "${NC_DIR_TO_INSTALL_IN}")" ]]; then
      log_error "== Chosen directory '${NC_DIR_TO_INSTALL_IN}' is not empty! Please press enter to re-choose..."
      read -p "(Press Enter...)"

      # Keep asking until user chose a path that is a directory which also is empty
      NC_DIR_TO_INSTALL_IN="${NC_DEFAULT_INSTALL_DIR}"
      ask_installation_directory
    fi
  else
    # Directory doesnt exist. Create and move on..
    mkdir -p "${NC_DIR_TO_INSTALL_IN}" | log_debug_output
  fi
}

ask_apache_name_to_serve_as() {
  log_info "= Ask for name of apache-conf... "
  # Keep asking until user chose a name that doesn't already exists as an apache-conf-file
  while [[ -z "${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}" ]] \
        || [[ -f "/etc/apache2/conf-available/${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf" ]]; do
    dialog --backtitle "${SCRIPT_NAME}" --title "Provide a name to serve the installation as in apache." \
          --inputbox "" 0 0 "${SQL_SERVER_ADMIN_MAINTENANCE_USERNAME}" \
          2>"${TEMP_DIR}/nextcloud_install-apache_conf_name.choice"
    NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS=$(cat "${TEMP_DIR}/nextcloud_install-apache_conf_name.choice")
  done
}

configure_apache(){
  log_info "= Start Configure Apache2"

  # Configuring Apache to Serve phpMyAdmin
  log_info "== Generating apache2-Configuration to serve NextCloud in '/etc/apache2/conf-available/${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf'..."
  cat << EOF > "/etc/apache2/conf-available/${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf"
# See https://docs.nextcloud.com/server/18/admin_manual/installation/source_installation.html#apache-web-server-configuration
Alias /${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS} ${NC_DIR_TO_INSTALL_IN}

<Directory ${NC_DIR_TO_INSTALL_IN}/>
  Require all granted
  AllowOverride All
  Options FollowSymLinks MultiViews
  # Make sure server-configured authentication is disabled for nextcloud
  Satisfy Any

  <IfModule mod_dav.c>
    Dav off
  </IfModule>

</Directory>
EOF

  log_info "=== Enabling apache2-conf ${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf..."
  a2enconf "${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf" | log_debug_output

  log_info "== Generating apache2-site configuration in '/etc/apache2/sites-available/${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf'..."
  local -r assumed_dnsdomainname="$(dnsdomainname)"
  local -r assumed_fqdn="${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.${assumed_dnsdomainname}"
  cat << EOF > "/etc/apache2/sites-available/${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf"
# See See https://docs.nextcloud.com/server/18/admin_manual/installation/harden_server.html#use-a-dedicated-domain-for-nextcloud
# "Use a dedicated domain for Nextcloud to gain all the benefits offered by the Same-Origin-Policy."

# Always redirect traffic to HTTPS
<VirtualHost *:80>
        ServerName ${assumed_fqdn}
        Redirect permanent / https://${assumed_fqdn}/
</VirtualHost>

<IfModule mod_ssl.c>
<VirtualHost *:443>
#        ServerAdmin webmaster@localhost
        DocumentRoot /var/lib/nextcloud

        ErrorLog \${APACHE_LOG_DIR}/nextcloud-error.log
        CustomLog \${APACHE_LOG_DIR}/nextcloud-access.log combined

        # Enable HTTP's Strict Transport Security - https://docs.nextcloud.com/server/18/admin_manual/installation/harden_server.html#enable-http-strict-transport-security
        <IfModule mod_headers.c>
                Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains"
        </IfModule>

        ServerName ${assumed_fqdn}
        SSLCertificateFile /etc/letsencrypt/live/${assumed_fqdn}/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/${assumed_fqdn}/privkey.pem
        Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
</IfModule>
EOF

  log_info "*** "
  log_info "*** The generated apache2 site-configuration does x things: Redirect HTTP to HTTPS, Enabling Strict-Transport-Security, Create separate log-files and - most important of all - define the DocumentRoot and Path-To-Certificates for the specified ServerName."
  log_info "*** The generator assumed that: "
  log_info "*** - The certificate was created by LetsEncrypt's Certbot and is active. If that's not the case, please also change the SSL-Settings underneath the option ServerName."
  log_info "*** - The FQDN for this nextcloud-instance is '${assumed_fqdn}'. If that's not the case, please also change all occurrences of it with the actual domain (that points to the server)."
  log_info "*** "
  read -p "Press enter to open the editor '${EDITOR:-nano}' to edit '/etc/apache2/sites-available/${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf' (Installation will continue after saving)..."
  "${EDITOR:-nano}"  "/etc/apache2/sites-available/${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf"

  log_info "=== Enabling apache2-site ${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf..."
  a2ensite "${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}.conf" | log_debug_output

  # https://docs.nextcloud.com/server/18/admin_manual/installation/source_installation.html#additional-apache-configurations
  log_info "== Enabling required apache2-module 'rewrite'..."
  a2enmod rewrite

  log_info "== Enabling recommended apache2-modules..."
  a2enmod headers | log_debug_output
  a2enmod env | log_debug_output
  a2enmod dir | log_debug_output
  a2enmod mime | log_debug_output

  log_info "== Restarting apache2 to take affect of the changes made..."
  systemctl reload apache2 | log_debug_output
}

download_and_install_nextcloud(){
  # See https://docs.nextcloud.com/server/18/admin_manual/installation/example_ubuntu.html#example-installation-on-ubuntu-18-04-lts
  log_info "= Start actual installation of NextCloud in '${NC_DIR_TO_INSTALL_IN}'"
  log_info "== Downloading the official nextcloud-zip, including its MD5-Checksum and PGP-Signature to '${TEMP_DIR}'..."
  wget "https://download.nextcloud.com/server/releases/nextcloud-18.0.4.zip" \
        --output-document "${TEMP_DIR}nextcloud-18.0.4.zip" | log_debug_output
  wget "https://download.nextcloud.com/server/releases/nextcloud-18.0.4.zip.md5" \
        --output-document "${TEMP_DIR}nextcloud-18.0.4.zip.md5" | log_debug_output
  wget "https://download.nextcloud.com/server/releases/nextcloud-18.0.4.zip.asc" \
        --output-document "${TEMP_DIR}nextcloud-18.0.4.zip.asc" | log_debug_output

  wget "https://nextcloud.com/nextcloud.asc" \
      --output-document "${TEMP_DIR}nextcloud.asc" | log_debug_output

  log_info "=== Verifying checksum..."
  cd "${TEMP_DIR}"
  md5sum -c "nextcloud-18.0.4.zip.md5" < "nextcloud-18.0.4.zip" | log_debug_output
  cd "${SCRIPT_DIR}"

  log_info "=== Comparing PGP-Signature..."
  cd "${TEMP_DIR}"
  gpg --import "nextcloud.asc" | log_debug_output
  gpg --verify "nextcloud-18.0.4.zip.asc" \
               "nextcloud-18.0.4.zip" | log_debug_output
  cd "${SCRIPT_DIR}"

  # The actual zip always contains one directory named 'nextcloud'. We want to extract everything from that.
  log_info "=== Everything OK! Unzipping actual package into '${NC_DIR_TO_INSTALL_IN}'..."
  unzip "${TEMP_DIR}nextcloud-18.0.4.zip" 'nextcloud/*' -d "${NC_DIR_TO_INSTALL_IN}" | log_debug_output
  mv "${NC_DIR_TO_INSTALL_IN}/nextcloud/"* "${NC_DIR_TO_INSTALL_IN}/"
  rm -r "${NC_DIR_TO_INSTALL_IN}/nextcloud"

  log_info "=== Chown'ing directory '${NC_DIR_TO_INSTALL_IN}' to www-data"
  chown -R www-data:www-data "${NC_DIR_TO_INSTALL_IN}"

  log_info "*** "
  log_info "*** Please perform intial web-based setup. (Located at 'your.ip.or.name/${NC_APACHE_CONF_NAME_TO_SERVE_INSTALLATION_AS}')"
  log_info "*** "

  # TODO maybe perform setup here using occ?
  # TODO maybe install extensions i use everywhere here using occ?
}

call_module(){
  lamp_install
  install_packages

  ask_installation_directory
  ask_apache_name_to_serve_as
  configure_apache
  # TODO automatically configure pretty URLs? https://docs.nextcloud.com/server/18/admin_manual/installation/source_installation.html#pretty-urls

  download_and_install_nextcloud
}