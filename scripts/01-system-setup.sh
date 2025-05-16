odoo17-installer/
+-- run-menu.sh             # Menu interativo
+-- scripts/                # Scripts modulares
¦   +-- 01-system-setup.sh
¦   +-- 02-postgres-setup.sh
¦   +-- 03-odoo-install.sh
¦   +-- 04-nginx-ssl.sh
+-- LICENSE                 # Licença MIT
+-- README.md               # Este arquivo

# scripts/01-system-setup.sh
#!/bin/bash
set -e

echo "[INFO] Atualizando sistema e instalando dependências..."
sudo apt update && sudo apt upgrade -y

# Dependências básicas
sudo apt install -y git wget curl build-essential python3-pip python3-dev python3-venv \
                     libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools \
                     node-less libjpeg-dev libpq-dev gcc g++ libxml2-dev libffi-dev \
                     libssl-dev libxrender1 libxext6 xfonts-75dpi xfonts-base \
                     fonts-noto libjpeg62-turbo-dev liblcms2-dev libblas-dev \
                     libatlas-base-dev libtiff-dev

# wkhtmltopdf compatível com Odoo
echo "[INFO] Instalando wkhtmltopdf..."
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bookworm_amd64.deb -P /tmp
sudo apt install -y /tmp/wkhtmltox_0.12.6-1.bookworm_amd64.deb

# Criar usuário odoo
read -p "[?] Nome do usuário para o Odoo (ex: odoo17): " ODOO_USER
sudo adduser --system --home=/opt/$ODOO_USER --group $ODOO_USER
sudo usermod -aG sudo $ODOO_USER

echo "[OK] Sistema preparado com sucesso."
