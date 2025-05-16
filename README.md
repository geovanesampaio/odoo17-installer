![ChatGPT Image 15 de mai  de 2025, 11_42_30](https://github.com/user-attachments/assets/18f1ecfd-c15c-41be-905a-7017a1e38ec2)





# Odoo 17 Installer - Menu Interativo

Instale o Odoo 17 no Debian 12 de forma fácil, modular e segura usando um menu interativo baseado em `whiptail`.

## 📦 Funcionalidades

- Instalação de dependências do sistema e PostgreSQL
- Instalação do Odoo 17
- Configuração de domínio e certificado SSL com Nginx
- Reinicialização do serviço Odoo
- Interface simples via menu interativo

---

## 🚀 Como usar

### 1. Faça o download e extraia o projeto:
```bash
wget https://github.com/geovanesampaio/odoo17-installer/archive/refs/heads/main.zip
unzip main.zip
cd odoo17-installer
```

### 2. Dê permissão de execução:
```bash
chmod +x run-menu.sh
chmod +x scripts/*.sh
```

### 3. Execute o instalador:
```bash
./run-menu.sh
```

Você verá um menu com as opções numeradas. Vá executando uma por uma conforme a sua necessidade.

---

## 🧩 Estrutura do Projeto
```
# Estrutura do Projeto
odoo17-installer/
+-- run-menu.sh             # Menu interativo
+-- scripts/                # Scripts modulares
¦   +-- 01-system-setup.sh
¦   +-- 02-postgres-setup.sh
¦   +-- 03-odoo-install.sh
¦   +-- 04-nginx-ssl.sh
¦   +-- 05-security.sh      # Segurança e firewall
¦   +-- 06-update.sh        # Atualização completa
¦   +-- 07-setup-logs.sh    # log
+-- LICENSE                 # Licença MIT
+-- README.md               # Este arquivo

```

---

## 📄 Licença
Distribuído sob a Licença MIT. Veja `LICENSE` para mais informações.

---

## ✍️ Autor
**Geovane Sampaio**

Dúvidas ou sugestões? Crie um [issue no repositório](https://github.com/geovanesampaio/odoo17-installer).
