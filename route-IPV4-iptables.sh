#!/bin/bash

# CONFIGURÁVEL
INTERNET_IFACE="enp0s1"
LAN_IFACE="enp0s2"

echo "[+] Ativando IP Forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

# Ou permanente no /etc/sysctl.conf
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p

echo "[+] Limpando regras antigas..."
iptables -F
iptables -t nat -F
iptables -X

echo "[+] Aplicando regras de NAT e FORWARD..."
iptables -t nat -A POSTROUTING -o $INTERNET_IFACE -j MASQUERADE
iptables -A FORWARD -i $INTERNET_IFACE -o $LAN_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $LAN_IFACE -o $INTERNET_IFACE -j ACCEPT

# OPCIONAL: log de pacotes
echo "[+] Adicionando regra de log (opcional)..."
iptables -A FORWARD -i $LAN_IFACE -o $INTERNET_IFACE -j LOG --log-prefix "GATEWAY: " --log-level 4

echo "[+] Regras aplicadas com sucesso!"
echo "[+] Suas interfaces:"
ip a | grep "$INTERNET_IFACE\|$LAN_IFACE"

echo "[!] Lembre-se de salvar as regras se quiser que persistam após reboot!"