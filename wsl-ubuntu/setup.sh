#!/bin/bash
#==============================================================================
# WSL Ubuntu 24.04 LTS Setup Script
# Version: 1.0.0
#==============================================================================
# Description:
#   This script sets up a comprehensive development environment for
#   Ubuntu 24.04 LTS running on Windows Subsystem for Linux (WSL).
#   It installs and configures common development tools, programming languages,
#   web servers, databases, and security settings.
#
# Usage:
#   bash setup.sh
#
# Prerequisites:
#   - Ubuntu 24.04 LTS on WSL
#   - Internet connection
#   - Sudo privileges
#
# Features:
#   - System updates and package installation
#   - Web server stack (NGINX, PHP, MariaDB)
#   - Development tools (Git, Docker, AWS CLI, etc.)
#   - Programming languages (Python, Node.js, Rust, etc.)
#   - Security hardening for SSH and system services
#   - User environment configuration
#
# Warning:
#   This script makes significant changes to your system.
#   It's recommended to review the script before running
#   and create a backup/snapshot if possible.
#==============================================================================

# Exit script if any command fails
set -e

# Print commands before executing (helpful for debugging)
set -x

# Get current user (the one who sudo'ed)
CURRENT_USER=$(logname || whoami)

# Install steps
TOTAL_STEPS=7
CURRENT_STEP=0

#------------------------------------------------------------------------------
# Helper Functions
#------------------------------------------------------------------------------
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

progress() {
  CURRENT_STEP=$((CURRENT_STEP + 1))
  log "Step ${CURRENT_STEP}/${TOTAL_STEPS}: $1"
}

yes_or_no() {
  while true;
  do
    read -p "$* [y/n]: " yn
    case $yn in
      [Yy]*) return 0 ;;
      [Nn]*) echo "Aborted"; return 1 ;;
    esac
  done
}

check_system_version() {
  # Get Ubuntu version
  local version=$(lsb_release -rs)
  local codename=$(lsb_release -cs)

  # Check if version is supported
  if [[ "${version}" != "24.04" ]]; then
    log "WARNING: This script was designed for Ubuntu 24.04 LTS."
    if ! yes_or_no "Continue anyway? [yn]: "; then
      log "Setup aborted by user."
      exit 1
    fi
  fi

  # Check if running in WSL
  if ! grep -q Microsoft /proc/version; then
    log "WARNING: This script was designed for WSL."
    if ! yes_or_no "Continue anyway? [yn]: "; then
      log "Setup aborted by user."
      exit 1
    fi
  fi
}

check_network() {
  # Test connection to common package repositories
  if ! ping -c 1 -W 2 archive.ubuntu.com &> /dev/null; then
    log "WARNING: Cannot reach Ubuntu repositories."
    if ! yes_or_no "Continue anyway? [yn]: "; then
      log "Setup aborted by user."
      exit 1
    fi
  fi
}

# Set up backup functionality
backup_file() {
  local file="$1"
  local backup_dir="${HOME}/.wsl_setup_backups/$(date +%Y-%m-%d)"

  # Skip if file doesn't exist (prevents errors)
  [[ ! -f "${file}" ]] && return 0

  # Create backup directory with date for organization
  mkdir -p "${backup_dir}"

  # Create backup with timestamp to allow multiple backups of same file
  cp -a "${file}" "${backup_dir}/$(basename ${file}).$(date +%H-%M-%S).bak"
}

#------------------------------------------------------------------------------
# Function: update_system
# Description: Updates and upgrades all system packages to their latest versions
#              Removes unnecessary packages to free up disk space
# Args: None
# Returns: None
#------------------------------------------------------------------------------
update_system() {
  sudo apt-get update -y -q
  sudo apt-get upgrade -y -q
  sudo apt-get dist-upgrade -y -q
  sudo apt-get check -y -q
  sudo apt-get autoremove -y -q
  sudo apt-get autoclean -y -q
}

