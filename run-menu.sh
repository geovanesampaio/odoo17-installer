# Estrutura do Projeto
odoo17-installer/
+-- run-menu.sh             # Menu interativo
+-- scripts/                # Scripts modulares
¦   +-- 01-system-setup.sh
¦   +-- 02-postgres-setup.sh
¦   +-- 03-odoo-install.sh
¦   +-- 04-nginx-ssl.sh
¦   +-- 05-security.sh       # Segurança e firewall
¦   +-- 06-update.sh         # Atualização completa
+-- LICENSE                 # Licença MIT
+-- README.md               # Este arquivo

# run-menu.sh
#!/bin/bash

while true; do
    OPTION=$(whiptail --title "Odoo 17 Installer" --menu "Escolha uma opção:" 20 60 10 \
    "1" "Instalar dependências do sistema" \
    "2" "Instalar e configurar PostgreSQL" \
    "3" "Instalar Odoo 17" \
    "4" "Configurar Nginx + SSL" \
    "5" "Aplicar segurança (UFW, Fail2Ban)" \
    "6" "Atualizar sistema e Odoo" \
    "7" "Configurar logs do Odoo" \
    "0" "Sair" 3>&1 1>&2 2>&3)

    case $OPTION in
        1) bash scripts/01-system-setup.sh;;
        2) bash scripts/02-postgres-setup.sh;;
        3) bash scripts/03-odoo-install.sh;;
        4) bash scripts/04-nginx-ssl.sh;;
        5) bash scripts/05-security.sh;;
        6) bash scripts/06-update.sh;;
        7) bash scripts/07-setup-logs.sh;;
        0) exit;;
        *) echo "Opção inválida.";;
    esac
done

# scripts/01-system-setup.sh
#!/bin/bash
set -e

echo "[INFO] Atualizando pacotes e instalando dependências..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3-pip build-essential wget git python3-dev python3-venv \
    libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools \
    node-less libjpeg-dev libpq-dev gcc g++ libxml2-dev libffi-dev libjpeg8-dev \
    liblcms2-dev libblas-dev libatlas-base-dev wkhtmltopdf xfonts-75dpi

# scripts/02-postgres-setup.sh
#!/bin/bash
set -e

ODOO_USER=odoo17
DB_USER=odoo17
DB_PASS=odoo17

sudo apt install -y postgresql
sudo -u postgres createuser --createdb --username postgres --no-createrole --no-superuser $DB_USER || true
sudo -u postgres psql -c "ALTER USER $DB_USER WITH PASSWORD '$DB_PASS';"

sudo adduser --system --home /opt/$ODOO_USER --group $ODOO_USER || true

# scripts/03-odoo-install.sh
#!/bin/bash
set -e

ODOO_USER=odoo17
ODOO_HOME=/opt/$ODOO_USER
ODOO_REPO=https://www.github.com/odoo/odoo.git
ODOO_VERSION=17.0

if [ ! -d $ODOO_HOME ]; then
  sudo mkdir -p $ODOO_HOME
  sudo chown $ODOO_USER:$ODOO_USER $ODOO_HOME
fi

sudo -u $ODOO_USER git clone --depth 1 --branch $ODOO_VERSION $ODOO_REPO $ODOO_HOME/$ODOO_USER

# Ambiente virtual
sudo -u $ODOO_USER python3 -m venv $ODOO_HOME/venv
sudo -u $ODOO_USER $ODOO_HOME/venv/bin/pip install --upgrade pip wheel setuptools
sudo -u $ODOO_USER $ODOO_HOME/venv/bin/pip install -r $ODOO_HOME/$ODOO_USER/requirements.txt

# Arquivo de configuração
cat <<EOF | sudo tee /etc/$ODOO_USER.conf
[options]
admin_passwd = admin
addons_path = $ODOO_HOME/$ODOO_USER/addons,$ODOO_HOME/$ODOO_USER/custom-addons
db_host = False
db_port = False
db_user = $ODOO_USER
db_password = False
logfile = /var/log/$ODOO_USER.log
EOF

# Serviço systemd
cat <<EOF | sudo tee /etc/systemd/system/$ODOO_USER.service
[Unit]
Description=Odoo17
Requires=postgresql.service
After=network.target postgresql.service

[Service]
Type=simple
SyslogIdentifier=$ODOO_USER
PermissionsStartOnly=true
User=$ODOO_USER
Group=$ODOO_USER
ExecStart=$ODOO_HOME/venv/bin/python3 $ODOO_HOME/$ODOO_USER/odoo-bin -c /etc/$ODOO_USER.conf
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable $ODOO_USER
sudo systemctl start $ODOO_USER
