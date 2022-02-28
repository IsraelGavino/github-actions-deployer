#!/bin/bash

# Variables
PATH_RELEASE="${1}"
CLEAN_UP="${2}"
DATABASE_HOST="${3}"
DATABASE_NAME="${4}"
DATABASE_USER="${5}"
DATABASE_PASSWORD="${6}"

# Reset
if [ "$CLEAN_UP" = "true" ]; then 
	# Descarga de imagenes
	make -f $PATH_RELEASE/Makefile images
fi

# Comprobamos si no tiene configure
if [[ -f  $PATH_RELEASE/includes/configure_example.php ]] && [[ ! -f  $PATH_RELEASE/includes/configure.php ]]; then
	mv $PATH_RELEASE/includes/configure_example.php $PATH_RELEASE/includes/configure.php ; \
	sed -i -- "s/{DB_SERVER}/${DATABASE_HOST}/g" $PATH_RELEASE/includes/configure.php && \
	sed -i -- "s/{DB_USERNAME}/${DATABASE_USER}/g" $PATH_RELEASE/includes/configure.php && \
	sed -i -- "s/{DB_PASSWORD}/${DATABASE_PASSWORD}/g" $PATH_RELEASE/includes/configure.php && \
	sed -i -- "s/{DB_DATABASE}/${DATABASE_NAME}/g" $PATH_RELEASE/includes/configure.php ; \
fi

# Permisos
make -f $PATH_RELEASE/Makefile permissions