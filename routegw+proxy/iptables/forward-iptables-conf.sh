🔧 1. Definir interfaces de rede

#Defina qual será a interface conectada à internet (ex: enp0s1) e qual será a interface interna/LAN (ex: enp0s2). Você pode verificar com:
ip a

🔁 2. Ativar o IP Forwarding (temporário e permanente)

#Ative com:
echo 1 > /proc/sys/net/ipv4/ip_forward

#Torne permanente com (validar necessidade):
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p

🔄 3. Limpar regras de firewall existentes (Opcional)

#Para evitar conflitos, limpe as regras antigas:
iptables -F
iptables -t nat -F
iptables -X

🌐 4. Configurar NAT (compartilhamento de internet)

#Aplique a regra de NAT para que os pacotes da rede interna tenham o IP de origem mascarado ao sair:
iptables -t nat -A POSTROUTING -o enp0s1 -j MASQUERADE

🔒 5. Configurar regras de encaminhamento (FORWARD)

#Permita que os pacotes da LAN acessem a internet e aceitem conexões de resposta:
iptables -A FORWARD -i enp0s1 -o enp0s2 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i enp0s2 -o enp0s1 -j ACCEPT

📄 6. (Opcional) Adicionar log de pacotes

#Para registrar pacotes encaminhados no syslog (útil para testes ou segurança):
iptables -A FORWARD -i enp0s2 -o enp0s1 -j LOG --log-prefix "GATEWAY: " --log-level 4

✅ 7. Verificar interfaces

Confirme os nomes das interfaces de rede configuradas com:
ip a | grep "enp0s1\|enp0s2"

💾 8. Salvar regras do iptables (para persistência após reboot)

#Para manter as regras mesmo após reinicializar o sistema, instale o pacote:
apt install iptables-persistent

Durante a instalação, ele perguntará se deseja salvar as regras atuais — confirme com “yes”.