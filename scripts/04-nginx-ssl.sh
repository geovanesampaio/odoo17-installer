#!/bin/bash

# Caminho base do projeto
ODOO_DOMAIN=${ODOO_DOMAIN:-"odoo.exemplo.com"}
ODOO_PORT=${ODOO_PORT:-8069}
EMAIL_SSL=${EMAIL_SSL:-"seu@email.com"}
NGINX_CONF_PATH="/etc/nginx/sites-available/$ODOO_DOMAIN"
ODOO_CONF="/etc/odoo17.conf"

# Verifica se domínio foi passado
if [[ -z "$ODOO_DOMAIN" || -z "$EMAIL_SSL" ]]; then
    echo "? Domínio ou e-mail para SSL não definido."
    echo "Edite o arquivo .env ou exporte as variáveis ODOO_DOMAIN e EMAIL_SSL."
    exit 1
fi

echo "?? Configurando Nginx para o domínio: $ODOO_DOMAIN"

# Instala nginx e certbot
sudo apt install -y nginx certbot python3-certbot-nginx

# Cria arquivo de configuração do Nginx
sudo tee "$NGINX_CONF_PATH" > /dev/null <<EOF
server {
    listen 80;
    server_name $ODOO_DOMAIN;

    access_log /var/log/nginx/odoo.access.log;
    error_log /var/log/nginx/odoo.error.log;

    proxy_read_timeout 720s;
    proxy_connect_timeout 720s;
    proxy_send_timeout 720s;

    client_max_body_size 200m;

    location / {
        proxy_pass http://127.0.0.1:$ODOO_PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forward-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Ativa configuração e reinicia nginx
sudo ln -s "$NGINX_CONF_PATH" /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Solicita certificado SSL
echo "?? Gerando certificado SSL com Let's Encrypt..."
sudo certbot --nginx -d "$ODOO_DOMAIN" --non-interactive --agree-tos -m "$EMAIL_SSL" --redirect

# Confirma sucesso
if [ $? -eq 0 ]; then
    echo "? SSL habilitado com sucesso!"
else
    echo "? Erro ao configurar o SSL"
fi