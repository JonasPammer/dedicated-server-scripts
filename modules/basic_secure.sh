#!/bin/bash
#
# Automatically installs UFW and Fail2Ban.
# UFW gets configures to always allow some basic ports (22, 80, 443, 10000) and to allow outgoing-packets on default.
# Both managers are then imminently being enabled
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized

call_module(){
  install_ufw
  setup_ufw
  install_fail2ban
}

install_ufw() {
  log_info "= Install UFW"
  log_info "== (Unattended) Installing UFW from the default Debian-Buster repository..."
  apt_get_without_interaction "install" "ufw" | log_debug_output
}

setup_ufw(){
  log_info "= Setup UFW"
  log_info "== Allowing Basic Ports (22/tcp, 80, 443/tcp, 10000/tcp)..."
  ufw allow "OpenSSH" | log_debug_output # 22/tcp (SSH)
  ufw allow "WWW Full" | log_debug_output # 80 (HTTP), 443/tcp (HTTPS)
  ufw allow "10000/tcp" | log_debug_output # Webmin

  log_info "== Setting default 'outgoing'-rule to 'allow'..."
  ufw default allow outgoing | log_debug_output

  log_info "== Force-Enabling UFW..."
  ufw --force enable
}

install_fail2ban() {
  log_info "= Install, auto-enable and start Fail2Ban"
  log_info "== (Unattended) Installing Fail2Ban from the default Debian-Buster repository..."
  apt_get_without_interaction "install" "fail2ban" | log_debug_output

  log_info "== Enabling & Starting Fail2Ban..."
  systemctl enable fail2ban | log_debug_output
  systemctl start fail2ban | log_debug_output
}