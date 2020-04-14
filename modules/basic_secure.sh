#!/bin/bash
#
# Automatically installs UFW and Fail2Ban.
# UFW gets configures to always allow some basic ports (22, 80, 443, 10000) and to allow outgoing-packets on default.
# Both managers are then imminently being enabled
#
# @author PixelTutorials
#

source "${SCRIPT_DIR}/utils.sh"
set -eo pipefail
check_is_utils_initialized

call_module(){
  install_ufw
  setup_ufw
  install_fail2ban
}

install_ufw() {
  log_info "== Install UFW"
  apt_get_without_interaction "install" "ufw" | log_debug_output
}

setup_ufw(){
  log_info "== Allowing Basic Ports (22, 80, 443, 10000)"
  ufw allow 22 | log_debug_output # SSH (and therefore also SFTP)
  ufw allow 80 | log_debug_output # HTTP
  ufw allow 443 | log_debug_output # HTTPS
  ufw allow 10000 | log_debug_output # Webmin

  log_info "== Set default 'outgoing'-rule to 'allow'"
  ufw default allow outgoing | log_debug_output
}

install_fail2ban() {
  log_info "== Install Fail2Ban"
  apt_get_without_interaction "install" "fail2ban" | log_debug_output

  log_info "== Enable & Start Fail2Ban"
  systemctl enable fail2ban | log_debug_output
  systemctl start fail2ban | log_debug_output
}