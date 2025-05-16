### scripts/05-security.sh
#!/bin/bash

set -e

# Firewall
echo "������ Configurando UFW..."
apt install ufw -y
ufw allow OpenSSH
ufw allow 8069
ufw allow 'Nginx Full'
ufw --force enable

# Fail2Ban
echo "������ Instalando Fail2Ban..."
apt install fail2ban -y
systemctl enable --now fail2ban

### scripts/06-update.sh
#!/bin/bash

set -e

ODOO_DIR="/opt/odoo17/odoo17"

if [ -d "$ODOO_DIR" ]; then
  echo "������ Atualizando Odoo..."
  cd "$ODOO_DIR"
  sudo -u odoo17 git pull origin 17.0
else
  echo "❌ Diretório Odoo não encontrado em $ODOO_DIR"
  exit 1
fi

### requirements.txt
psycopg2-binary
babel
werkzeug
pytz
lxml
passlib
phonenumbers
pdf2image
PyPDF2
reportlab
xlrd
xlwt

### README.md
# Odoo 17 Installer - Debian 12

Instalador modular e interativo para Odoo 17 com SSL, firewall e segurança.

## Pré-requisitos
```bash
sudo apt update && sudo apt install -y git whiptail
```

## Uso
```bash
git clone https://github.com/seuusuario/odoo17-installer.git
cd odoo17-installer
chmod +x run-menu.sh
./run-menu.sh
```

## Estrutura
```
odoo17-installer/
├── run-menu.sh             # Menu interativo
├── scripts/                # Scripts modulares
│   ├── 01-system-setup.sh
│   ├── 02-postgres-setup.sh
│   ├── 03-odoo-install.sh
│   ├── 04-nginx-ssl.sh
│   ├── 05-security.sh
│   └── 06-update.sh
├── requirements.txt
├── LICENSE
└── README.md
```

## Recursos
- Instalação modular
- Ambiente virtual Python
- Firewall UFW + Fail2Ban
- Nginx com SSL Let's Encrypt
- Atualização via Git

MIT License
