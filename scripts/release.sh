#!/bin/bash

# Variables
PATH_DEPLOY="${1}/deploy"
RELEASE_NAME="${2}"
USERNAME="${3}"

# Nos posicionamos
cd $PATH_DEPLOY

# Limpiamos si ha quedado un release sin terminar
if [ -h release ]; then
    rm -rf "$(readlink release)"
    rm release
fi

# Directorio del release
PATH_RELEASE="$PATH_DEPLOY/releases/$RELEASE_NAME"

# Fecha
date=$(date +%Y-%m-%d_%H:%M:%S)

# Guardamos informacion sobre el release
echo "$date,$RELEASE_NAME,$USERNAME" >> .dep/releases

# Creamos el directorio del nuevo release
mkdir -p $PATH_RELEASE
ln -s $PATH_RELEASE $PATH_DEPLOY/release