#------------------------------------------------------------------------------
# Function: install_packages
# Description: Adds repositories and installs all required packages for the
#              development environment, including programming languages, web
#              servers, and command-line tools
# Args: None
# Returns: None
#------------------------------------------------------------------------------
install_packages() {
  sudo install -m 0755 -d /etc/apt/keyrings

  # Basic packages
  sudo apt-get install -y \
    apt-transport-https \
    build-essential bzip2 \
    ca-certificates curl \
    gnupg gpg \
    lsb-release \
    software-properties-common sudo \
    wget

  # Enable 32-bit architecture
  sudo dpkg --add-architecture i386

  # Add PHP repository
  sudo add-apt-repository -y ppa:ondrej/php

  # Adding OpenTofu repository (Terraform alternative)
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://get.opentofu.org/opentofu.gpg \
    | sudo tee /etc/apt/keyrings/opentofu.gpg >/dev/null
  curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey \
    | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null
  sudo chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg
  echo "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" \
    | sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
  sudo chmod a+r /etc/apt/sources.list.d/opentofu.list

  # Add HashiCorp repository
  wget -O - https://apt.releases.hashicorp.com/gpg \
    | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    | sudo tee /etc/apt/sources.list.d/hashicorp.list

  # Add Trivy repository
  wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key  \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
    | sudo tee -a /etc/apt/sources.list.d/trivy.list

  # Add Kubernetes repository
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key \
    | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  # Add IBM repository
  curl https://public.dhe.ibm.com/software/ibmi/products/odbc/debs/dists/1.1.0/ibmi-acs-1.1.0.list \
    | sudo tee /etc/apt/sources.list.d/ibmi-acs.list

  # Set permissions
  sudo chmod a+r /etc/apt/sources.list.d/*.list
  sudo chmod 644 /etc/apt/keyrings/*.gpg

  # Install additional packages
  sudo apt-get update -y -q
  sudo apt-get install -y \
    bat bc bind9-dnsutils \
    clang colordiff command-not-found cowsay cron \
    debsecan debsums default-jdk \
    fd-find fzf \
    git git-crypt git-lfs graphviz \
    htop \
    iftop imagemagick inetutils-telnet iotop ibm-iaccess \
    jc jq \
    kubeadm kubectl kubectx \
    ldap-utils libassuan-dev libclang-dev libgcrypt20-dev libgpg-error-dev libksba-dev libldap-dev libnpth0-dev libpam-tmpdir libpth-dev llvm logwatch linux-tools-generic \
    macchanger mariadb-server maven \
    nano needrestart net-tools nginx nmap ntp \
    odbcinst openssl \
    pciutils perl plocate python3-full python3-dev python3-pip python3-setuptools python3-venv python3-virtualenv php php-{apcu,bcmath,bz2,cgi,cli,common,curl,fpm,gd,gmp,imagick,imap,intl,json,ldap,mbstring,memcached,mysql,odbc,phpdbg,pspell,readline,redis,snmp,soap,sqlite3,sybase,tidy,xml,xmlrpc,zip} phpmyadmin \
    rmlint rsync rustup \
    sysstat scdaemon screen smem socat sqlite3 \
    texlive-full tmux tofu trash-cli tree trivy \
    unixodbc unixodbc-dev unzip unattended-upgrades \
    vim vim-latexsuite vim-syntastic \
    whois \
    zsh zsh-autosuggestions zsh-syntax-highlighting zoxide

  # Install AWS CLI (+ Plugins)
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
  sudo dpkg -i session-manager-plugin.deb
  rm -rf awscliv2.zip aws session-manager-plugin.deb

  # Install TFLint
  curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh \
    | bash

  # Install ZSH Plugins
  sudo mkdir -p /usr/share/zsh-history-substring-search
  sudo wget -O /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh "https://raw.githubusercontent.com/zsh-users/zsh-history-substring-search/refs/heads/master/zsh-history-substring-search.zsh"
}

#------------------------------------------------------------------------------
# Function: enable_system_services
# Description: Enables system services needed for the development environment
#              to start automatically on boot
# Args: None
# Returns: None
#------------------------------------------------------------------------------
enable_system_services() {
  sudo systemctl enable {cron,mariadb,nginx,php8.3-fpm,sysstat}
}

#------------------------------------------------------------------------------
# Function: configure_wsl
# Description: Configures WSL-specific settings to improve integration with
#              Windows and enable systemd support
# Args: None
# Returns: None
#------------------------------------------------------------------------------
configure_wsl() {
  # Create WSL configuration file for better Windows integration
  backup_file /etc/wsl.conf
  cat << EOF | sudo tee /etc/wsl.conf
# Enable systemd (needed for many services like Docker)
[boot]
systemd = true

# Configure automatic mounting of Windows drives
[automount]
enabled = true
options = "metadata,umask=22,fmask=11"
mountFsTab = true

# Windows interop settings
[interop]
enabled = true
# Improves performance by not adding Windows PATH
appendWindowsPath = false

# Disable network override
[network]
generateResolvConf=false

# Default user to log in
[user]
default=${CURRENT_USER}

EOF
}


#------------------------------------------------------------------------------
# System Configuration
#------------------------------------------------------------------------------
configure_system() {
  # Create system folders
  sudo mkdir -p /etc/systemd/system/systemd-logind.service.d \
                /etc/xdg

  # Set timezone
  sudo timedatectl set-timezone Europe/Berlin

  # DNS configuration - using multiple providers for redundancy
  # Google, Cloudflare, and Quad9 provide reliable DNS resolution
  backup_file /etc/resolv.conf
  backup_file /etc/resolv.conf.head
  cat << EOF | sudo tee /etc/resolv.conf.head
# Options
options edns0 single-request-reopen

# Local resolver
nameserver 127.0.0.1

# Google
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844

# Cloudflare
nameserver 1.1.1.1
nameserver 2606:4700:4700::1111

# Quad9
nameserver 9.9.9.9
nameserver 149.112.112.112
nameserver 2620:fe::fe
nameserver 2620:fe::9

EOF
  sudo cp /etc/resolv.conf.head /etc/resolv.conf
  # Protect resolv.conf{.head} from being overwritten
  sudo chmod u=r,g=r,o=r /etc/resolv.conf.head /etc/resolv.conf
  sudo chattr +i /etc/resolv.conf.head /etc/resolv.conf

  # System performance tweaks
  backup_file /etc/sysctl.conf
  cat << EOF | sudo tee /etc/sysctl.conf
# Increase file watch limit for development tools
fs.inotify.max_user_watches=524288

vm.max_map_count = 2147483642

# Reduce swap usage for better performance
vm.swappiness=1

EOF

  # Configure journal
  sudo mkdir -p /etc/systemd/journald.conf.d
  backup_file /etc/systemd/journald.conf.d/00-journal-size.conf
cat << EOF | sudo tee /etc/systemd/journald.conf.d/00-journal-size.conf
[Journal]
SystemMaxUse=100M

EOF

  # Configure sudo
  backup_file /etc/sudoers.d/easteregg
  backup_file /etc/sudoers.d/${CURRENT_USER}
  cat << EOF | sudo tee /etc/sudoers.d/easteregg
# Enable easteregg
Defaults insults

EOF
  cat << EOF | sudo tee /etc/sudoers.d/${CURRENT_USER}
# Enable access for user
${CURRENT_USER} ALL=(ALL) ALL

EOF
  sudo chmod u=rw,g=,o= /etc/sudoers.d/*

  # SSH hardening - disable weak encryption algorithms and mandate key-based auth
  backup_file /etc/ssh/sshd_config.d/custom.conf
  backup_file /etc/ssh/moduli
  cat << EOF | sudo tee /etc/ssh/sshd_config.d/custom.conf
# Settings partially based on:
# https://www.ssh-audit.com/hardening_guides.html#ubuntu_22_04_lts
# https://infosec.mozilla.org/guidelines/openssh.html
LogLevel Verbose
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
PermitRootLogin no
MaxAuthTries 3
MaxSessions 2
PasswordAuthentication no
AuthenticationMethods publickey
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Compression no
ClientAliveInterval 60
Subsystem sftp /usr/lib/openssh/sftp-server -f AUTHPRIV -l INFO
KexAlgorithms -diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group14-sha256,diffie-hellman-group-exchange-sha1,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521
Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com
AllowUsers ${CURRENT_USER} git

EOF
  sudo awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.tmp
  sudo mv /etc/ssh/moduli.tmp /etc/ssh/moduli
  sudo rm /etc/ssh/ssh_host_*
  sudo ssh-keygen -t ed25519 -a 512 -f /etc/ssh/ssh_host_ed25519_key -N "" -C ""
  sudo ssh-keygen -t rsa -b 4096 -a 512 -f /etc/ssh/ssh_host_rsa_key -N "" -C ""

  # Configure MariaDB
  yes_or_no "Do you want to configure MariaDB? [yn]: " && sudo mariadb-secure-installation

  # Configure nginx
  backup_file /etc/nginx/nginx.conf
  backup_file /etc/nginx/sites-available/default
  cat << EOF | sudo tee /etc/nginx/nginx.conf
# Main NGINX configuration file
# This file contains global settings that apply to all virtual hosts

# Run NGINX as the www-data user for security (prevents running as root)
user      www-data;
# Specify where error logs should be written and set the warning level
error_log /var/log/nginx/error.log warn;
# Process ID file location - used for sending signals to the NGINX process
pid       /run/nginx.pid;

# Include additional module configuration files
include /etc/nginx/modules-enabled/*.conf;

# Worker process configuration
# 'auto' automatically detects number of CPU cores and creates one worker per core
worker_processes     auto;
# Set the maximum number of open file descriptors for worker processes
worker_rlimit_nofile 65244;
events {
    # Maximum number of simultaneous connections each worker can handle
    worker_connections 2048;
    # Allow workers to accept multiple connections at once rather than one at a time
    multi_accept       on;
    # Use efficient event processing method (Linux-specific)
    use                epoll;
}

http {
    # Basic Settings
    # Default character encoding for text responses
    charset                utf-8;
    # Enable efficient file transfer using kernel sendfile
    sendfile               on;
    # Optimize TCP packet transmission (only effective with sendfile on)
    tcp_nopush             on;
    # Send data immediately without waiting for packet to fill
    tcp_nodelay            on;
    # Don't log 404 errors to reduce log size
    log_not_found          off;
    # Set maximum size of MIME type hash tables
    types_hash_max_size    2048;
    # Set size of bucket in the types hash tables
    types_hash_bucket_size 64;
    # Maximum allowed size for client request body (512MB allows large file uploads)
    client_max_body_size   512M;

    # Server timeouts (all set to 5 minutes)
    # Time to wait for response to proxy request
    proxy_send_timeout    300;
    # Time to wait for data from proxy server
    proxy_read_timeout    300;
    # Time to wait for response to FastCGI request
    fastcgi_send_timeout  300;
    # Time to wait for data from FastCGI server
    fastcgi_read_timeout  300;
    # Time during which client connections will stay open
    keepalive_timeout     300;
    # Time to wait for client to send request header
    client_header_timeout 300;
    # Time to wait for client to send request body
    client_body_timeout   300;

    # MIME Types configuration
    # Include default MIME type mappings
    include mime.types;
    # Default MIME type if no specific type can be determined
    default_type application/octet-stream;

    # SSL Settings
    # Only use TLSv1.3 (most secure TLS version)
    ssl_protocols             TLSv1.3;
    # Prioritize these elliptic curves for ECDH key exchange
    ssl_ecdh_curve            X25519:prime256v1:secp384r1;
    # Let clients choose the cipher (modern approach)
    ssl_prefer_server_ciphers off;
    # DNS resolvers for OCSP stapling (Google DNS)
    resolver                  8.8.8.8 8.8.4.4 valid=300s;
    # Timeout for DNS resolvers
    resolver_timeout          5s;
    # How long to keep SSL session data
    ssl_session_timeout       1d;
    # Shared cache for SSL session data
    ssl_session_cache         shared:MozSSL:10m;
    # Disable SSL session tickets (security best practice)
    ssl_session_tickets       off;
    # Enable TLS 1.3 0-RTT (reduced latency)
    ssl_early_data            on;
    # Use custom Diffie-Hellman parameters for forward secrecy
    ssl_dhparam               /etc/ssl/dhparam4096.pem;

    # Logging Settings
    # Access log location, format, buffer size and flush interval
    access_log /var/log/nginx/access.log combined buffer=512k flush=1m;
    # Error log location and level
    error_log  /var/log/nginx/error.log warn;

    # Gzip compression settings
    # Enable gzip compression
    gzip              on;
    # Add Vary: Accept-Encoding header to compressed responses
    gzip_vary         on;
    # Compress responses for all request types
    gzip_proxied      any;
    # Compression level (1-9, higher = more compression but more CPU)
    gzip_comp_level   6;
    # Use HTTP/1.1 for compressed responses
    gzip_http_version 1.1;
    # Don't compress files smaller than 256 bytes
    gzip_min_length   256;
    # Disable compression for old IE browsers
    gzip_disable      "MSIE [1-6]\.";
    # File types to compress
    gzip_types        application/atom+xml
                      application/geo+json
                      application/javascript
                      application/x-javascript
                      application/json
                      application/ld+json
                      application/manifest+json
                      application/rdf+xml
                      application/rss+xml
                      application/xhtml+xml
                      application/xml
                      font/eot
                      font/otf
                      font/ttf
                      image/xgf+xml
                      text/css
                      text/javascript
                      text/plain
                      text/xml;

    # Rate Limiting Configuration
    # Define request rate limiting zone (100 requests per second with 32MB memory zone)
    limit_req_zone  \$binary_remote_addr zone=one:32m rate=100r/s;
    # Define connection limiting zone (based on client IP)
    limit_conn_zone \$binary_remote_addr zone=addr:32m;

    # Security settings
    # Hide NGINX version in error pages and response headers
    server_tokens     off;
    # Remove X-Powered-By header from proxied responses
    proxy_hide_header X-Powered-By;
    # Remove Server header from proxied responses
    proxy_hide_header Server;

    # Include additional configuration files
    # Include all config files in conf.d directory
    include /etc/nginx/conf.d/*.conf;
    # Include all enabled site configurations
    include /etc/nginx/sites-enabled/*;
}

EOF
  cat << EOF | sudo tee /etc/nginx/sites-available/default
server {
  # Listen on port 80 for IPv4
  listen 80 default_server;
  # Listen on port 80 for IPv6
  listen [::]:80 default_server;

  # Server name (domain) for this configuration
  server_name localhost;

  # Root directory for serving static files
  root /var/www/html;

  # Default files to serve when directory is requested
  index index.php index.html index.htm;

  # Check if path exists and return 404 otherwise,
  # also disable directory indexing
  location / {
    try_files \$uri \$uri/ =404;
    autoindex off;
  }

  # Security - block access to hidden files
  location ~ /\. {
    deny all;
  }

  # Enable PHP
  location ~ \.php\$ {
    include                      fastcgi.conf;
    include                      snippets/fastcgi-php.conf;
    fastcgi_pass                 unix:/var/run/php/php8.3-fpm.sock;
    fastcgi_buffer_size          128k;
    fastcgi_buffers              256 16k;
    fastcgi_busy_buffers_size    256k;
    fastcgi_temp_file_write_size 256k;
  }
}

EOF
  cat << EOF | sudo tee /var/www/html/index.php
<?php
  phpinfo();
?>

EOF
  sudo rm /var/www/html/index.html /var/www/html/index.nginx-debian.html

  # Configure PHPMyAdmin
  if [[ ! -d /var/www/html/phpmyadmin ]];
  then
    sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
  fi

  # Optimize PHP settings for development environment
  # Increase memory limits for working with large applications
  sudo phpenmod {apcu,bcmath,bz2,curl,gd,gmp,imagick,imap,intl,ldap,mbstring,memcached,odbc,pspell,readline,redis,snmp,soap,sqlite3,tidy,xml,xmlrpc,zip}
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?extension\=iconv.*|extension=iconv|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?opcache\.interned\_strings\_buffer\s*\=.*|opcache.interned_strings_buffer = 64|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?opcache\.save\_comments\s*\=.*|opcache.save_comments = 1|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?opcache\.revalidate\_freq\s*\=.*|opcache.revalidate_freq = 60|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?opcache\.jit\s*\=.*|opcache.jit = 1255|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?opcache\.jit\_buffer\_size\s*\=.*|opcache.jit_buffer_size = 128M|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?max_input_time\s*\=.*|max_input_time = 3600|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?memory\_limit\s*\=.*|memory_limit = 4G|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?post_max_size\s*\=.*|post_max_size = 4G|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?upload\_max\_filesize\s*\=.*|upload_max_filesize = 4G|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?max\_file\_uploads\s*\=.*|max_file_uploads = 100|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?max\_input\_vars\s*\=.*|max_input_vars = 10000|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?session\.cookie\_lifetime\s*\=.*|session.cookie_lifetime = 86400|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?session\.gc\_maxlifetime\s*\=.*|session.gc_maxlifetime = 86400|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?session\.cookie\_httponly\s*\=.*|session.cookie_httponly = 1|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?display\_errors\s*\=.*|display_errors = On|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?allow\_url\_fopen\s*\=.*|allow_url_fopen = Off|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?allow\_url\_include\s*\=.*|allow_url_include = Off|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?expose\_php\s*\=.*|expose_php = Off|' {} \;
  sudo find /etc/php -type f -name 'php.ini' -exec sed -Ei 's|^\;?safe\_mode\_gid\s*\=.*|safe_mode_gid = On|' {} \;

  # Configure SSL - using 4096-bit DH parameters for stronger security
  # Note: This may take several minutes on slower systems
  [[ ! -f /etc/ssl/dhparam4096.pem 4096 ]] && sudo openssl dhparam -out /etc/ssl/dhparam4096.pem 4096

  # Configure Docker
  sudo mkdir -p /etc/docker
  backup_file /etc/docker/daemon.json
  cat << EOF | sudo tee /etc/docker/daemon.json
{
  "iptables" : false,
  "http-proxy" : "http://8.8.8.8",
  "https-proxy" : "https://8.8.8.8",
  "no-proxy" : "localhost,127.0.0.1"
}

EOF

  # Setup issue files
  cat << EOF | sudo tee /etc/issue
***************************************************************************
                            NOTICE TO USERS
This computer system is the private property of its owner, whether
individual, corporate or government.  It is for authorized use only.
Users (authorized or unauthorized) have no explicit or implicit
expectation of privacy.
Any or all uses of this system and all files on this system may be
intercepted, monitored, recorded, copied, audited, inspected, and
disclosed to your employer, to authorized site, government, and law
enforcement personnel, as well as authorized officials of government
agencies, both domestic and foreign.
By using this system, the user consents to such interception, monitoring,
recording, copying, auditing, inspection, and disclosure at the
discretion of such personnel or officials.  Unauthorized or improper use
of this system may result in civil and criminal penalties and
administrative or disciplinary action, as appropriate. By continuing to
use this system you indicate your awareness of and consent to these terms
and conditions of use. LOG OFF IMMEDIATELY if you do not agree to the
conditions stated in this warning.
****************************************************************************

EOF
  sudo cp /etc/issue /etc/issue.net

  # Configure odbc
  if [[ ! -f /etc/odbcinst.ini ]];
  then
    cat << EOF | sudo tee /etc/odbcinst.ini
[IBM i Access ODBC Driver]
Description = IBM i Access for Linux ODBC Driver
Driver = /opt/ibm/iaccess/lib/libcwbodbc.so
Setup = /opt/ibm/iaccess/lib/libcwbodbcs.so
Driver64 = /opt/ibm/iaccess/lib64/libcwbodbc.so
Setup64 = /opt/ibm/iaccess/lib64/libcwbodbcs.so
Threading = 2
DontDLClose = 1
UsageCount = 1

[IBM i Access ODBC Driver 64-bit]
Description = IBM i Access for Linux 64-bit ODBC Driver
Driver = /opt/ibm/iaccess/lib64/libcwbodbc.so
Setup = /opt/ibm/iaccess/lib64/libcwbodbcs.so
Threading = 2
DontDLClose = 1
UsageCount = 1

EOF
  fi
}


#------------------------------------------------------------------------------
# User Environment Setup
#------------------------------------------------------------------------------
setup_user_environment() {
  # Add user to default groups
  sudo usermod -aG sudo,games,video,kvm,input,disk,audio,plugdev ${CURRENT_USER}
  if command -v docker &> /dev/null;
  then
    sudo usermod -aG docker ${CURRENT_USER}
  fi

  # Create default folders
  mkdir -p ${HOME}/.cache/gem \
           ${HOME}/.cache/go \
           ${HOME}/.cache/kscript \
           ${HOME}/.cache/kube \
           ${HOME}/.cache/mypy \
           ${HOME}/.cache/nextjs-nodejs \
           ${HOME}/.cache/NuGetPackages \
           ${HOME}/.cache/nv \
           ${HOME}/.cache/pylint \
           ${HOME}/.cache/python \
           ${HOME}/.cache/python-eggs \
           ${HOME}/.cache/texlive \
           ${HOME}/.cache/X11 \
           ${HOME}/.config/aws \
           ${HOME}/.config/bash-completion \
           ${HOME}/.config/cargo \
           ${HOME}/.config/conda \
           ${HOME}/.config/docker \
           ${HOME}/.config/environment.d \
           ${HOME}/.config/ffmpeg \
           ${HOME}/.config/git/hooks \
           ${HOME}/.config/jupyter \
           ${HOME}/.config/k9s \
           ${HOME}/.config/kde \
           ${HOME}/.config/npm \
           ${HOME}/.config/pylint \
           ${HOME}/.config/R \
           ${HOME}/.config/readline \
           ${HOME}/.config/ripgrep \
           ${HOME}/.config/screen \
           ${HOME}/.config/systemd \
           ${HOME}/.config/texlive \
           ${HOME}/.config/travis \
           ${HOME}/.config/vim/gvimrc \
           ${HOME}/.config/X11 \
           ${HOME}/.config/zsh \
           ${HOME}/.local/bin \
           ${HOME}/.local/share/azure \
           ${HOME}/.local/share/bun \
           ${HOME}/.local/share/cargo \
           ${HOME}/.local/share/docker-machine \
           ${HOME}/.local/share/gdb \
           ${HOME}/.local/share/gem \
           ${HOME}/.local/share/gnupg \
           ${HOME}/.local/share/go \
           ${HOME}/.local/share/gradle \
           ${HOME}/.local/share/minikube \
           ${HOME}/.local/share/n \
           ${HOME}/.local/share/nodenv \
           ${HOME}/.local/share/node_repl_history \
           ${HOME}/.local/share/nvm \
           ${HOME}/.local/share/ollama/models \
           ${HOME}/.local/share/pyenv \
           ${HOME}/.local/share/python \
           ${HOME}/.local/share/rbenv \
           ${HOME}/.local/share/redis \
           ${HOME}/.local/share/rustup \
           ${HOME}/.local/share/terminfo \
           ${HOME}/.local/share/vagrant \
           ${HOME}/.local/share/virtualenvs \
           ${HOME}/.local/share/vscode \
           ${HOME}/.local/share/wineprefixes \
           ${HOME}/.local/share/z \
           ${HOME}/.local/state/bash \
           ${HOME}/.local/state/history \
           ${HOME}/.local/state/python \
           ${HOME}/.local/state/texmacs \
           ${HOME}/.local/state/texmf \
           ${HOME}/.local/state/zsh \
           ${HOME}/.ssh \
           ${HOME}/workspace \
           /run/user/$(id -u)/urxvtd \
           /run/user/$(id -u)/Xauthority

  # Create config files
  [[ ! -f ${HOME}/.profile.local ]] && touch ${HOME}/.profile.local
  [[ ! -f ${HOME}/.zshrc.local ]] && touch ${HOME}/.zshrc.local
  [[ ! -f ${HOME}/.config/cargo/config ]] && touch ${HOME}/.config/cargo/config
  [[ ! -f ${HOME}/.local/state/zsh/history ]] && touch ${HOME}/.local/state/zsh/history

  # Configure ZSH
  wget -O ${HOME}/.profile "https://raw.githubusercontent.com/MarcJose/shell/main/wsl-ubuntu/.profile"
  wget -O ${HOME}/.zshrc   "https://raw.githubusercontent.com/MarcJose/shell/main/wsl-ubuntu/.zshrc"
  sudo chsh -s /bin/zsh ${CURRENT_USER}

  # Configure SSH
  if [[ ! -f ${HOME}/.ssh/config ]];
  then
    cat << EOF | tee ${HOME}/.ssh/config
# Settings partially taken from:
# https://www.ssh-audit.com/hardening_guides.html#ubuntu_22_04_linux_mint_21

# SSH over Session Manager
# Open tunnel with ssh i-xxxxxx -L 5555:10.x.x.x:22 (5555 = local port, 22 = host port)
host i-* mi-*
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"

Host bitbucket.com
  HostName                    bitbucket.com
  #Port                        22
  #User                        Username
  #IdentityFile                ~/.ssh/id_bitbucket

Host dev.azure.com
  HostName                    dev.azure.com
  #Port                        22
  #User                        Username
  #IdentityFile                ~/.ssh/id_azure

Host github.com
  HostName                    github.com
  #Port                        22
  #User                        Username
  #IdentityFile                ~/.ssh/id_github

Host gitlab.com
  HostName                    gitlab.com
  #Port                        22
  #User                        Username
  #IdentityFile                ~/.ssh/id_gitlab

Host *
  Preferredauthentications    publickey
  AddKeysToAgent              yes
  PasswordAuthentication      no
  ControlMaster               auto
  ControlPath                 /tmp/%r@%h:%p
  ServerAliveInterval         30
  ServerAliveCountMax         10
  Ciphers                     chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
  KexAlgorithms               -ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group14-sha256
  MACs                        hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com
  HostKeyAlgorithms           sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256
  CASignatureAlgorithms       sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256
  HostbasedAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-256
  PubkeyAcceptedAlgorithms    sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-256

EOF
  fi
  # Creating an SSH key for each major Git hosting provider
  # This allows separate identities for different platforms
  [[ ! -f ${HOME}/.ssh/id_rsa ]] \
    && yes_or_no "Do you want to set up a default SSH-RSA key? [yn]: " \
    && ssh-keygen -t rsa -b 4096 -a 512 -f ${HOME}/.ssh/id_rsa -C ""
  [[ ! -f ${HOME}/.ssh/id_ed25519 ]] \
    && yes_or_no "Do you want to set up a default SSH-ED25519 key? [yn]: " \
    && ssh-keygen -t ed25519 -a 512 -f ${HOME}/.ssh/id_ed25519 -C ""
  [[ ! -f ${HOME}/.ssh/id_azure ]] \
    && yes_or_no "Do you want to set up a default SSH key for Azure? [yn]: " \
    && ssh-keygen -t ed25519 -a 512 -f ${HOME}/.ssh/id_azure -C ""
  [[ ! -f ${HOME}/.ssh/id_bitbucket ]] \
    && yes_or_no "Do you want to set up a default SSH key for BitBucket? [yn]: " \
    && ssh-keygen -t ed25519 -a 512 -f ${HOME}/.ssh/id_bitbucket -C ""
  [[ ! -f ${HOME}/.ssh/id_github ]] \
    && yes_or_no "Do you want to set up a default SSH key for GitHub? [yn]: " \
    && ssh-keygen -t ed25519 -a 512 -f ${HOME}/.ssh/id_github -C ""
  [[ ! -f ${HOME}/.ssh/id_gitlab ]] \
    && yes_or_no "Do you want to set up a default SSH key for GitLab? [yn]: " \
    && ssh-keygen -t ed25519 -a 512 -f ${HOME}/.ssh/id_gitlab -C ""
  rm ${HOME}/.ssh/known_hosts
  ssh-keyscan -t ed25519 ssh.dev.azure.com >> ${HOME}/.ssh/known_hosts
  ssh-keyscan -t rsa ssh.dev.azure.com >> ${HOME}/.ssh/known_hosts
  ssh-keyscan -t ed25519 bitbucket.com >> ${HOME}/.ssh/known_hosts
  ssh-keyscan -t rsa bitbucket.com >> ${HOME}/.ssh/known_hosts
  ssh-keyscan -t ed25519 github.com >> ${HOME}/.ssh/known_hosts
  ssh-keyscan -t rsa github.com >> ${HOME}/.ssh/known_hosts
  ssh-keyscan -t ed25519 gitlab.com >> ${HOME}/.ssh/known_hosts
  ssh-keyscan -t rsa gitlab.com >> ${HOME}/.ssh/known_hosts

  # Configure Git
  if [[ ! -f ${HOME}/.config/git/config ]];
  then
    cat << EOF | tee ${HOME}/.config/git/config
[alias]
    ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/\$@ ;}; gi"
    glog = !git log --graph --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'
    tlog = !git log --graph --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''        %C(dim white)= %an <%ae> =%C(reset)%n''        %C(white)%s%C(reset)'
    clog = !git log --pretty=format:'[%C(blue)%h%C(reset)][%C(green)%aI%C(reset)][%G?][%an <%ae>] %s'
[color]
    ui = true
[commit]
    gpgsign = true
[core]
    autocrlf = input
    editor = vim
    eol = lf
[credential "https://dev.azure.com]
    useHttpPath = true
[diff]
    colorMoved = default
    renamelimit = 99999
[filter "lfs"]
    required = true
    clean = git-lfs clean -- %f
    smudge = git-lfs smudge -- %f
    process = git-lfs filter-process
[gpg]
    format = openpgp
[gpg "openpgp"]
    program = gpg
[gpg "x509"]
    program = gpgsm
[http]
    postBuffer = 524288000
[init]
    defaultBranch = main
    templatedir = ~/.config/git/hooks
[inspector]
    format = htmlembedded
    list-file-types = true
    metrics = true
    responsibilities = true
    timeline = true
    weeks = true
    file-types = **
    hard = true
    grading = true
[pull]
    rebase = true
[push]
    autoSetupRemote = true
[remote "origin"]
    prune = true
[tag]
    gpgSign = true
[user]
    name = John Doe
    email = john.doe@example.com
    signingkey = ABCDEFGH123
EOF
  fi

  # Configure wget
  cat << EOF | tee ~/.config/wgetrc
hsts-file = 0

EOF

  # Configure GPG
  cat << EOF | tee ${HOME}/.local/share/gnupg/dirmngr.conf
keyserver hkps://keys.openpgp.org
#keyserver hkps://pgpkeys.eu
#keyserver hkps://pgp.mit.edu
#keyserver hkps://keyring.debian.org
#keyserver hkps://keyserver.ubuntu.com
#keyserver hkps://pgp.surf.nl

EOF
  cat << EOF | tee ${HOME}/.local/share/gnupg/gpg.conf
# https://github.com/drduh/config/blob/master/gpg.conf
# https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
# https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
personal-cipher-preferences AES256 AES192 AES
personal-digest-preferences SHA512 SHA384 SHA256
personal-compress-preferences ZLIB ZIP Uncompressed
default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB ZIP Uncompressed
cert-digest-algo SHA512
s2k-digest-algo SHA512
s2k-cipher-algo AES256
charset utf-8
fixed-list-mode
no-comments
no-emit-version
no-greeting
keyid-format 0xlong
list-options show-uid-validity
verify-options show-uid-validity
with-fingerprint
with-key-origin
require-cross-certification
no-symkey-cache
use-agent
throw-keyids
list-options show-unusable-subkeys

EOF
  cat << EOF | tee ${HOME}/.local/share/gnupg/gpg-agent.conf
pinentry-program /usr/bin/pinentry
max-cache-ttl 60480000
default-cache-ttl 60480000

EOF
  cat << EOF | tee ${HOME}/.local/share/gnupg/gpgsm.conf
disable-crl-checks

EOF
  find ${HOME}/.local/share/gnupg -type f -exec chmod 600 {} \;
  find ${HOME}/.local/share/gnupg -type d -exec chmod 700 {} \;
  rm ${HOME}/.gnupg
  gpgconf --kill all
  gpg-connect-agent updatestartuptty /bye > /dev/null
  yes_or_no "Do you want to start creating a new GPG key? [yn]: " \
    && gpg --full-generate-key

  # Configure screen
  if [[ ! -f ${HOME}/.config/screen/screenrc ]];
  then
    cat << EOF | tee ${HOME}/.config/screen/screenrc
# Use 256 colors
## Generic
term screen-256color
## For xterm based terminals
#term xterm-256color
## For rxvt based terminals
#term rxvt-unicode-256color
## termcapinfo based
#attrcolor b ".I"
#termcapinfo xterm 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm'
#defbce on

# Statusbar
backtick 1 5 5 true
hardstatus string "screen (%n: %t)"
caption string "%{= kw}%-Lw%{= kG}%{+b}[%n %t]%{-b}%{= kw}%+Lw%1\`"
caption always

# Disable welcome message
startup_message off

# Turn off visual bell
vbell off

# Fix displaying text from editors opened previously
altscreen on

# Enable scrolling of native terminal
termcapinfo xterm*|rxvt*|kterm*|Eterm* ti@:te@

# Use ZSH by default as shell
shell '/usr/bin/zsh'

EOF
  fi

  # Configure vim
  if [[ ! -f ${HOME}/.config/vim/vimrc ]];
  then
    cat << EOF | tee ${HOME}/.config/vim/vimrc
set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after
set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after
let g:netrw_home = $XDG_DATA_HOME."/vim"
call mkdir($XDG_DATA_HOME."/vim/spell", 'p')
set backupdir=$XDG_STATE_HOME/vim/backup | call mkdir(&backupdir, 'p')
set directory=$XDG_STATE_HOME/vim/swap   | call mkdir(&directory, 'p')
set undodir=$XDG_STATE_HOME/vim/undo     | call mkdir(&undodir,   'p')
set viewdir=$XDG_STATE_HOME/vim/view     | call mkdir(&viewdir,   'p')
if !has('nvim') | set viminfofile=$XDG_STATE_HOME/vim/viminfo | endif
set nocompatible
filetype on
filetype plugin on
filetype indent on
syntax on
set mouse=a
set number
set incsearch
set hlsearch
set shiftwidth=2
set tabstop=2
set expandtab
set nobackup
set scrolloff=10
set nowrap
set ignorecase
set smartcase
set showcmd
set showmode
set showmatch
set history=1000
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set statusline=
set statusline+=\ %F\ %M\ %Y\ %R
set statusline+=%=
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%
set laststatus=2

EOF
  fi

  # Configure Rust
  rustup default stable
  rustup component add rust-analyzer
  rustup component add rust-src
  rustup component add clippy
  rustup component add rustfmt
  if [[ ! -f ${HOME}/.local/share/cargo/config ]];
  then
    cat << EOF | tee ${HOME}/.local/share/cargo/config
[target.x86_64-unknown-linux-gnu]
rustflags = ["-C", "target-cpu=native"]

EOF
  fi

  # Setup AWS CLI
  if [[ ! -f ${HOME}/.config/aws/config ]];
  then
    cat << EOF | tee ${HOME}/.config/aws/config
[default]
region = eu-central-1
output = json

EOF
  fi
  if [[ ! -f ${HOME}/.config/aws/credentials ]];
  then
    cat << EOF | tee ${HOME}/.config/aws/credentials
[default]
aws_access_key_id =
aws_secret_access_key =

EOF
  fi

  # Configure npm
  if [[ ! -f ${HOME}/.config/npm/npmrc ]];
  then
    cat << EOF | tee ${HOME}/.config/npm/npmrc
prefix=${XDG_DATA_HOME}/npm
cache=${XDG_CACHE_HOME}/npm
init-module=${XDG_CONFIG_HOME}/npm/config/npm-init.js
logs-dir=${XDG_STATE_HOME}/npm/logs

EOF
  fi

  # Installing Node.js using NVM for flexible version management
  # This allows easy switching between Node.js versions
  if ! command -v nvm &> /dev/null;
  then
    curl -sS -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash > /dev/null
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh" > /dev/null
    nvm install --lts
    nvm alias default 'lts/*'
    nvm use default
    nvm install-latest-npm
  fi

  # Install default nodejs packages
  npm install -g dotenv-cli@7.4.4 node-gyp sass

  # Install deno
  if ! command -v deno &> /dev/null;
  then
    curl -fsSL https://deno.land/install.sh | sh
  fi

  # Install bun
  if ! command -v bun &> /dev/null;
  then
    curl -fsSL https://bun.sh/install | bash
  fi

  # Configure Next.js
  if [[ ! -f ${HOME}/.config/nextjs-nodejs/config.json ]];
  then
    cat << EOF | tee ${HOME}/.config/nextjs-nodejs/config.json                                                                                                                                                                            private/shell
{
  "telemetry": {
    "notifiedAt": "1711193819669",
    "anonymousId": "nope",
    "salt": "forgetit",
    "enabled": false
  }
}

EOF
  fi

  # Configure odbc
  pip3 install --user --break-system-packages ibm_db --no-binary :all: --no-cache-dir
  pip3 install --user --break-system-packages ibm_db_sa

  # Cleanup
  rm ${HOME}/.gnupg ${HOME}/.npm ${HOME}/.nvm ${HOME}/.sudo_as_admin_successful \
     ${HOME}/.bash_history ${HOME}/.histfile ${HOME}/.mysql_history \
     ${HOME}/.wget-hsts ${HOME}/.landscape ${HOME}/.cargo ${HOME}/.rustup \
     ${HOME}/.lesshst ${HOME}/.motd_shown ${HOME}/.zshenv
}

#------------------------------------------------------------------------------
# Function: setup_permissions
# Description: Sets appropriate ownership and permissions for user files and
#              web server directories to ensure proper security
# Args: None
# Returns: None
#------------------------------------------------------------------------------
setup_permissions() {
  sudo chown -R ${CURRENT_USER}:${CURRENT_USER} ${HOME}
  sudo chmod 400 ${HOME}/.ssh/id_*
  sudo chmod 600 ${HOME}/.ssh/config

  sudo chown -R ${CURRENT_USER}:www-data /var/www/html /usr/share/phpmyadmin
  sudo chmod -R 750 /var/www/html /usr/share/phpmyadmin
  sudo find /var/www/html -type f -exec chmod 644 {} \;
  sudo find /var/www/html -type d -exec chmod 755 {} \;
}

#------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------
main() {
  log "Starting WSL setup script..."

  # Check prerequisites
  check_system_version
  check_network

  # Create backup directory
  mkdir -p "${HOME}/.wsl_setup_backups/$(date +%Y-%m-%d)"

  # Main steps with progress tracking
  progress "Updating system..."
  update_system
  progress "Installing packages..."
  install_packages
  progress "Enabling system services..."
  enable_system_services
  progress "Configuring WSL-specific settings"
  configure_wsl
  progress "Configuring system"
  configure_system
  progress "Setting up user environment..."
  setup_user_environment
  progress "Setting up default permissions..."
  setup_permissions

  # Final message
  log "Setup completed successfully!"
  log "System files backed up in \"${HOME}/.wsl_setup_backups/\""
  log "Next steps:"
  log "   1. Restart WSL with 'wsl --shutdown' from PowerShell"
  log "   2. Upload your public SSH keys to the respective platforms"
  log "   3. Upload your public GPG key to the respective platforms"
  log "   4. Finish your git config:"
  log "      git config --global user.name \"Firstname Lastname\""
  log "      git config --global user.email \"my.email@domain.org\""
  log "      git config --global user.signingkey \"<GPG_KEY_ID>\""
  log "      You can retrieve the key with:"
  log "         gpg --list-secret-keys --keyid-format=long"
  log "   5. Enable Ubuntu's ESM support at https://ubuntu.com/pro/subscribe"
}

# Run main function
main
