# Referenced https://infosoda.com/librenms-raspberry-pi-2-3/ and https://docs.librenms.org/#Installation/Installation-Ubuntu-1604-Apache/

# Install all of the core software needed for LibreNMS

# Start at the beginning by going home.
cd ~

# Make sure everything is up-to-date and then install core packages
sudo apt-get update
sudo apt-get -y install mariadb-server mariadb-client
sudo service mysql restart #restart mysql
sudo apt-get -y install git python-pip python-dev python-memcache python-mysqldb
sudo apt-get -y install acl libapache2-mod-php7.0 apache2 php-pear
sudo apt-get -y install php7.0-cli php7.0-curl php7.0-gd php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql
sudo apt-get -y install php7.0-zip php-net-ipv4 php-net-ipv6 php7.0-mcrypt php7.0-snmp php7.0-xml
sudo apt-get -y install snmp snmpd graphviz fping imagemagick whois mtr-tiny 
sudo apt-get -y install nmap rrdtool composer

# Create the database
sudo mysql -u root -e "source dbscript.sql"

# Create a SNMP config file
sudo mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.old
sudo touch /etc/snmp/snmpd.conf
sudo echo "rocommunity ourhome" >> /etc/snmp/snmpd.conf
sudo echo "syslocation My Home" >> /etc/snmp/snmpd.conf
sudo echo "syscontact Call the HelpDesk" >> /etc/snmp/snmpd.conf

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
# sudo touch /etc/apache2/sites-available/librenms.conf

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
sudo php5enmod mcrypt

# Load the website
sudo a2ensite librenms.conf
sudo a2enmod rewrite
sudo service apache2 restart

# Disable the default site setup
sudo a2dissite 000-default
sudo service apache2 reload

# Configure the polling defaults
sudo cp config.php.default config.php

# Initialize the database
sudo php build-base.php