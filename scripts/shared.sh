#!/bin/bash

# Variables
PATH_DEPLOY="${1}/deploy"
PATH_RELEASE="${2}"
DIRS_SHARE="${3}"
FILES_SHARE="${4}"
PATH_SHARED="$PATH_DEPLOY/shared"

# Lo añadimos como array
DIRS_SHARE=(`echo "${DIRS_SHARE}"`)
FILES_SHARE=(`echo "${FILES_SHARE}"`)

# Duplicados
duplicateExists=$(printf '%s\n' "${DIRS_SHARE[@]}"|awk '!($0 in seen){seen[$0];next} 1')

# Comprobamos que no existan duplicados
if [ ! -z "$duplicateExists" ]; then
    duplicateExists=$(echo -en $duplicateExists)
    echo "Error: Los directorios compartidos $duplicateExists estan duplicados, compruebalo"
    exit 1
fi

# Recorremos
for directory in "${DIRS_SHARE[@]}"
do
    # Comprobamos que el directorio compartido no exista para crearlo
    if [ ! -d $PATH_SHARED/$directory ]; then
        mkdir -p $PATH_SHARED/$directory
    fi

    # Si el release tiene un directorio compartido, copiamos ese directorio al compartido
    if [ -d $PATH_RELEASE/$directory ] && [ -d $PATH_SHARED/$directory ]; then
        dirname=$(dirname $directory)
        dirname=$(echo "${dirname//./}")
        cp -rv $PATH_RELEASE/$directory $PATH_SHARED/$dirname
    fi

    # Eliminamos del release
    rm -rf $PATH_RELEASE/$directory

    # Como hemos eliminado el directorio en el codigo anterior
    # ahora creamos los directorios excepto el que sera un symlik
    dirname=$(dirname $PATH_SHARED/$directory)
    mkdir -p $dirname

    # Creamos el symlink
    ln -s $PATH_SHARED/$directory $PATH_RELEASE/$directory
done

# Recorremos
for file in "${FILES_SHARE[@]}"
do
    # Directorio del fichero
    directory=$(dirname $file)

    # Comprobamos que el directorio compartido no exista para crearlo
    if [ ! -d $PATH_SHARED/$directory ]; then
        mkdir -p $PATH_SHARED/$directory
    fi

    # Si el fichero existe en el release y no en el shared lo copiamos
    if [ -f $PATH_RELEASE/$file ] && [ ! -f $PATH_SHARED/$file ]; then
        cp -rv $PATH_RELEASE/$file $PATH_SHARED/$file
    fi

    # Eliminamos del release
    rm -rf $PATH_RELEASE/$file

    # Aseguramos que exista el directorio
    mkdir -p $PATH_SHARED/$directory

    # Creamos el symlink
    ln -s $PATH_SHARED/$file $PATH_RELEASE/$file
done