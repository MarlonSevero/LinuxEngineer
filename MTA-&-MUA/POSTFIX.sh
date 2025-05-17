apt install postfix procmail bsd-mailx -y 
    -site internet
    -nome email 'dominio.com'
/etc/postfix/main.cf //arquivo onde manipulamos os parametros (princiapal arquivo de configuracao)
postconf --> usado para passar novos parametros e para configurar
port. 25 smtp
port. 465 /587 smtps
/etc/alias realizamos a config de alias de email
postalias /etc/eliases
ls -l /etc/aliases*
    -vai gerar um arquivo.db dos aliases

    