#!/bin/bash

echo "🔧 Instalando pacotes necessários para integração LDAP..."
sudo apt update && sudo apt install -y \
    libnss-ldapd \
    libpam-ldapd \
    ldap-utils

if [ $? -ne 0 ]; then
    echo "❌ Erro na instalação dos pacotes LDAP. Verifique sua conexão ou repositórios."
    exit 1
fi

echo "📘 Pacotes instalados com sucesso."

echo "🧠 Lembre-se de configurar manualmente os arquivos LDAP com:"
echo "    - /etc/nslcd.conf       (configuração do cliente LDAP)"
echo "    - /etc/nsswitch.conf    (para habilitar 'ldap' em passwd, group, shadow)"
echo "    - /etc/pam.d/common-auth, common-session, common-account (para autenticação PAM)"

echo "🔁 Reiniciando serviços para aplicar configurações..."
sudo systemctl restart nslcd
sudo systemctl restart nscd || echo "⚠️ Serviço nscd não encontrado (pode ignorar)"

echo "✅ Cliente LDAP pronto para ser configurado!"