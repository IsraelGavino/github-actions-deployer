#!/bin/bash

# Variables
PATH_DEPLOY="${1}/deploy"
RELEASE_NAME="${2}"
USERNAME="${3}"
LATESTS_RELEASE="${4}"

# Nos posicionamos
cd $PATH_DEPLOY

# Limpiamos si ha quedado un release sin terminar
if [ -h release ]; then
    rm -rf "$(readlink release)"
    rm release
fi

# Directorio del release
PATH_RELEASE="$PATH_DEPLOY/releases/$LATESTS_RELEASE"

# Fecha
date=$(date +%Y-%m-%d_%H:%M:%S)

# Guardamos informacion sobre el release
echo "$LATESTS_RELEASE,$date,$RELEASE_NAME,$USERNAME" >> .dep/releases
echo $LATESTS_RELEASE > .dep/latest_release

# Creamos el directorio del nuevo release
mkdir -p $PATH_RELEASE
ln -snf $PATH_RELEASE $PATH_DEPLOY/release