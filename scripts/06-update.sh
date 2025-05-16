#!/bin/bash
# 06-update.sh - Atualizar c√≥digo-fonte do Odoo

set -e

ODOO_USER="odoo17"
ODOO_DIR="/opt/odoo17/odoo17"
SERVICE_NAME="odoo17"

echo "Ì†ΩÌ¥Ñ Iniciando atualiza√ß√£o do Odoo..."

# Confirma exist√™ncia do diret√≥rio
if [ ! -d "$ODOO_DIR" ]; then
  echo "‚ùå Diret√≥rio $ODOO_DIR n√£o encontrado. Verifique a instala√ß√£o."
  exit 1
fi

# Parar o servi√ßo
echo "Ì†ΩÌªë Parando o servi√ßo $SERVICE_NAME..."
sudo systemctl stop "$SERVICE_NAME"

# Atualizar reposit√≥rio git
echo "Ì†ΩÌ≥¶ Atualizando reposit√≥rio git em $ODOO_DIR..."
sudo -u "$ODOO_USER" git -C "$ODOO_DIR" pull origin 17.0

# (Opcional) Atualizar depend√™ncias
echo "Ì†ΩÌ≥¶ (Opcional) Atualizando depend√™ncias Python..."
# sudo -u "$ODOO_USER" /opt/odoo17/venv/bin/pip install -r "$ODOO_DIR/requirements.txt"

# Reiniciar o servi√ßo
echo "Ì†ΩÌ∫Ä Reiniciando o servi√ßo $SERVICE_NAME..."
sudo systemctl start "$SERVICE_NAME"
sudo systemctl status "$SERVICE_NAME" --no-pager

echo "‚úÖ Atualiza√ß√£o conclu√≠da com sucesso!"