#!/bin/bash

# Variables
PATH_RELEASE="${1}"
FILE_ARTIFACT="${2}"

# Nos posicionamos en el directorio
cd $PATH_RELEASE

# Comprobamos si exsite el artefacto
if [ ! -f $FILE_ARTIFACT ]; then
	echo "Error el artefacto no se encuentra en $PATH_RELEASE/$FILE_ARTIFACT"
	exit 1
fi

# Descomprimimos
unzip -qq $FILE_ARTIFACT

# Eliminamos
rm $FILE_ARTIFACT
