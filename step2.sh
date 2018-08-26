# Restart the SNMP service
sudo service snmpd restart

# Create the librenms user
sudo useradd librenms -d /opt/librenms -M -r
sudo usermod -a -G librenms www-data

# Change directories and download LibreNMS
cd /opt
sudo git clone https://github.com/librenms/librenms.git librenms
cd /opt/librenms

# Prepare the web interface
sudo mkdir rrd logs
sudo chown -R librenms:librenms /opt/librenms
sudo chmod 775 rrd

# Create the conf file for Apache
sudo touch /etc/apache2/sites-available/librenms.conf

# Add to the librenms.conf file
sudo echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/librenms.conf
sudo echo " DocumentRoot /opt/librenms/html/" >> /etc/apache2/sites-available/librenms.conf
sudo echo " ServerName librenms.myhome.com" >> /etc/apache2/sites-available/librenms.conf
sudo echo " CustomLog /opt/librenms/logs/access_log combined" >> /etc/apache2/sites-available/librenms.conf
sudo echo " ErrorLog /opt/librenms/logs/error_log" >> /etc/apache2/sites-available/librenms.conf
sudo echo " AllowEncodedSlashes NoDecode" >> /etc/apache2/sites-available/librenms.conf
sudo echo " <Directory '/opt/librenms/html/'>" >> /etc/apache2/sites-available/librenms.conf
sudo echo " Require all granted" >> /etc/apache2/sites-available/librenms.conf
sudo echo " AllowOverride All" >> /etc/apache2/sites-available/librenms.conf
sudo echo " Options FollowSymLinks MultiViews" >> /etc/apache2/sites-available/librenms.conf
sudo echo " </Directory>" >> /etc/apache2/sites-available/librenms.conf
sudo echo "</VirtualHost>" >> /etc/apache2/sites-available/librenms.conf

# Enable mcrypt
sudo phpenmod mcrypt

# Load the website
sudo a2ensite librenms.conf
sudo a2enmod rewrite
sudo service apache2 restart

# Disable the default site setup
sudo a2dissite 000-default
sudo service apache2 reload

# Configure the polling defaults
sudo cp config.php.default config.php

# Add to the config.php file to allow for Nagios plugin usage
sudo echo "$config['nagios_plugins'] = '/usr/lib/nagios/plugins';" >> /opt/librenms/config.php

# Download files for speedtest use
cd ~
git clone https://github.com/tleadley/speedtst
cd speedtst
sudo mv Scripts/speedtest/ /opt/speedtest
sudo mv plugin/Speedtest/ /opt/librenms/html/plugins/Speedtest
sudo chmod +x /opt/speedtest/speedtest.sh /opt/speedtest/update_graph.sh /opt/speedtest/update_week.sh

# Update cron job (commented out for now due to inconsistencies in retrieving results)
#sudo echo "*/30 * * * * librenms /opt/speedtest/speedtest.sh && /opt/speedtest/update-graph.sh" >> /etc/cron.d/librenms

# Move back to the LibreNMS directory
cd /opt/librenms
