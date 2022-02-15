#!/usr/bin/env bash

ssh_config() {
	local SSH_KEY="${1}"
	local USER="${2}"
	local GROUP="${3}"
	local SSH_HOST="${4}"
	local SSH_PORT="${5}"
	local SSH_HOST_IP="${6}"

	# Creamos directorios esenciales para SSH
	mkdir -p ~/.ssh
	touch ~/.ssh/id_rsa
	touch ~/.ssh/known_hosts
	touch ~/.ssh/config

	# Contenido de id_rsa
	echo "${SSH_KEY}" >> ~/.ssh/id_rsa

	# Permisos esenciales para SSH
	chmod 700 ~/.ssh/
	chmod 600 ~/.ssh/*
	chmod u+w ~/.ssh/known_hosts
	chown -R ${USER}:${GROUP} ~/.ssh/

	# Añadimos a servidores conocidos
	ssh-keyscan -p ${SSH_PORT} -t rsa,dsa ${SSH_HOST_IP} >> ~/.ssh/known_hosts
}

ssh_execute_remote() {
	local SSH_HOST="${1}"
	local SSH_PORT="${2}"
	local SSH_USER="${3}"
	local SSH_HOST_IP="${4}"
	local FILE_SCRIPT="${5}"

	ssh -o GlobalKnownHostsFile=~/.ssh/known_hosts -p$SSH_PORT -i ~/.ssh/id_rsa $SSH_USER@$SSH_HOST_IP "bash -s" -- < /scripts/$FILE_SCRIPT.sh "${@:6}"
}

scp_upload_file() {
	local SSH_HOST="${1}"
	local SSH_PORT="${2}"
	local SSH_USER="${3}"
	local SSH_HOST_IP="${4}"
	local FILE_UPLOAD="${5}"
	local PATH_REMOTE="${6}"

	scp -o GlobalKnownHostsFile=~/.ssh/known_hosts -P$SSH_PORT -i ~/.ssh/id_rsa $FILE_UPLOAD $SSH_USER@$SSH_HOST_IP:$PATH_REMOTE
}

function api_github_raw() {
	local GITHUB_TOKEN="${1}"

	curl -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3.raw" -s https://api.github.com/${@:2}
}

function api_github_object() {
	local GITHUB_TOKEN="${1}"

	curl -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" -s https://api.github.com/${@:2}
}

function api_github_composer_version() {
	local GITHUB_TOKEN="${1}"
	local GITHUB_REPOSITORY="${2}"
	local BRANCH_NAME="${3}"	

	VERSION=`api_github_raw $GITHUB_TOKEN repos/$GITHUB_REPOSITORY/contents/composer.json?ref=$BRANCH_NAME | jq -r ".version"`

	if [ "$BRANCH_NAME" = "develop" ]; then
		VERSION=$VERSION-dev
	fi;

	echo $VERSION
}

function api_github_download_file() {
	local GITHUB_TOKEN="${1}"
	local GITHUB_REPOSITORY="${2}"
	local BRANCH_NAME="${3}"	
	local FILENAME="${4}"
	local DIRNAME="$(dirname $FILENAME)"
	local BASENAME="$(basename -- $FILENAME)"

	FILE_SHA=`api_github_object $GITHUB_TOKEN repos/$GITHUB_REPOSITORY/contents/$DIRNAME?ref=$BRANCH_NAME | jq -r ".[] | select(.name == \"${BASENAME}\") | .sha"`

	api_github_raw $GITHUB_TOKEN repos/$GITHUB_REPOSITORY/git/blobs/$FILE_SHA?ref=$BRANCH_NAME > $BASENAME

	echo $BASENAME
}

function api_github_download_release() {
	local GITHUB_TOKEN="${1}"
	local GITHUB_REPOSITORY="${2}"
	local BRANCH_NAME="${3}"
	local COMPOSER_VERSION="${4}"

	if [ "$BRANCH_NAME" = "develop" ]; then
		PRERELEASE=true
	else
		PRERELEASE=false
	fi;

	RELEASE_URL=`api_github_raw $GITHUB_TOKEN repos/$GITHUB_REPOSITORY/releases | jq -r ".[] | select(.prerelease == $PRERELEASE) | .assets[] | select(.name | contains(\"$COMPOSER_VERSION\")) | .url"`
	
	RELEASE_NAME=$(curl -sIkL -H "Authorization: token $GITHUB_TOKEN" -H 'Accept: application/octet-stream' "$RELEASE_URL" | sed -r '/filename=/!d;s/.*filename=(.*)$/\1/' | tr -d '[:space:]')

	curl -LJO# -s -H "Authorization: token $GITHUB_TOKEN" -H 'Accept: application/octet-stream' "$RELEASE_URL"

	echo $RELEASE_NAME
}
