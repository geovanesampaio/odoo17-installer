# Odoo 17 Installer para Debian 12

Este projeto instala o Odoo 17 em servidores Debian 12 (Bookworm) usando um menu interativo e scripts modulares.

## 📦 Estrutura do Projeto

```
odoo17-installer/
├── run-menu.sh               # Menu interativo
├── scripts/                  # Scripts modulares
│   ├── 01-system-setup.sh    # Atualização e dependências
│   ├── 02-postgres-setup.sh  # PostgreSQL
│   ├── 03-odoo-install.sh     # Odoo 17 + virtualenv
│   └── 04-nginx-ssl.sh        # Nginx + Let's Encrypt SSL
├── .env.example              # Variáveis de ambiente (modelo)
├── LICENSE                   # Licença MIT
└── README.md                 # Este arquivo
```

## 🚀 Como usar

```bash
git clone https://github.com/geovanesampaio/odoo17-installer.git
cd odoo17-installer
chmod +x run-menu.sh
./run-menu.sh
```

## ⚙️ Pré-requisitos

- Debian 12 Bookworm
- Acesso root (ou sudo)
- Domínio configurado apontando para a VPS

## 🔐 Certificado SSL

Certificados gratuitos via Let's Encrypt são gerados na etapa 4 (`04-nginx-ssl.sh`).

## 📄 Licença

MIT © 2025 Geovane Sampaio
