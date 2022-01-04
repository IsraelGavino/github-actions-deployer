#!/bin/bash

# Variables
PATH_PUBLIC="${1}"
PATH_DEPLOY="${1}/deploy"

# Directorio deploy
if [ ! -d $PATH_DEPLOY ]; then 
	mkdir -p $PATH_DEPLOY 
fi

# Si existe el directorio public_html y no es un enlace simbolico
if [ ! -L $PATH_PUBLIC/public_html ] && [ -d $PATH_PUBLIC/public_html ]; then
	echo "Error: Existe un directorio llamado public_html en $PATH_PUBLIC eliminalo"
	exit 1
fi

# Si existe el directorio current y no es un enlace simbolico, marcamos como error
if [ ! -L $PATH_DEPLOY/current ] && [ -d $PATH_DEPLOY/current ]; then
	echo "Error: Existe un directorio llamado current en $PATH_DEPLOY/current eliminalo"
	exit 1
fi

# Nos posicionamos en el directorio
cd $PATH_DEPLOY

# Directorio metadata
if [ ! -d .dep ]; then 
	mkdir .dep;
fi

# Directorio releases
if [ ! -d releases ]; then 
	mkdir releases;
fi

# Directorio shared
if [ ! -d shared ]; then 
	mkdir shared;
fi