# 🛠️ Infraestrutura Linux — Serviços de Rede e Segurança

> Repositório dedicado à configuração e administração de serviços essenciais em servidores Linux, com foco em DNS, Web, Compartilhamento de Arquivos, LDAP, Segurança.

![Linux](https://img.shields.io/badge/Linux-Admin-informational?style=flat&logo=linux)
![Status](https://img.shields.io/badge/status-Em%20Desenvolvimento-yellow)
![License](https://img.shields.io/badge/license-MIT-blue)

## 🔧 Servidores DNS

O DNS é responsável por traduzir nomes de domínio em endereços IP, sendo um componente essencial em redes.

### Funcionalidades:
- **Chroot DNS**: Executa o serviço DNS em ambiente isolado para segurança adicional.
- **Estrutura Master/Slave**: Alta disponibilidade e replicação automática de zonas DNS.
- **DNS View**: Retorno de diferentes respostas DNS com base no IP do solicitante.
- **Delegação de IP Reverso**: Associa IPs a nomes (ex.: log de e-mails).
- **DNSSEC**: Assinatura digital de zonas DNS para evitar spoofing.
- **SPF (Sender Policy Framework)**: Proteção contra falsificação de remetentes em e-mails.

---

## 🌐 Serviços Web em DMZ

A DMZ isola serviços públicos da rede interna, melhorando a segurança.

### Implementações:
- **Apache HTTP Server**: Configuração robusta para servir aplicações web.
- **HTTPS (TLS/SSL)**: Certificados digitais para tráfego seguro.
- **SFTP (Secure FTP)**: Upload/download seguro via SSH.
- **Nginx (Reverse Proxy)**: Balanceamento de carga, cache e SSL offloading.
---

## 📁 Compartilhamento de Arquivos

Permite que múltiplos usuários e sistemas acessem dados de maneira segura e organizada.

### Serviços:
- **OpenLDAP**: Diretório centralizado de usuários e grupos.
- **Clientes LDAP**: Sistemas integrados ao LDAP para login remoto.
- **Samba 4**: Compartilhamento de arquivos entre Linux e Windows com suporte a AD.
- **NFS (Network File System)**: Compartilhamento de diretórios entre sistemas Unix/Linux via rede.
---

## 🔐 Segurança e Hardening

Segurança não é opcional — ela deve estar no centro de qualquer infraestrutura.

### Abordagens:
- **Rotinas de Segurança**: Auditorias, backups, atualizações e gerenciamento de permissões.
- **Hardening de Apache**: Minimização de superfícies de ataque.
- **OpenVPN**: Criação de redes privadas e seguras com criptografia.
- **Squid Proxy**: Cache web e filtros de conteúdo.
- **Iptables**: Firewall avançado para controle total de tráfego.

---