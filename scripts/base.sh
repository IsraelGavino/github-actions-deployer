#!/usr/bin/env bash

run() {
	local cmd="${1}"
	/bin/sh -c "LANG=C LC_ALL=C ${cmd}"
}

ssh_config() {
	local SSH_KEY="${1}"
	local USER="${2}"
	local GROUP="${3}"
	local SSH_HOST="${4}"
	local SSH_PORT="${5}"
	local SSH_HOST_IP="${6}"

	# Creamos directorios esenciales para SSH
	run "mkdir -p ~/.ssh"
	run "touch ~/.ssh/id_rsa"
	run "touch ~/.ssh/known_hosts"
	run "touch ~/.ssh/config"

	# Contenido de id_rsa
	run "echo \"${SSH_KEY}\" >> ~/.ssh/id_rsa"

	# Permisos esenciales para SSH
	run "chmod 700 ~/.ssh/"
	run "chmod 600 ~/.ssh/*"
	run "chmod u+w ~/.ssh/known_hosts"
	run "chown -R ${USER}:${GROUP} ~/.ssh/"

	# Añadimos a servidores conocidos
	run "ssh-keyscan -p ${SSH_PORT} -t rsa,dsa ${SSH_HOST_IP} >> ~/.ssh/known_hosts"
}

ssh_execute_remote() {
	local SSH_HOST="${1}"
	local SSH_PORT="${2}"
	local SSH_USER="${3}"
	local SSH_HOST_IP="${4}"
	local FILE_SCRIPT="${5}"

	ssh -o GlobalKnownHostsFile=~/.ssh/known_hosts -p$SSH_PORT -i ~/.ssh/id_rsa $SSH_USER@$SSH_HOST_IP "bash -s" -- < /scripts/$FILE_SCRIPT.sh "${@:6}"
}

function api_github() {
	local GITHUB_TOKEN="${1}"

	curl -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3.json" -s https://api.github.com/${@:2}
}

function api_github_release_url() {
	local GITHUB_TOKEN="${1}"
	local GITHUB_REPOSITORY="${2}"
	local BRANCH_NAME="${3}"

	#COMPOSER_VERSION=`api_github $GITHUB_TOKEN repos/$GITHUB_REPOSITORY/contents/composer.json?ref=$BRANCH_NAME | jq -r ".version"`
}