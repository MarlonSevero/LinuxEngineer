Claro! Aqui está o passo a passo completo e copiável de uma só vez para configurar autenticação via LDAP no Apache2 (nível de servidor web):

⸻

✅ 1. Pré-requisitos

Instale e ative os módulos necessários:

sudo apt update
sudo apt install apache2 -y

# Ativar os módulos necessários
sudo a2enmod ldap
sudo a2enmod authnz_ldap
sudo systemctl restart apache2


⸻

🧱 2. Exemplo de estrutura LDAP
	•	Domínio: dc=asf,dc=com
	•	Unidade de pessoas: ou=People
	•	Exemplo de usuário: uid=jose,ou=People,dc=asf,dc=com

⸻

📁 3. Diretório protegido

Vamos proteger:
/srv/www/express/softwares/

⸻

🧾 4. Criar arquivo de site no Apache

Crie o arquivo:

sudo nano /etc/apache2/sites-available/express.conf

Cole o conteúdo abaixo e edite as partes com seu-certificado.pem, sua-chave.key e senha_do_admin_aqui:

<VirtualHost *:443>
    ServerName express.asf.com
    DocumentRoot "/srv/www/express/softwares"

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/seu-certificado.pem
    SSLCertificateKeyFile /etc/ssl/private/sua-chave.key

    <Directory "/srv/www/express/softwares">
        Options Indexes FollowSymLinks
        AllowOverride None
        SSLRequireSSL

        AuthType Basic
        AuthName "Autenticação via LDAP"
        AuthBasicProvider ldap

        AuthLDAPURL "ldap://192.168.1.10:389/ou=People,dc=asf,dc=com?uid?sub?(objectClass=*)"
        AuthLDAPBindDN "cn=admin,dc=asf,dc=com"
        AuthLDAPBindPassword "senha_do_admin_aqui"

        Require valid-user
    </Directory>
</VirtualHost>


⸻

🚀 5. Ativar o site e reiniciar Apache

sudo a2ensite express.conf
sudo systemctl reload apache2


⸻

🔐 6. Testar a autenticação

Abra no navegador:

https://express.asf.com/softwares

Digite o usuário e senha do LDAP, como jose / senha123.

⸻

🧪 Testar via terminal

curl -u jose https://express.asf.com/softwares
