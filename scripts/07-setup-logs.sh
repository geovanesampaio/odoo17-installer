#!/bin/bash
set -e

ODOO_USER="odoo17"
LOG_FILE="/var/log/${ODOO_USER}.log"

echo "í ¾í·© Criando arquivo de log e definindo permissÃµes..."
sudo touch $LOG_FILE
sudo chown $ODOO_USER:$ODOO_USER $LOG_FILE
sudo chmod 640 $LOG_FILE

echo "âœ… Arquivo de log pronto em $LOG_FILE"
