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

echo "[+] Copiando localtime para o chroot..."
cp /etc/localtime $CHROOT_DIR/etc/

echo "[+] Corrigindo permissões..."
chown -R $BIND_USER:$BIND_USER $CHROOT_DIR

echo "[+] Liberando AppArmor para o BIND..."
aa-complain /etc/apparmor.d/usr.sbin.named

echo "[+] Configuração concluída. Reinicie o serviço com:"
echo "    systemctl restart bind9"
echo "[+] Depois, confira os logs com:"
echo "    tail -f /var/log/syslog"