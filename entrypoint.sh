#!/usr/bin/env bash

# Variables
SSH_HOST="${1}"
SSH_PORT="${2}"
SSH_USER="${3}"
SSH_KEY="${4}"
DEPLOY_DOMAIN="${5}"
KEEP_RELEASES="${6}"
PATH_PUBLIC="${7}"
PHP_VERSION="${8}"
PATHS_CLEAN="${9}"
DIRS_SHARE="${10}"
USERNAME="${11}"
GITHUB_TOKEN="${12}"
GITHUB_REPOSITORY="${13}"
BRANCH_NAME="${14}"
USER=$(id -u -n)
GROUP=$(id -g -n)
SSH_HOST_IP=$(dig +short ${SSH_HOST})

# Librerias
. "scripts/base.sh"


# # Config SSH
# ssh_config "$SSH_KEY" $USER $GROUP $SSH_HOST $SSH_PORT $SSH_HOST_IP

# # Setup
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "setup" $PATH_PUBLIC

# # Lock
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "lock" $PATH_PUBLIC $USERNAME

# # Release
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "lock" $PATH_PUBLIC $USERNAME

api_github_release_url $GITHUB_TOKEN $GITHUB_REPOSITORY $BRANCH_NAME

# Salimos
exit $?


# 

# Ejecutamos
#ssh -o GlobalKnownHostsFile=~/.ssh/known_hosts -p$SSH_PORT -i ~/.ssh/id_rsa $SSH_USER@$HOST_IP "bash -s" -- < /scripts/$FILE_SCRIPT.sh "${@:6}"

#ssh -o GlobalKnownHostsFile=~/.ssh/known_hosts -p$SSH_PORT -i ~/.ssh/id_rsa $SSH_USER@$SSH_HOST_IP "ls -la"





