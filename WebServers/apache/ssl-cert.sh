# 📘 HOW-TO: Apache + SSL com Certificado Autoassinado (Self-signed)

## 🎯 Objetivo:
Habilitar acesso HTTPS com certificado SSL autoassinado para um site hospedado em /srv/www/express.

---

## ✅ 1. Criar diretório e gerar o certificado

sudo mkdir -p /etc/ssl/express
cd /etc/ssl/express

# Gerar a chave privada
openssl genrsa -out express.key 2048

# Gerar o CSR (pode preencher com qualquer info)
openssl req -new -key express.key -out express.csr

# Gerar o certificado autoassinado
openssl x509 -req -days 365 -in express.csr -signkey express.key -out express.crt

## ✅ 2. Habilitar módulos necessários no Apache

sudo a2enmod ssl
sudo a2enmod rewrite
sudo systemctl restart apache2

## ✅ 3. Criar o VirtualHost HTTPS

sudo nano /etc/apache2/sites-available/express-ssl.conf
    Conteudo:
        <VirtualHost *:443>
        ServerName intranet.asf.com
        DocumentRoot /srv/www/express

        SSLEngine on
        SSLCertificateFile /etc/ssl/express/express.crt
        SSLCertificateKeyFile /etc/ssl/express/express.key

        <Directory /srv/www/express>
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/express-error.log
        CustomLog ${APACHE_LOG_DIR}/express-access.log combined
    </VirtualHost>

## ✅ 4. Criar o VirtualHost para redirecionamento HTTP → HTTPS

sudo nano /etc/apache2/sites-available/express-redirect.conf
    Conteudo:
    <VirtualHost *:80>
        ServerName intranet.asf.com
        DocumentRoot /srv/www/express

        RewriteEngine On
        RewriteCond %{HTTPS} off
        RewriteRule ^/?(.*)$ https://%{SERVER_NAME}/$1 [R=301,L]

        <Directory /srv/www/express>
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>
    </VirtualHost>

## ✅ 5. Ativar os sites e recarregar Apache

sudo a2ensite express-ssl.conf
sudo a2ensite express-redirect.conf

sudo apache2ctl configtest
sudo systemctl reload apache2

## ✅ 6. (Opcional) Adicionar ao /etc/hosts para testes locais

sudo nano /etc/hosts
# Adicione a linha abaixo:
192.168.64.10 intranet.asf.com


🧪 7. Testar

https://intranet.asf.com