#!/bin/bash

set -e

# VARIÁVEIS
CHROOT_DIR="/var/named/chroot"
BIND_DIR="$CHROOT_DIR/etc/bind"
BIND_DEV="$CHROOT_DIR/dev"
BIND_CACHE="$CHROOT_DIR/var/cache/bind"
BIND_USER="bind"

echo "[+] Instalando pacotes..."
apt update
apt install -y bind9 bind9utils bind9-doc apparmor

echo "[+] Criando estrutura do chroot..."
mkdir -p $BIND_DIR
mkdir -p $BIND_DEV
mkdir -p $BIND_CACHE

echo "[+] Criando dispositivos..."
mknod $BIND_DEV/null c 1 3
mknod $BIND_DEV/random c 1 8
chmod 666 $BIND_DEV/{null,random}

echo "[+] Movendo /etc/bind para $BIND_DIR..."
mv /etc/bind $BIND_DIR

echo "[+] Criando link simbólico de /etc/bind para chroot..."
ln -s $BIND_DIR /etc/bind

echo "[+] Corrigindo permissões..."
chown -R $BIND_USER:$BIND_USER $CHROOT_DIR
chown bind:bind $BIND_DIR/rndc.key
chown bind:bind $BIND_CACHE -R
chmod 775 $BIND_CACHE -R

echo "[+] Configurando AppArmor para permitir os novos dispositivos e chroot..."

# Adicionando permissões no perfil do AppArmor a partir da linha 25
echo "[+] Adicionando permissões no AppArmor..."

# Inserindo permissões específicas no /etc/apparmor.d/usr.sbin.named a partir da linha 25
awk 'NR==25 {print "# Permissões para o chroot do BIND9\n/var/named/chroot/** r,\n/var/named/chroot/var/cache/bind/** rw,\n/var/named/chroot/etc/bind/** r,\n/var/named/chroot/dev/null rw,\n/var/named/chroot/dev/random rw,"}1' /etc/apparmor.d/usr.sbin.named > /tmp/named.apparmor && mv /tmp/named.apparmor /etc/apparmor.d/usr.sbin.named

# Recarregando o perfil do AppArmor para aplicar as novas permissões
echo "[+] Recarregando AppArmor..."
apparmor_parser -r /etc/apparmor.d/usr.sbin.named

echo "[+] Copiando /etc/localtime para o chroot..."
cp /etc/localtime $CHROOT_DIR/etc/

# Alterando o PIDFILE no arquivo de init do named
echo "[+] Alterando PIDFILE no script de init..."
sed -i 's|PIDFILE=/var/run/named/named.pid|PIDFILE=/var/bind9/chroot/var/run/named/named.pid|' /etc/init.d/bind9

echo "[+] Configuração concluída. Reinicie o serviço com:"
echo "    systemctl restart bind9"
echo "[+] Depois, confira os logs com:"
echo "    tail -f /var/log/syslog"