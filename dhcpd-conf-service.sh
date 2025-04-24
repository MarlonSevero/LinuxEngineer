#!/bin/bash

# === VARIÁVEIS PERSONALIZÁVEIS ===
REDE="192.168.10.0"
MASCARA="255.255.255.0"
GATEWAY="192.168.10.1"
RANGE_INICIO="192.168.10.100"
RANGE_FIM="192.168.10.200"
DNS1="8.8.8.8"
DNS2="1.1.1.1"
INTERFACE="enp0s3"  # Use "ip a" para confirmar o nome correto

echo "Limpando instalações anteriores..."
sudo systemctl stop isc-dhcp-server
sudo apt purge isc-dhcp-server -y
sudo apt autoremove -y
sudo rm -rf /etc/dhcp /var/lib/dhcp

echo "📦 Instalando isc-dhcp-server..."
sudo apt update
sudo apt install isc-dhcp-server -y

echo "⚙️ Configurando interface padrão..."
echo "INTERFACESv4=\"$INTERFACE\"" | sudo tee /etc/default/isc-dhcp-server

echo "Criando dhcpd.conf com base nas variáveis..."
sudo mkdir -p /etc/dhcp
sudo tee /etc/dhcp/dhcpd.conf > /dev/null <<EOF
default-lease-time 600;
max-lease-time 7200;
authoritative;
option domain-name "local.lan";
option domain-name-servers $DNS1, $DNS2;

subnet $REDE netmask $MASCARA {
  range $RANGE_INICIO $RANGE_FIM;
  option routers $GATEWAY;
  option broadcast-address ${REDE%.*}.255;
}
EOF

echo "Testando configuração do DHCP..."
sudo dhcpd -t

if [ $? -eq 0 ]; then
  echo "✅ Configuração OK. Iniciando o serviço..."
  sudo systemctl restart isc-dhcp-server
  sudo systemctl enable isc-dhcp-server
  sudo systemctl status isc-dhcp-server
else
  echo "Erro na configuração. Corrija antes de iniciar o serviço."
fi