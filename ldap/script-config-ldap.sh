#!/bin/bash
# Script para configurar OpenLDAP com slapd.conf e backend MDB

set -e

echo "==> Instalando pacotes necessários..."
apt update && apt install slapd ldap-utils -y

echo "==> Copiando slapd.conf de exemplo..."
cp -a /usr/share/doc/slapd/examples/slapd.conf /etc/ldap/

echo "==> Por favor, edite o /etc/ldap/slapd.conf manualmente agora!"
echo "    Comandos recomendados:"
echo "    - Adicione 'moduleload back_mdb'"
echo "    - Configure 'database mdb'"
echo "    - Execute 'slappasswd' para gerar senha e coloque no rootpw"
read -p "Pressione ENTER após editar o arquivo para continuar..."

echo "==> Fazendo backup e recriando slapd.d..."
mv /etc/ldap/slapd.d /var/backups/slapd.d.$(date +%s) || true
mkdir -pv /etc/ldap/slapd.d

echo "==> Corrigindo permissões..."
chown -R openldap:openldap /var/lib/ldap /etc/ldap/slapd.conf

echo "==> Configurando slapd para usar slapd.conf..."
sed -i '/^SLAPD_CONF/d' /etc/default/slapd
echo 'SLAPD_CONF="/etc/ldap/slapd.conf"' >> /etc/default/slapd
echo 'SLAPD_ARGS=""' >> /etc/default/slapd

echo "==> Validando configuração com slaptest..."
slaptest -f /etc/ldap/slapd.conf -F /etc/ldap/slapd.d

echo "==> Reiniciando serviço slapd..."
systemctl restart slapd
systemctl enable slapd

echo "✅ OpenLDAP configurado com sucesso usando backend MDB e slapd.conf."