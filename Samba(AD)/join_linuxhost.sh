//Join Linux Host

# ALL COMMANDS
--------------------------------------------------------------------------------
apt -y install realmd sssd sssd-tools libnss-sss libpam-sss adcli \
samba-common-bin oddjob oddjob-mkhomedir packagekit krb5-user
realm discover asf.com
kinit Administrator
realm join -v asf.com
cp sssd.conf /etc/sssd/ (opcional)
systemctl restart sssd
pam-auth-update
systemctl restart sssd
--------------------------------------------------------------------------------

🔗 Join Linux Host ao Active Directory (asf.com)

# 1. Instala os pacotes necessários para integração com o AD
apt -y install realmd sssd sssd-tools libnss-sss libpam-sss adcli \
samba-common-bin oddjob oddjob-mkhomedir packagekit krb5-user

# 2. Descobre as configurações do domínio AD
realm discover asf.com

# 3. Gera o ticket Kerberos com o usuário do AD
kinit Administrator

# 4. Verifica se o ticket Kerberos foi criado com sucesso
klist

# 5. Junta o host ao domínio AD (com verbose para debug se necessário)
realm join -v asf.com

# 6. (Opcional) Copia a configuração customizada do SSSD, se existir
cp sssd.conf /etc/sssd/

# 7. Atualiza a configuração PAM para permitir login com contas do AD
pam-auth-update

# 8. Reinicia o serviço SSSD para aplicar todas as configurações
systemctl restart sssd


⸻

✅ Teste de login após join:

id administrator@asf.com
getent passwd usuario@asf.com

Se retornar o ID do usuário, o domínio foi vinculado com sucesso.