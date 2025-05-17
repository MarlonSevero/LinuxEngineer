>>Subindo aplicacao PHP

apt install php8.2 php8.2-curl php8.2-gd php8.2-intl php8.2-xmlrpc php8.2-mysql -y 

# 🌐 Apache2 - VirtualHost Overview

# VirtualHosts allow you to host multiple websites or applications
# on the same server, using different domains or ports.

# 📁 Config path:
# /etc/apache2/sites-available/

# ✅ Enable the site:
sudo a2ensite yoursite.conf
sudo systemctl reload apache2

# 🧱 Basic VirtualHost Example:

<VirtualHost *:80>
    ServerName example.com
    ServerAlias www.example.com
    DocumentRoot /var/www/example

    ErrorLog ${APACHE_LOG_DIR}/example_error.log
    CustomLog ${APACHE_LOG_DIR}/example_access.log combined
</VirtualHost>

# ⚙️ Key fields:
# - *:80 → Listen on all interfaces on port 80 (HTTP)
# - ServerName → Main domain
# - ServerAlias → Alternative domains (e.g., www)
# - DocumentRoot → Folder with your website files
# - ErrorLog / CustomLog → Optional log files

# ✅ Step-by-step:

# 1. Create website directory:
sudo mkdir -p /var/www/example

# 2. Add a test file:
echo "<h1>It works!</h1>" | sudo tee /var/www/example/index.html

# 3. Create VirtualHost config:
sudo nano /etc/apache2/sites-available/example.conf

# 4. Paste the VirtualHost example above

# 5. Enable and reload Apache:
sudo a2ensite example.conf
sudo systemctl reload apache2

# 6. (Optional) Add to /etc/hosts for local testing:
echo "127.0.0.1 example.com" | sudo tee -a /etc/hosts

# 7. Access in the browser:
http://example.com
