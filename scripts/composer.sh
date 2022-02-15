#!/bin/bash

# Variables
PATH_RELEASE="${1}"

# Nos posicionamos
cd $PATH_RELEASE

# Lanzamos composer
composer update --no-dev
composer run-script installs