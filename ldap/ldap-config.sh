### 📦 1. Instalar pacotes necessários
    sudo apt install slapd ldap-utils -y

### 📁 2. Preparar e editar o slapd.conf
sudo cp -a /usr/share/doc/slapd/examples/slapd.conf /etc/ldap/
sudo vim /etc/ldap/slapd.conf

    # Carregamento do módulo MDB
    moduleload back_mdb

    # Nível de log (256 = operações de conexão)
    loglevel 256

    # Configuração do banco de dados
    database        mdb
    suffix          "dc=seudominio,dc=com"
    rootdn          "cn=admin,dc=seudominio,dc=com"
    directory       "/var/lib/ldap"

    # Gerar hash da senha do admin com:
    # slappasswd
    rootpw          {SSHA}coloque_o_hash_aqui

### 🧹 3. Preparar estrutura de diretórios e permissões
sudo mv /etc/ldap/slapd.d /var/backups/            # backup (se existir)
sudo mkdir -pv /etc/ldap/slapd.d
sudo chown -R openldap:openldap /var/lib/ldap /etc/ldap/slapd.conf

### ⚙️ 4. Configurar o uso do slapd.conf
sudo vim /etc/default/slapd
    SLAPD_CONF="/etc/ldap/slapd.conf"
    SLAPD_ARGS=""

### 🔍 5. Validar e aplicar configuração
sudo slaptest -f /etc/ldap/slapd.conf -F /etc/ldap/slapd.d

### 🔁 6. Reiniciar e habilitar serviço
sudo systemctl restart slapd
sudo systemctl enable slapd