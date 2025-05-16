#!/bin/bash

# 03-odoo-install.sh
# Instala o Odoo 17 a partir do GitHub, configura o ambiente virtual e dependÃªncias

set -e

ODOO_USER="odoo17"
ODOO_HOME="/opt/$ODOO_USER"
ODOO_REPO="https://github.com/odoo/odoo.git"
ODOO_VERSION="17.0"
ODOO_CONF="/etc/${ODOO_USER}.conf"

# Criar usuÃ¡rio e diretÃ³rio base caso nÃ£o existam (sÃ³ para garantir)
if ! id -u $ODOO_USER >/dev/null 2>&1; then
    sudo adduser --system --group --home $ODOO_HOME $ODOO_USER
fi

if [ ! -d "$ODOO_HOME" ]; then
    sudo mkdir -p $ODOO_HOME
    sudo chown $ODOO_USER:$ODOO_USER $ODOO_HOME
fi

# Clonar o repositÃ³rio do Odoo
if [ ! -d "$ODOO_HOME/$ODOO_VERSION" ]; then
    echo "í ¾í·© Clonando Odoo $ODOO_VERSION..."
    sudo -u $ODOO_USER git clone --depth 1 --branch $ODOO_VERSION $ODOO_REPO $ODOO_HOME/$ODOO_VERSION
fi

# Criar diretÃ³rios de addons personalizados
sudo -u $ODOO_USER mkdir -p $ODOO_HOME/$ODOO_VERSION/custom-addons

# Criar ambiente virtual Python
if [ ! -d "$ODOO_HOME/venv" ]; then
    echo "í ¾í·© Criando ambiente virtual Python..."
    sudo -u $ODOO_USER python3 -m venv $ODOO_HOME/venv
    sudo -u $ODOO_USER $ODOO_HOME/venv/bin/pip install --upgrade pip wheel setuptools
fi

# Instalar dependÃªncias do Odoo
echo "í ¾í·© Instalando dependÃªncias Python..."
sudo -u $ODOO_USER $ODOO_HOME/venv/bin/pip install -r $ODOO_HOME/$ODOO_VERSION/requirements.txt

# Instalar bibliotecas do sistema necessÃ¡rias
sudo apt install -y libldap2-dev libsasl2-dev libpq-dev libxml2-dev libxslt1-dev \
    libjpeg-dev libjpeg62-turbo-dev zlib1g-dev libevent-dev libffi-dev liblcms2-dev \
    libblas-dev libatlas-base-dev wkhtmltopdf xfonts-75dpi

# Criar arquivo de configuraÃ§Ã£o do Odoo
if [ ! -f "$ODOO_CONF" ]; then
    echo "í ¾í·© Criando arquivo de configuraÃ§Ã£o..."
    sudo tee $ODOO_CONF > /dev/null <<EOF
[options]
admin_passwd = admin
addons_path = ${ODOO_HOME}/${ODOO_VERSION}/addons,${ODOO_HOME}/${ODOO_VERSION}/custom-addons
db_host = False
db_port = False
db_user = $ODOO_USER
db_password = False
xmlrpc_port = 8069
logfile = /var/log/${ODOO_USER}.log
EOF
    sudo chown $ODOO_USER:$ODOO_USER $ODOO_CONF
    sudo chmod 640 $ODOO_CONF
fi

# Criar serviÃ§o systemd
echo "í ¾í·© Criando serviÃ§o systemd..."
sudo tee /etc/systemd/system/${ODOO_USER}.service > /dev/null <<EOF
[Unit]
Description=Odoo17
Requires=postgresql.service
After=network.target postgresql.service

[Service]
Type=simple
SyslogIdentifier=${ODOO_USER}
PermissionsStartOnly=true
User=${ODOO_USER}
Group=${ODOO_USER}
ExecStart=${ODOO_HOME}/venv/bin/python3 ${ODOO_HOME}/${ODOO_VERSION}/odoo-bin -c ${ODOO_CONF}
StandardOutput=journal+console
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable ${ODOO_USER}.service
sudo systemctl start ${ODOO_USER}.service

echo "âœ… Odoo instalado e serviÃ§o iniciado!"