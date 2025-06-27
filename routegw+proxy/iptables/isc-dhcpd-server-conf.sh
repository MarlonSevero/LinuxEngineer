📡 Configuração de Servidor DHCP com isc-dhcp-server no Linux

🔧 1. Definir as variáveis de rede

#Antes de tudo, defina as informações da sua rede local:
	•	Sub-rede: 192.168.10.0
	•	Máscara de rede: 255.255.255.0
	•	Gateway padrão: 192.168.10.1
	•	Faixa de IPs DHCP: 192.168.10.100 a 192.168.10.200
	•	Servidores DNS: 8.8.8.8, 1.1.1.1
	•	Interface de rede: enp0s3 (verifique com ip a)

⸻

📦 2. Instalar o servidor DHCP

#Atualize os pacotes e instale:

sudo apt update
sudo apt install isc-dhcp-server -y

⸻

⚙️ 4. Definir a interface padrão do DHCP

#Configure a interface de rede que o serviço irá utilizar:

echo 'INTERFACESv4="enp0s3"' | sudo tee /etc/default/isc-dhcp-server

#Substitua enp0s3 se necessário.

⸻

📁 5. Criar o arquivo de configuração /etc/dhcp/dhcpd.conf

#Crie o diretório (caso não exista) e defina o escopo DHCP conforme sua rede:

sudo mkdir -p /etc/dhcp
sudo nano /etc/dhcp/dhcpd.conf

#Conteúdo sugerido:

# default-lease-time 600;
# max-lease-time 7200;
# authoritative;
# option domain-name "local.lan";
# option domain-name-servers 8.8.8.8, 1.1.1.1;

# subnet 192.168.10.0 netmask 255.255.255.0 {
#   range 192.168.10.100 192.168.10.200;
#   option routers 192.168.10.1;
#   option broadcast-address 192.168.10.255;
# }


⸻

🔍 6. Validar o arquivo de configuração

#Teste a configuração do servidor DHCP:

sudo dhcpd -t

#Se não houver erros, a configuração está correta.

⸻

🚀 7. Iniciar e habilitar o serviço DHCP

Se o teste passou, inicie e ative o serviço:

sudo systemctl restart isc-dhcp-server
sudo systemctl enable isc-dhcp-server
sudo systemctl status isc-dhcp-server