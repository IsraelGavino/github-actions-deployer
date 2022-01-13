#!/bin/bash

# Variables
PATH_PUBLIC="${1}"
PATH_DEPLOY="${1}/deploy"
PATH_RELEASE="${2}"

# Nos posicionamos
cd $PATH_DEPLOY

# Enlace symbolico
ln -sfn $PATH_RELEASE current
rm -rf $PATH_PUBLIC/public_html
ln -sfn $PATH_DEPLOY/current $PATH_PUBLIC/public_html

# Eliminamos
rm release