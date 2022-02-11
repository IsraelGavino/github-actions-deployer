#!/bin/bash

# Variables
CPANEL_URL="${1}"
CPANEL_USER="${2}"
CPANEL_SECRET="${3}"
DATABASE_HOST="${4}"
DATABASE_NAME="${5}"
DATABASE_USER="${6}"
DATABASE_PASSWORD="${7}"
PATH_PUBLIC="${8}"
DEPLOY_DOMAIN="${9}"
DEPLOY_SUBDOMAIN="${10}"
DEPLOY_URL=${DEPLOY_SUBDOMAIN}.${DEPLOY_DOMAIN}

# Eliminamos
rm -rf $PATH_PUBLIC/public_html
rm -rf $PATH_PUBLIC/deploy

# Existe el subdominio
theDomainExiste=$(curl -s -H'Authorization: cpanel '${CPANEL_USER}':'${CPANEL_SECRET}'' ''${CPANEL_URL}'/execute/DomainInfo/single_domain_data?domain='${DEPLOY_URL}'' | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["'status'"]';)

# Existe la base de datos
theDatabaseExists=$(curl -s -H'Authorization: cpanel '${CPANEL_USER}':'${CPANEL_SECRET}'' ''${CPANEL_URL}'/execute/Mysql/check_database?name='${DATABASE_NAME}'' | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["'status'"]';)

# Si no existe el subdominio
if [ "$theDomainExiste" = 0 ]; then
	# Obtenemos subdominio y dominio
	IFS='.' read -r subdomain domain <<< "$DEPLOY_URL"

	# Creamos subdominio
	curl -s -H'Authorization: cpanel '${CPANEL_USER}':'${CPANEL_SECRET}'' ''${CPANEL_URL}'/execute/SubDomain/addsubdomain?domain='${DEPLOY_SUBDOMAIN}'&rootdomain='${DEPLOY_DOMAIN}'&dir='${PATH_PUBLIC}'/public_html&disallowdot=1'

	# AutoSSL
	curl -s -H'Authorization: cpanel '${CPANEL_USER}':'${CPANEL_SECRET}'' ''${CPANEL_URL}'/execute/SSL/start_autossl_check'

	# Eliminamos el directorio que crea
	rm -rf ${PATH_PUBLIC}/public_html
fi

# Si existe la base de datos
if [ "$theDatabaseExists" = 1 ]; then
	# Eliminamos database
	curl -s -H'Authorization: cpanel '${CPANEL_USER}':'${CPANEL_SECRET}'' ''${CPANEL_URL}'/execute/Mysql/delete_database?name='${DATABASE_NAME}''
fi

# Crear database
curl -s -H'Authorization: cpanel '${CPANEL_USER}':'${CPANEL_SECRET}'' ''${CPANEL_URL}'/execute/Mysql/create_database?name='${DATABASE_NAME}''

# Permisos
curl -s -H'Authorization: cpanel '${CPANEL_USER}':'${CPANEL_SECRET}'' ''${CPANEL_URL}'/execute/Mysql/set_privileges_on_database?user='${DATABASE_USER}'&database='${DATABASE_NAME}'&privileges=ALL'
