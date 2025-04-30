# Instalar pacotes do Bind9
apt install bind9 bind9utils bind9-doc dnsutils -y

# Criacao do diretorios 
mkdir -pv /var/bind9/chroot/{etc,dev,var/cache/bind,var/run/named}

# Editar o arquivo de configuração do named
vim /etc/default/named

# Ajustar permissões e links simbólicos
ln -s /var/bind9/chroot/etc/bind/ /etc/bind

# Criar diretórios necessários no chroot
mknod /var/bind9/chroot/dev/null c 1 3
mknod /var/bind9/chroot/dev/random c 1 8
chmod 660 /var/bind9/chroot/dev/*

# Atualizar permissões
chown bind:bind /var/bind9/chroot/etc/bind/rndc.key
chown bind:bind /var/bind9/chroot/var/ -R
chmod 775 /var/bind9/chroot/var/ -R


# Atualizar o arquivo de configuração com root hints e TSIG keys
cp /root/linuxforce/intranet/bind_chroot/etc/bind/named.conf* /etc/bind/
cp /root/linuxforce/intranet/bind_chroot/bind/* /var/bind9/chroot/var/cache/bind/
tsig-keygen TRANSFER > tsig.key

#Copiando root.hits para chroot directory
cp -a /usr/share/dns/root.hints /var/bind9/chroot/var/cache/bind/


# Recarregar a configuração após ajustes
systemctl restart named