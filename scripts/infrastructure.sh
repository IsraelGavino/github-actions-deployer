#!/bin/bash

# Variables
DATABASE_HOST="${1}"
DATABASE_NAME="${2}"
DATABASE_USER="${3}"
DATABASE_PASSWORD="${4}"
PATH_RELEASE="${5}"
URL_IMAGES_TARGZ="${6}"

# Configuracion DB
mv $PATH_RELEASE/includes/configure_example.php $PATH_RELEASE/includes/configure.php ; \
sed -i -- "s/{DB_SERVER}/${DATABASE_HOST}/g" $PATH_RELEASE/includes/configure.php && \
sed -i -- "s/{DB_USERNAME}/${DATABASE_USER}/g" $PATH_RELEASE/includes/configure.php && \
sed -i -- "s/{DB_PASSWORD}/${DATABASE_PASSWORD}/g" $PATH_RELEASE/includes/configure.php && \
sed -i -- "s/{DB_DATABASE}/${DATABASE_NAME}/g" $PATH_RELEASE/includes/configure.php ; \

# Descarga de imagenes
if [ $URL_IMAGES_TARGZ != "" ]; then
	cd $PATH_RELEASE/images
	wget -O images.tar.gz $URL_IMAGES_TARGZ >/dev/null 2>&1
	tar zxf images.tar.gz
	rm images.tar.gz
fi