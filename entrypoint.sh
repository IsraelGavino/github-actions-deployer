#!/usr/bin/env bash

# Variables
FILE_SCRIPT="${1}"
SSH_HOST="${2}"
SSH_PORT="${3}"
SSH_USER="${4}"
SSH_KEY="${5}"

# Creamos directorios esenciales para SSH
mkdir /root/.ssh
touch /root/.ssh/id_rsa
touch /root/.ssh/known_hosts
touch /root/.ssh/config

# Contenido de id_rsa
echo "$SSH_KEY" >> /root/.ssh/id_rsa

# Permisos esenciales para SSH
chmod 700 /root/.ssh/
chmod 600 /root/.ssh/*
chmod u+w /root/.ssh/known_hosts
chown -R root:root /root/.ssh/

# Obtenemos la IP del host
HOST_IP=$(dig +short $SSH_HOST)

# Añadimos a servidores conocidos
ssh-keyscan -p $SSH_PORT -t rsa,dsa $HOST_IP >> ~/.ssh/known_hosts

# Ejecutamos
ssh -p$SSH_PORT -i ~/.ssh/id_rsa $SSH_USER@$HOST_IP "bash -s" -- < /scripts/$FILE_SCRIPT.sh "${@:6}"

# Salimos
exit $?