#!/usr/bin/env bash

echo $@

for ARGUMENT in "$@"
do
	KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

    case "$KEY" in
		variable1) variable1=${VALUE} ;;
		variable2) variable2=${VALUE} ;;     
        *)   
    esac    
done

echo "variable1 = $variable1"
echo "variable2 = $variable2"