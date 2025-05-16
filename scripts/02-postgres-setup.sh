#!/bin/bash

set -e

# Variáveis
ODOO_DB_USER=${ODOO_DB_USER:-odoo17}
ODOO_DB_PASS=${ODOO_DB_PASS:-odoo_db_pass}

# Instalar e iniciar o PostgreSQL
apt install -y postgresql
systemctl enable postgresql
systemctl start postgresql

# Criar usuário PostgreSQL
sudo -u postgres psql -c "DO $$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = '${ODOO_DB_USER}'
   ) THEN
      CREATE ROLE ${ODOO_DB_USER} WITH LOGIN PASSWORD '${ODOO_DB_PASS}';
   END IF;
END
$$;"

# Garantir permissões
sudo -u postgres psql -c "ALTER ROLE ${ODOO_DB_USER} CREATEDB;"

# Confirmação
echo "? Banco de dados PostgreSQL configurado para o usuário '${ODOO_DB_USER}'"
