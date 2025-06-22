#!/bin/bash

echo "🔧 Instalando Apache2, PHP e módulos necessários..."
sudo apt update && sudo apt install -y \
    apache2 \
    php \
    php-cgi \
    libapache2-mod-php \
    php-mbstring \
    php-common \
    php-pear

if [ $? -ne 0 ]; then
    echo "❌ Erro ao instalar pacotes base. Verifique sua conexão ou repositórios."
    exit 1
fi

echo "📦 Instalando LDAP Account Manager..."
sudo apt install -y ldap-account-manager

if [ $? -ne 0 ]; then
    echo "❌ Erro ao instalar o ldap-account-manager."
    exit 1
fi

echo "🧩 Ativando configuração do PHP CGI (php8.2-cgi)..."
sudo a2enconf php8.2-cgi

echo "🔄 Recarregando o Apache..."
sudo systemctl reload apache2

echo "✅ Tudo instalado e configurado com sucesso!"

echo "📁 Para validar os módulos Apache habilitados, rode:"
echo "    ls /etc/apache2/mods-enabled/"