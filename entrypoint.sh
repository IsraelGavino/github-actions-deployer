#!/usr/bin/env bash

set -e

# Variables
CLEAN_UP="${1}"
SSH_HOST="${2}"
SSH_PORT="${3}"
SSH_USER="${4}"
SSH_KEY="${5}"
KEEP_RELEASES="${6}"
PATH_PUBLIC="${7}"
DIRS_SHARE="${8}"
FILES_SHARE="${9}"
BRANCH_NAME="${10}"
CPANEL_URL="${11}"
CPANEL_USER="${12}"
CPANEL_KEY="${13}"
DATABASE_HOST="${14}"
DATABASE_NAME="${15}"
DATABASE_USER="${16}"
DATABASE_PASSWORD="${17}"
DEPLOY_DOMAIN="${18}"
DEPLOY_SUBDOMAIN="${19}"
USERNAME="${20}"
GITHUB_TOKEN="${21}"
GITHUB_REPOSITORY="${22}"
USER=$(id -u -n)
GROUP=$(id -g -n)
SSH_HOST_IP=$(dig +short ${SSH_HOST})

# Librerias
. "/scripts/base.sh"

echo "🕸️ Configuramos SSH"
ssh_config "$SSH_KEY" $USER $GROUP $SSH_HOST $SSH_PORT $SSH_HOST_IP

# Limpiar
if [ "$CLEAN_UP" = "true" ]; then
  echo "🗑️ Ejecutamos delete"
  #ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "delete" $CPANEL_URL $CPANEL_USER "$CPANEL_KEY" $DATABASE_HOST $DATABASE_NAME $DATABASE_USER $DATABASE_PASSWORD $PATH_PUBLIC $DEPLOY_DOMAIN $DEPLOY_SUBDOMAIN
fi

# echo "🎻 Obtenemos version composer"
# VERSION=`api_github_composer_version $GITHUB_TOKEN $GITHUB_REPOSITORY $BRANCH_NAME`

# # Directorio release
# PATH_RELEASE=$PATH_PUBLIC/deploy/releases/$VERSION

# echo "⚙️ Ejecutamos Setup"
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "setup" $PATH_PUBLIC $PATH_RELEASE

# echo "🔒 Ejecutamos Lock"
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "lock" $PATH_PUBLIC $USERNAME

# echo "📁 Ejecutamos Release"
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "release" $PATH_PUBLIC $VERSION $USERNAME

# echo "⏬ Ejecutamos Download"
# DOWNLOAD_FILENAME=$(api_github_download_release $GITHUB_TOKEN $GITHUB_REPOSITORY $BRANCH_NAME $VERSION)

# echo "⏫ Ejecutamos Upload"
# scp_upload_file $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP $DOWNLOAD_FILENAME $PATH_RELEASE

# echo "🗜️ Ejecutamos Unpack"
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "unpack" $PATH_RELEASE $DOWNLOAD_FILENAME

# echo "🤝 Ejecutamos Shared"
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "shared" $PATH_PUBLIC $PATH_RELEASE "'"$DIRS_SHARE"'" "'"$FILES_SHARE"'"

# echo "🎻 Ejecutamos Composer"
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "composer" $PATH_RELEASE

# echo "⚓ Ejecutamos Symlink"
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "symlink" $PATH_PUBLIC $PATH_RELEASE

# echo "🧽 Ejecutamos Cleanup"
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "cleanup" $PATH_PUBLIC $KEEP_RELEASES

# echo "🔓 Ejecutamos Unlock"
# ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "unlock" $PATH_PUBLIC
