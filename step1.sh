# Referenced https://infosoda.com/librenms-raspberry-pi-2-3/ and https://docs.librenms.org/#Installation/Installation-Ubuntu-1604-Apache/

# Install all of the core software needed for LibreNMS

# Start at the beginning by going home.
cd ~

# Make sure everything is up-to-date and then install core packages
sudo apt-get update
sudo apt-get -y install mariadb-server mariadb-client
sudo service mysql restart #restart MySQL
sudo apt-get -y install git python-pip python-dev python-memcache python-mysqldb
sudo apt-get -y install acl libapache2-mod-php7.0 apache2 php-pear
sudo apt-get -y install php7.0-cli php7.0-curl php7.0-gd php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql
sudo apt-get -y install php7.0-zip php-net-ipv4 php-net-ipv6 php7.0-mcrypt php7.0-snmp php7.0-xml
sudo apt-get -y install snmp snmpd graphviz fping imagemagick whois mtr-tiny 
sudo apt-get -y install nmap rrdtool composer nagios-plugins
sudo pip install speedtest-cli

# Create the database
sudo mysql -u root -e "source dbscript.sql"

# Add to the MySQL configuration file and restart MySQL
sudo echo "[mysqld]" >> /etc/mysql/my.cnf
sudo echo "innodb_file_per_table=1" >> /etc/mysql/my.cnf
sudo service mysql restart #restart MySQL
