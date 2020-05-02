#!/bin/bash
#
# @author PixelTutorials
# TODO untested
#
set -eo pipefail
check_is_utils_initialized

call_module() {
  log_info "= Start Install/Configure NetData"

  log_info "== Installing netdata using its kickstart-script as described on https://learn.netdata.cloud/#installation ..."
  bash <(curl -Ss https://my-netdata.io/kickstart.sh) --stable-channel --disable-telemetry

  log_info "== Setup UFW if installed"
  if hash ufw 2>/dev/null; then
    log_info "=== Allowing port 1999 using UFW..."
    ufw allow 19999
  else
    log_error "=== ufw command not found. Skipping this step..."
  fi


  log_info "== Generating apache2-site configuration in '/etc/apache2/sites-available/netdata.conf'..."
  local -r assumed_dnsdomainname="$(dnsdomainname)"
  local -r assumed_fqdn="netdata.${assumed_dnsdomainname}"
  cat << EOF > "/etc/apache2/sites-available/netdata.conf"
 See https://github.com/netdata/netdata/blob/master/docs/Running-behind-apache.md#netdata-on-a-dedicated-virtual-host
<VirtualHost *:80>
        ServerName ${assumed_fqdn}
        Redirect permanent / https://${assumed_fqdn}/
</VirtualHost>

<VirtualHost *:443>
        RewriteEngine On
        ProxyRequests Off
        ProxyPreserveHost On

        <Proxy *>
                Require all granted
        </Proxy>

        ProxyPass "/" "http://localhost:19999/" connectiontimeout=5 timeout=30 keepalive=on
        ProxyPassReverse "/" "http://localhost:19999/"

        ErrorLog \${APACHE_LOG_DIR}/netdata-error.log
        CustomLog \${APACHE_LOG_DIR}/netdata-access.log combined

        ServerName ${assumed_fqdn}
        SSLCertificateFile /etc/letsencrypt/live/${assumed_fqdn}/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/${assumed_fqdn}/privkey.pem
        Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
EOF

  log_info "*** "
  log_info "*** The generated apache2 site-configuration does x things: Redirect HTTP to HTTPS, Create separate log-files and - most important of all - define the Proxy and Path-To-Certificates for the specified ServerName."
  log_info "*** The generator assumed that: "
  log_info "*** - The certificate was created by LetsEncrypt's Certbot and is active. If that's not the case, please also change the 'SSL'-Settings."
  log_info "*** - The FQDN for this netdata-instance is '${assumed_fqdn}'. If that's not the case, please also change all occurrences of it with the actual domain (that points to the server)."
  log_info "*** "
  read -p "Press enter to open the editor '${EDITOR:-nano}' to edit '/etc/apache2/sites-available/netdata.conf' (Installation will continue after saving)..."
  "${EDITOR:-nano}"  "/etc/apache2/sites-available/netdata.conf"

  log_info "=== Enabling apache2-site netdata.conf..."
  a2ensite "netdata.conf" | log_debug_output
}