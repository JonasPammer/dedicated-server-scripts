#!/bin/bash
source "${SCRIPT_DIR}/utils.sh"
check_is_utils_initialized


log_info "== Install UFW"
apt_get_without_interaction "install" "ufw" | log_debug_output

log_info "== Allowing Basic Ports (22, 80, 443, 10000)"
ufw allow 22 | log_debug_output # SSH (and therefore also SFTP)
ufw allow 80 | log_debug_output # HTTP
ufw allow 443 | log_debug_output # HTTPS
ufw allow 10000 | log_debug_output # Webmin

log_info "== Set default 'outgoing'-rule to 'allow'"
ufw default allow outgoing | log_debug_output

log_info "== Install Fail2Ban"
apt_get_without_interaction "install" "fail2ban" | log_debug_output

log_info "== Enable & Start Fail2Ban"
systemctl enable fail2ban | log_debug_output
systemctl start fail2ban | log_debug_output