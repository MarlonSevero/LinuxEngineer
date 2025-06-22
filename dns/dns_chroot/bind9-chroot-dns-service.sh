# Instalação dos pacotes necessários
apt install bind9 bind9utils bind9-doc dnsutils -y

# Criação da estrutura de diretórios do chroot
mkdir -pv /var/bind9/chroot/{etc,dev,var/cache/bind,var/run/named}

# Parada do serviço Bind9 por segurança
systemctl stop bind9

# Movimentação dos arquivos de configuração para o ambiente chroot
mv /etc/bind /var/bind9/chroot/etc/bind/
o que
# Criação de link simbólico para facilitar o acesso
ln -s /var/bind9/chroot/etc/bind/ /etc/bind

# Cópia do arquivo de timezone para o ambiente chroot
cp /etc/localtime /var/bind9/chroot/etc/

# Criação dos dispositivos especiais no chroot
mknod /var/bind9/chroot/dev/null c 1 3
mknod /var/bind9/chroot/dev/random c 1 8

# Ajuste de permissões dos dispositivos
chmod 660 /var/bind9/chroot/dev/*

# Ajuste de permissões dos arquivos do Bind
chown bind:bind /var/bind9/chroot/etc/bind/rndc.key
chown bind:bind /var/bind9/chroot/var/ -R
chmod 775 /var/bind9/chroot/var/ -R

# Ajuste de configurações do sistema
vim /etc/default/named
+ OPTIONS="-u bind -t /var/bind9/chroot"
# (Adicionar a opção: -t /var/bind9/chroot)

vim /etc/apparmor.d/usr.sbin.named
# (Ajustar: etc r, dev rw, var rw)
+ /var/bind9/chroot/etc/bind/** r,
+ /var/bind9/chroot/var/cache/bind/** rw,
+ /var/bind9/chroot/var/run/named/** rw,
+ /var/bind9/chroot/dev/null rw,
+ /var/bind9/chroot/dev/random rw,

vim /etc/init.d/named
# (Corrigir o caminho do PID para: /var/bind9/chroot/var/{DEFAULT})
+ PIDFILE="/var/bind9/chroot/var/run/named/named.pid"

# Cópia dos arquivos de configuração do Bind
cp /ARQUIVOS_DE_CONFIG/bind/named.conf* /etc/bind/

# Cópia dos arquivos de zona DNS
cp /root/linuxforce/intranet/bind_chroot/bind/* /var/bind9/chroot/var/cache/bind/

# Cópia do arquivo de root hints
cp -a /usr/share/dns/root.hints /var/bind9/chroot/var/cache/bind/

# Criação da chave TSIG para transferência entre servidores
tsig-keygen TRANSFER > tsig.key

# Envio da chave TSIG para o servidor slave
scp tsig.key analista@192.168.1.20:/tmp/

# Reinício do serviço Bind9
systemctl restart named