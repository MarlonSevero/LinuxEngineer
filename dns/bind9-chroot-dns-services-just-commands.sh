apt install bind9 bind9utils bind9-doc dnsutils -y #instala os pacotes 
mkdir -pv /var/bind9/chroot/{etc,dev,var/cache/bind,var/run/named} #cria os diretorios seguindo padrao do chroot
systemctl stop bind9    #para o servico por seguranca
mv /etc/bind /var/bind9/chroot/etc/bind/    #move os arquivos de configuracao para o diretorio do chroot
ln -s /var/bind9/chroot/etc/bind/ /etc/bind #cria um link simbolico para facilitar acesso
cp /etc/localtime /var/bind9/chroot/etc/    #copia o localtime para o chroot/etc/
mknod /var/bind9/chroot/dev/null c 1 3      #cria dev 
mknod /var/bind9/chroot/dev/random c 1 8    #cria dev
chmod 660 /var/bind9/chroot/dev/*           #permissionamento dos dispositivos
chown bind:bind /var/bind9/chroot/etc/bind/rndc.key #permissionamento dos rndc.key
chown bind:bind /var/bind9/chroot/var/ -R           #permissionamento do /var/*
chmod 775 /var/bind9/chroot/var/ -R                 
vim /etc/default/named                               #add target "-t /var/bind9/chroot"
vim /etc/apparmor.d/usr.sbin.named                   #{add os diretorios etc r,  dev rw, var rw}
vim /etc/init.d/named                                #muda o PID para o /var/bind9/chroot/var/{DEFAULT}
cp /ARQUIVOS DE CONFIG/bind/named.conf* /etc/bind/   #COPIA OU CONFIGURA DO ZERO os arquivos de configuracao
cp /root/linuxforce/intranet/bind_chroot/bind/* /var/bind9/chroot/var/cache/bind/   #COPIA OU CONFIGURA DO ZERO os arquivos de ZONA 
cp -a /usr/share/dns/root.hints /var/bind9/chroot/var/cache/bind/                   #COPIA os arquivo de zonas "." para o chroot
tsig-keygen TRANSFER > tsig.key                     #Cria a chave para servidores Slave
scp tsig.key analista@192.168.1.20:/tmp/            #Envia a chave para o servidor
systemctl restart named                             #reinicia o servico