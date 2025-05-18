🔐 Autenticação HTTP no Apache2 (nível de servidor)

✅ 1. Habilitar os módulos necessários

Antes de tudo, certifique-se de que os módulos de autenticação estão habilitados:

sudo a2enmod auth_basic
sudo a2enmod authn_file
sudo systemctl restart apache2


⸻

📁 2. Criar o arquivo de senhas (htpasswd)

Você pode usar o comando htpasswd para criar o arquivo com os usuários autorizados:

sudo htpasswd -c /etc/apache2/.htpasswd usuario1

Use -c somente na primeira vez (para criar o arquivo). Para adicionar mais usuários, não use -c.

⸻

📄 3. Configurar o .htaccess ou o Virtual Host

Diretamente no arquivo de configuração do Apache (mais seguro)

No 000-default.conf ou outro VirtualHost:

<Directory /var/www/html/privado>
    AuthType Basic
    AuthName "Área Restrita"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
</Directory>

⸻

🔒 Resultado

Acessando http://seudominio.com/privado, o navegador vai pedir usuário e senha antes de mostrar qualquer conteúdo — controle feito 100% pelo Apache, sem depender da aplicação.
