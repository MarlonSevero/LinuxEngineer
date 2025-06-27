#Provisioning a Domain Controller (AD DC) with Samba on Linux


# ALL COMMANDS
--------------------------------------------------------------------------------
apt update -y 
apt install samba krb5-config krb5-user winbind smbclient -y 
mv /etc/smb.conf /var/backup
samba-tool domain provision --use-rfc2307 --interactive 
cp /var/lib/samba/private/krb5.conf /etc/
vim /etc/krb5.conf 
systemctl stop smdb winbind nmdb 
systemctl disable winbind winbind nmdb 
systemctl unmask samba-ad-dc
systemctl enable samba-ad-dc
systemctl start samba-ad-dc
vim /etc/resolv.conf (add proprio servidor como dns)
samba-tool group list
samba-tool gpo listall (teste deve retornar as gpo default)
kinit Administrator 
klist 
-------------------------------------------------------------------------------------

📦 1. Atualizar o sistema e instalar pacotes necessários

apt update -y && apt upgrade -y
apt install samba krb5-config krb5-user winbind smbclient -y

⸻

🗄️ 2. Backup do smb.conf original

mv /etc/samba/smb.conf /var/backup/smb.conf.bkp

⸻

⚙️ 3. Provisionar o domínio com Samba

samba-tool domain provision --use-rfc2307 --interactive

Durante a configuração interativa:
	•	Realm: EXEMPLO.LOCAL
	•	Domain: EXEMPLO
	•	Server Role: dc
	•	DNS backend: SAMBA_INTERNAL (ou BIND9_DLZ se for usar bind)
	•	Senha: defina uma forte para o Administrator

⸻

🔁 4. Substituir o krb5.conf pelo gerado pelo Samba

cp /var/lib/samba/private/krb5.conf /etc/
#Opcionalmente, revise com vim /etc/krb5.conf
⸻

🛑 5. Parar e desabilitar serviços conflitantes

systemctl stop smbd nmbd winbind
systemctl disable smbd nmbd winbind
⸻

🚀 6. Ativar e iniciar o serviço do Samba como AD DC

systemctl unmask samba-ad-dc
systemctl enable samba-ad-dc
systemctl start samba-ad-dc
⸻

🌐 7. Configurar o DNS para apontar para si mesmo

vim /etc/resolv.conf:
	+nameserver 127.0.0.1
	+search exemplo.local

#Substitua exemplo.local pelo seu domínio.
⸻

✅ 8. Testes básicos de funcionamento

🔹 Listar grupos do domínio:
samba-tool group list

🔹 Verificar GPOs padrão:
samba-tool gpo listall

Deve exibir: Default Domain Policy e Default Domain Controllers Policy
⸻

🔐 9. Testar autenticação Kerberos

kinit Administrator
klist

Se tudo estiver correto, o klist exibirá um ticket Kerberos válido.

smbclient -L ad -U Administrator
----

⚙️ Scripts auxiliares (administração do ambiente)

Execute os scripts abaixo conforme a necessidade:
	•	./userandgroups.sh → Cria grupos e usuários locais no Linux.
	•	./add_users.sh → Adiciona os usuários ao Active Directory.
	•	./add_groups → Adiciona os grupos ao AD.
	•	./set_passwords → Define senhas para os usuários criados.
	•	./gid_migrate → Migra os GIDs locais para o AD.
	•	cp -a logon.vbs /var/lib/samba/sysvol/asf.com/scripts/ → Copia o script de logon para o local correto no SYSVOL.

#Monitoring
chgrp users /var/lib/samba/sysvol/asf.com/scripts    # Altera o grupo do diretório de scripts para 'users'
pdbedit -Lv analista                                  # Mostra detalhes do usuário 'analista' no banco do Samba
systemctl restart samba-ad-dc                         # Reinicia o serviço do controlador de domínio Samba AD
smbclient -L ad -U administrator                      # Lista os compartilhamentos do AD usando o usuário 'administrator'
nmblookup -S ad                                       # Resolve o nome NetBIOS e exibe info do servidor AD
