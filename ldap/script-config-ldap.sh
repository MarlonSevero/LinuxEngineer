#!/bin/bash

# Script para configurar OpenLDAP com cn=config + migrationtools
# Autor: Seu Mordomo do Batman 🦇

set -e

echo "==> Atualizando pacotes e instalando dependências..."
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install slapd ldap-utils migrationtools -y

echo "==> Reconfigurando slapd interativamente..."
dpkg-reconfigure slapd

echo "==> Verificando estrutura base LDAP..."
cat <<EOF > /tmp/base.ldif
dn: ou=People,dc=asf,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=asf,dc=com
objectClass: organizationalUnit
ou: Group
EOF

echo "==> Importando estrutura base (ou=People, ou=Group)..."
ldapadd -x -D cn=admin,dc=asf,dc=com -W -f /tmp/base.ldif

echo "==> Configurando migrationtools..."
sed -i 's/\$DEFAULT_MAIL_DOMAIN.*/$DEFAULT_MAIL_DOMAIN = "asf.com";/' /usr/share/migrationtools/migrate_common.ph
sed -i 's/\$DEFAULT_BASE.*/$DEFAULT_BASE = "dc=asf,dc=com";/' /usr/share/migrationtools/migrate_common.ph

echo "==> Gerando LDIF de usuários e grupos locais..."
cd /usr/share/migrationtools
./migrate_passwd.pl /etc/passwd > /tmp/users.ldif
./migrate_group.pl /etc/group > /tmp/groups.ldif

echo "==> Importando usuários e grupos para o LDAP..."
ldapadd -x -D cn=admin,dc=asf,dc=com -W -f /tmp/users.ldif
ldapadd -x -D cn=admin,dc=asf,dc=com -W -f /tmp/groups.ldif

echo "✅ OpenLDAP configurado com sucesso com estrutura base e dados locais!"