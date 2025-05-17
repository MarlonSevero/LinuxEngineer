# 🔥 Apache2 - Essentials Guide

# 📚 Official website:
https://httpd.apache.org/

# 📦 Install Apache2
sudo apt update
sudo apt install apache2 -y

# Apache is one of the most widely used web servers in the world.
# It handles HTTP/HTTPS requests and serves content like websites
# written in HTML, PHP, etc.

# 📁 Key Files and Folders:

# /etc/apache2/apache2.conf       → Main Apache configuration
# /etc/apache2/ports.conf         → Defines ports (e.g. 80, 443)
# /etc/apache2/envvars            → Apache environment variables
# /etc/apache2/sites-available/   → Available Virtual Host configs
# /etc/apache2/sites-enabled/     → Enabled Virtual Hosts (symlinks)
# /etc/apache2/mods-available/    → All available Apache modules
# /etc/apache2/mods-enabled/      → Enabled modules (symlinks)
# /etc/apache2/conf-available/    → Extra config snippets (e.g., charset)
# /etc/apache2/conf-enabled/      → Enabled config snippets

# ⚙️ Enable / Disable Items

# Enable/Disable a site:
sudo a2ensite yoursite.conf
sudo a2dissite yoursite.conf

# Enable/Disable a module:
sudo a2enmod rewrite
sudo a2dismod rewrite

# Enable/Disable a config snippet:
sudo a2enconf charset
sudo a2disconf charset

# Test and reload Apache:
sudo apache2ctl configtest
sudo systemctl reload apache2

# 📂 Log Files
ls -l /var/log/apache2/

# Tail logs in real-time:
tail -f /var/log/apache2/access.log
tail -f /var/log/apache2/error.log

# 🌐 Document Root
# Default directory to deploy your website:
# /var/www/html

# 📌 Key Concepts

# Server Root:      /etc/apache2/
# Document Root:    /var/www/html/
# Directory Index:  index.html, index.php

# 🔧 Apache2 – <Directory> ... </Directory> use for new directory

# 📂 Where is used?
# Dentro de: /etc/apache2/apache2.conf

# 📌 Default example no apache2.conf:
<Directory /srv/NewDirectory/>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

- we can check conf with the command : apachectl -t




