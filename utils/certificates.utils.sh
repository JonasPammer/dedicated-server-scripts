#!/bin/bash
#
# @author (Most parts copied from my version of installimage, which was in-turn originally written by Hetzner)
#
set -eo pipefail
check_is_utils_initialized
source_utils "randomization"
source_utils "mysql"

#######################################
# Returns:
#   1 if anything went wrong
#######################################
regenerate_webmin_miniserv_ssl_certificate() {
  log_info "== Removing existing webmin-miniserv-certificate..."
  local -r webmin_miniserv_ssl_certificate="/etc/webmin/miniserv.pem"
  if [[ -e "$webmin_miniserv_ssl_certificate" ]]; then
    rm "$webmin_miniserv_ssl_certificate" || return 1
  fi

  log_info "== Regenerating webmin-miniserv-certificate"
  openssl req -days 1825 -keyout "$webmin_miniserv_ssl_certificate" \
    -newkey rsa:2048 -nodes -out "$webmin_miniserv_ssl_certificate" -sha256 \
    -subj "/CN=*/emailAddress=${USER}@$(hostname)/O=Webmin Webserver on $(hostname)" \
    -x509 |& log_debug_output
  (("${PIPESTATUS[0]}" == 0)) && [[ -e "$webmin_miniserv_ssl_certificate" ]]
}

#######################################
# Steps from https://www.thomas-krenn.com/de/wiki/Ubuntu_default_snakeoil_SSL-Zertifikat_erneuern#Default_SSL-Zertifikat_erneuern
# You need to restart the apache2-service for the cert to take affect!
# Also see `enable_default_ssl_configuration`
#
# Returns:
#   1 if anything went wrong
#######################################
regenerate_snakeoil_ssl_certificate() {
  log_info "== Removing existing snakeoil-ssl-certificate..."
  local -r path_to_certificate="/etc/ssl/certs/ssl-cert-snakeoil.pem"
  local -r path_to_key="/etc/ssl/private/ssl-cert-snakeoil.key"

  if [[ -e "$path_to_certificate" ]]; then
    rm "$path_to_certificate" || return 1;
  fi
  if [[ -e "$path_to_key" ]]; then
    rm "$path_to_key" || return 1;
  fi

  log_info "== Regenerating snakeoil-ssl-certificate..."
  DEBIAN_FRONTEND=noninteractive make-ssl-cert generate-default-snakeoil || return 1
  [[ -e "$path_to_certificate" ]] && [[ -e "$path_to_key" ]]
}

enable_default_ssl_configuration() {
  a2enmod ssl
  a2ensite default-ssl.conf
  systemctl reload apache2
}