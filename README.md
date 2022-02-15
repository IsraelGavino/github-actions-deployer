<p align="center">
  <a href="https://www.denox.es/">
    <img src="https://flex.oscdenox.com/logo_oscdenox_addons.png" width="142px" height="190px"/>
  </a>
</p>

<h1 align="center">
  🚀 Deployment tool
</h1>


<p align="center">
  Herramienta de <strong>despliegue</strong> escrita en bash preparada con Docker para funcionar en cualquier lugar.
  <br />
  <br />
  Basado en: https://github.com/deployphp/deployer</p>
</p>

## 🚀 Configuración

### 🐳 Herramientas necesarias

1. Instalar Docker
2. Clonar el proyecto: `git clone https://github.com/denoxES/github-actions-deployer.git`
3. Moverse al directorio: `cd github-actions-deployer`


## 👩‍💻 Explicación del proyecto

Se necesita tener clave privada para la conexión SSH. Una vez configurada en el servidor y host podrás lanzar el despliegue desde cualquier lugar.

## 🔥 Como ejecutar

### 🔑 Obtener llave

`KEY_PASS="$(cat ~/.ssh/id_rsa)"`

### 🐳 Docker

`docker build --no-cache --progress=plain -t github-actions-deployer . && docker run --rm github-actions-deployer:latest \
CLEAN_UP \
SSH_HOST \
SSH_PORT \
SSH_USER \
SSH_KEY \
KEEP_RELEASES \
PATH_PUBLIC \
DIRS_SHARE \
FILES_SHARE \
BRANCH_NAME \
CPANEL_URL \
CPANEL_USER \
CPANEL_KEY \
DATABASE_HOST \
DATABASE_NAME \
DATABASE_USER \
DATABASE_PASSWORD \
DEPLOY_DOMAIN \
DEPLOY_SUBDOMAIN \
USERNAME \
GITHUB_TOKEN \
GITHUB_REPOSITORY`

### 🐳 Ejemplo

`docker build --no-cache --progress=plain -t github-actions-deployer . && docker run --rm github-actions-deployer:latest \
false \
dominio.com \
22 \
denox \
"$KEY_PASS" \
5 \
/home/denox/public_html/sampedro/github-trash \
"images temp feeds cache" \
"sitemap.xml includes/configure.php" \
develop \
https://dominio.com:2083 \
denox \
534SFRDT3465EFSER12313 \
localhost \
denox_github_trash \
denox_denox \
"#jttm38245" \
denox.com \
trash \
jose-sampedro \
ghp_XASD3245rf34534651223 \
denoxES/denox-denox`

### 👩‍💻 Parametros

* CLEAN_UP:
    * type: boolean
    * required: false
    * default: false
* SSH_HOST:
    * description: 'Host SSH'
    * required: true
* SSH_PORT:
    * description: 'Port SSH'
    * required: false
    * default: '22'
* SSH_USER:
    * description: 'User SSH'
    * required: true
* SSH_KEY:
    * description: 'Key SSH'
    * required: true
* KEEP_RELEASES:
    * description: 'Number of releases stored'
    * required: false
    * default: 5
* PATH_PUBLIC:
    * description: 'Path deployment'
    * required: true
* DIRS_SHARE:
    * description: 'List of dirs what will be shared between releases'
    * required: false
    * default: ''
* FILES_SHARE:
    * description: 'List of files what will be shared between releases'
    * required: false
    * default: ''
* BRANCH_NAME:
    * description: 'Branch name deployment'
    * required: true
* CPANEL_URL:
    * description: 'Cpanel URL'
    * required: false
    * default: ''
* CPANEL_USER:
    * description: 'Cpanel User'
    * required: false
    * default: ''
* CPANEL_KEY:
    * description: 'Cpanel token key'
    * required: false
    * default: ''
* DATABASE_HOST:
    * description: 'Database host'
    * required: false
    * default: ''
* DATABASE_NAME:
    * description: 'Database name'
    * required: false
* DATABASE_USER:
    * description: 'Database user'
    * required: false
* DATABASE_PASSWORD:
    * description: 'Database password'
    * required: false
    * default: ''
* DEPLOY_DOMAIN:
    * description: 'Deploy domain'
    * required: false
    * default: ''
* DEPLOY_SUBDOMAIN:
    * description: 'Deploy subdomain'
    * required: false
    * default: ''
* USERNAME:
    * description: 'User performing the deployment'
    * required: true
* GITHUB_TOKEN:
    * description: 'Token Github'
    * required: true
* GITHUB_REPOSITORY:
    * description: 'Repository Github'
    * required: true