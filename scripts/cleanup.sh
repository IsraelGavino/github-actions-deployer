#!/bin/bash

# Variables
PATH_DEPLOY="${1}/deploy"
KEEP_RELEASES="${2}"
PATH_RELEASES="${PATH_DEPLOY}/releases"

# Obtenemos releases
RELEASES=($(ls -dhatr $PATH_RELEASES/*))
COUNT_RELEASES="${#RELEASES[@]}"

# Comprobamos si tenemos mas releases de las permitidas
if [ $COUNT_RELEASES -gt $KEEP_RELEASES ]; then
	# Releases sobrantes
	LEFTOVER_RELEASES=$(($COUNT_RELEASES - $KEEP_RELEASES))

	# Recorremos
	while [ $LEFTOVER_RELEASES -gt 0 ]
	do
	    rm -rf ${RELEASES[0]}
	    RELEASES=("${RELEASES[@]:1}")
	    LEFTOVER_RELEASES=$(( $LEFTOVER_RELEASES - 1 ))
	done
fi