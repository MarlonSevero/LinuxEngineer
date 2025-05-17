🧩 Etapa 1: Instalação dos pacotes necessários

sudo apt update
sudo apt install slapd ldap-utils migrationtools -y

🧩 Etapa 2: Reconfiguração do slapd

sudo dpkg-reconfigure slapd
    •	Nome do domínio: asf.com
	•	Organização: Algo como “ASF”
	•	Senha do admin LDAP: digite e confirme uma senha
	•	Backend: MDB
	•	Não usar slapd.conf
	•	Permitir base vazia: Não
	•	Mover a base antiga: Sim

🧩 Etapa 3: Criar estrutura base do diretório (People e Group)

    Crie o arquivo base.ldif:
    dn: ou=People,dc=asf,dc=com
    objectClass: organizationalUnit
    ou: People

    dn: ou=Group,dc=asf,dc=com
    objectClass: organizationalUnit
    ou: Group

ldapadd -x -D cn=admin,dc=asf,dc=com -W -f base.ldif

🧩 Etapa 4: Configurar migrationtools

sudo vim /usr/share/migrationtools/migrate_common.ph
    $DEFAULT_MAIL_DOMAIN = "asf.com";
    $DEFAULT_BASE = "dc=asf,dc=com";

🧩 Etapa 5: Gerar LDIF de usuários e grupos do sistema
    cd /usr/share/migrationtools
    ./migrate_passwd.pl /etc/passwd > /tmp/users.ldif
    ./migrate_group.pl /etc/group > /tmp/groups.ldif

🧩 Etapa 6: Importar os dados para o LDAP

    ldapadd -x -D cn=admin,dc=asf,dc=com -W -f /tmp/users.ldif
    ldapadd -x -D cn=admin,dc=asf,dc=com -W -f /tmp/groups.ldif

🔄 Verificação

    ldapsearch -x -b dc=asf,dc=com

🧩 Etapa 7: Reiniciar o servico e fazer um backup inicial
    systemctl restart slapd
    systemctl enable slapd 
    slapcat -l /var/backups/bkp_slapd.ldif