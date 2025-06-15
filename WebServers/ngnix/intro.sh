📦 O que é o Nginx?

O Nginx (Engine-X) é um servidor web leve, de alto desempenho, usado como:
	•	Servidor HTTP estático/dinâmico
	•	Proxy reverso
	•	Balanceador de carga (load balancer)
	•	Gateway para aplicações com FastCGI, uwsgi, SCGI, etc.

⸻

📁 Principais diretórios e arquivos criados:

/etc/nginx/

Diretório principal de configuração do Nginx.

Caminho	Função
/etc/nginx/nginx.conf	Arquivo principal de configuração. Controla o comportamento global do servidor.
/etc/nginx/sites-available/	Onde ficam as configurações de sites virtuais (vhosts).
/etc/nginx/sites-enabled/	Contém links simbólicos para os sites ativos configurados em sites-available.
/etc/nginx/snippets/	Arquivos de trechos reutilizáveis de configuração.
/etc/nginx/conf.d/	Arquivos .conf adicionais incluídos automaticamente no nginx.conf.


⸻

📁 Outros diretórios e arquivos importantes:

/var/www/

Diretório padrão dos arquivos HTML dos sites.

Caminho	Função
/var/www/html/	Diretório padrão para servir conteúdo web.


⸻

/var/log/nginx/

Logs de atividade do Nginx.

Caminho	Função
/var/log/nginx/access.log	Registra os acessos (requests)
/var/log/nginx/error.log	Registra os erros do servidor Nginx


⸻

/lib/systemd/system/nginx.service

Arquivo de unidade do systemd para gerenciar o serviço Nginx.

⸻

Arquivo /etc/nginx/sites-available/default:

Exemplo de Conteudo:

server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }
}