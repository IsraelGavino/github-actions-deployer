#!/usr/bin/env bash

set -e

# Variables
SSH_HOST="${1}"
SSH_PORT="${2}"
SSH_USER="${3}"
SSH_KEY="${4}"
KEEP_RELEASES="${5}"
PATH_PUBLIC="${6}"
DIRS_SHARE="${7}"
FILES_SHARE="${8}"
USERNAME="${9}"
GITHUB_TOKEN="${10}"
GITHUB_REPOSITORY="${11}"
BRANCH_NAME="${12}"
USER=$(id -u -n)
GROUP=$(id -g -n)
SSH_HOST_IP=$(dig +short ${SSH_HOST})

# Librerias
. "/scripts/base.sh"

echo "🕸️ Configuramos SSH"
ssh_config "$SSH_KEY" $USER $GROUP $SSH_HOST $SSH_PORT $SSH_HOST_IP

echo "🎻 Obtenemos version composer"
VERSION=`api_github_composer_version $GITHUB_TOKEN $GITHUB_REPOSITORY $BRANCH_NAME`

# Directorio release
PATH_RELEASE=$PATH_PUBLIC/deploy/releases/$VERSION

echo "⚙️ Ejecutamos Setup"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "setup" $PATH_PUBLIC $PATH_RELEASE

echo "🔒 Ejecutamos Lock"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "lock" $PATH_PUBLIC $USERNAME

echo "📁 Ejecutamos Release"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "release" $PATH_PUBLIC $VERSION $USERNAME

echo "⏬ Ejecutamos Download"
DOWNLOAD_FILENAME=$(api_github_download_release $GITHUB_TOKEN $GITHUB_REPOSITORY $BRANCH_NAME $VERSION)

echo "⏫ Ejecutamos Upload"
scp_upload_file $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP $DOWNLOAD_FILENAME $PATH_RELEASE

echo "🗜️ Ejecutamos Unpack"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "unpack" $PATH_RELEASE $DOWNLOAD_FILENAME

echo "🤝 Ejecutamos Shared"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "shared" $PATH_PUBLIC $PATH_RELEASE "'"$DIRS_SHARE"'" "'"$FILES_SHARE"'"

echo "🎻 Ejecutamos Composer"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "composer" $PATH_RELEASE

echo "⚓ Ejecutamos Symlink"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "symlink" $PATH_PUBLIC $PATH_RELEASE

echo "🧽 Ejecutamos Cleanup"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "cleanup" $PATH_PUBLIC $KEEP_RELEASES

echo "🔓 Ejecutamos Unlock"
ssh_execute_remote $SSH_HOST $SSH_PORT $SSH_USER $SSH_HOST_IP "unlock" $PATH_PUBLIC
