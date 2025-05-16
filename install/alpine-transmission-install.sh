#!/usr/bin/env bash

# Copyright (c) 2021-2025 community-scripts ORG
# Author: Slaviša Arežina (tremor021)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://transmissionbt.com/

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Transmission"
$STD apk add --no-cache transmission-cli transmission-daemon
$STD rc-service transmission-daemon start
$STD rc-service transmission-daemon stop

FOLDER_PATH="/var/lib/transmission/config"
mkdir -p $FOLDER_PATH

FILE_PATH=$FOLDER_PATH"/settings.json"

if [ -d $FOLDER_PATH  ]; then
  echo "Folder exists at $FOLDER_PATH."    
else
  echo "Folder does not exist"
fi

if [ $test -f $filename  ]; then
  echo "File exists at $FILE_PATH."
else
  echo "File does not exist"
fi

exit 1

sed -i '{s/"rpc-whitelist-enabled": true/"rpc-whitelist-enabled": false/g; s/"rpc-host-whitelist-enabled": true,/"rpc-host-whitelist-enabled": false,/g}' /var/lib/transmission/config/settings.json
msg_ok "Installed Transmission"

msg_info "Enabling Transmission Service"
$STD rc-update add transmission-daemon default
msg_ok "Enabled Transmission Service"

msg_info "Starting Transmission"
$STD rc-service transmission-daemon start
msg_ok "Started Transmission"

motd_ssh
customize
