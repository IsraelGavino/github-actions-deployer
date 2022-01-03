#!/usr/bin/env bash

# Variables
FILE_SCRIPT="${1}"
SSH_HOST="${2}"
SSH_PORT="${3}"
SSH_USER="${4}"
SSH_KEY="${5}"
USER=$(id -u -n)
GROUP=$(id -g -n)

# Creamos directorios esenciales para SSH
mkdir ~/.ssh
touch ~/.ssh/id_rsa
touch /etc/ssh/ssh_known_hosts
touch ~/.ssh/config

# Contenido de id_rsa
echo "$SSH_KEY" >> ~/.ssh/id_rsa

# Permisos esenciales para SSH
chmod 700 ~/.ssh/
chmod 600 ~/.ssh/*
chmod u+w /etc/ssh/ssh_known_hosts
chown -R $USER:$GROUP ~/.ssh/

# Obtenemos la IP del host
HOST_IP=$(dig +short $SSH_HOST)

# Añadimos a servidores conocidos
ssh-keyscan -p $SSH_PORT -t rsa,dsa $HOST_IP >> /etc/ssh/ssh_known_hosts

# log
#lftp -d sftp://u99555015-6m4hDQd5:^6m4hDQd5%iD@access811083711.webspace-data.io -e "debug; set sftp:auto-confirm yes; put ~/.ssh/id_rsa; bye"


# Ejecutamos
ssh -p$SSH_PORT -i ~/.ssh/id_rsa $SSH_USER@$HOST_IP "bash -s" -- < /scripts/$FILE_SCRIPT.sh "${@:6}"

# Salimos
exit $?
