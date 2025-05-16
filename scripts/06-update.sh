#!/bin/bash
# 06-update.sh - Atualizar código-fonte do Odoo

set -e

ODOO_USER="odoo17"
ODOO_DIR="/opt/odoo17/odoo17"
SERVICE_NAME="odoo17"

echo "�� Iniciando atualização do Odoo..."

# Confirma existência do diretório
if [ ! -d "$ODOO_DIR" ]; then
  echo "❌ Diretório $ODOO_DIR não encontrado. Verifique a instalação."
  exit 1
fi

# Parar o serviço
echo "�� Parando o serviço $SERVICE_NAME..."
sudo systemctl stop "$SERVICE_NAME"

# Atualizar repositório git
echo "�� Atualizando repositório git em $ODOO_DIR..."
sudo -u "$ODOO_USER" git -C "$ODOO_DIR" pull origin 17.0

# (Opcional) Atualizar dependências
echo "�� (Opcional) Atualizando dependências Python..."
# sudo -u "$ODOO_USER" /opt/odoo17/venv/bin/pip install -r "$ODOO_DIR/requirements.txt"

# Reiniciar o serviço
echo "�� Reiniciando o serviço $SERVICE_NAME..."
sudo systemctl start "$SERVICE_NAME"
sudo systemctl status "$SERVICE_NAME" --no-pager

echo "✅ Atualização concluída com sucesso!"