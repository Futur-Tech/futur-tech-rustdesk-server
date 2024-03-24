#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_func"
source "$(dirname "$0")/ft-util/ft_util_docker"
source "$(dirname "$0")/ft-util/ft_util_inc_var"

$S_LOG -d $S_NAME "Start $S_DIR_NAME/$S_NAME $*"

rustdesk_fld="/srv/rustdesk"
dc_file="${rustdesk_fld}/docker-compose.yml"
dc_env="${rustdesk_fld}/docker-compose.env"
docker_data="${rustdesk_fld}/docker-data"

# Check if Docker is installed
which docker &>/dev/null || {
    $S_LOG -s crit -d $S_NAME "Docker is not installed."
    exit 1
}

mkdir_if_missing "${rustdesk_fld}"                                               # Ensure RustDesk directory exists
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/docker-compose.yml" "${dc_file}"      # Deploy modified docker-compose.yml
$S_DIR/ft-util/ft_util_conf-update -s "$S_DIR/docker-compose.env" -d "${dc_env}" # Deploy/update environment variable files

source "$dc_env" # Load environment variables from the file

# Set RELAY to FQDN if empty
if [ -z "$RELAY" ]; then
    $S_LOG -s warn -d $S_NAME "Setting RustDesk relay address to [$(hostname -f)]"
    override_var "${dc_env}" "RELAY=" "$(hostname -f)"
    source "$dc_env"
fi

# Check configuration, pull new images, and start/restart containers
docker-compose_configcheck "${dc_file}" "${dc_env}"
docker-compose_pull "${dc_file}" "${dc_env}"
docker-compose_up "${dc_file}" "${dc_env}"
docker_container_wait_healthy rustdesk-server

# Show server data for connecting clients
$S_LOG -s warn -d $S_NAME "config={\"host\": \"${RELAY}\", \"key\": \"$(cat ${rustdesk_fld}/docker-data/data/id_ed25519.pub)\"}"

$S_LOG -d "$S_NAME" "End $S_NAME"

exit
