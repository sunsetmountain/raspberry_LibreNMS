# raspberry_LibreNMS

Update packages and install git:
apt-get upgrade
apt-get install git

Clone this repository:
git clone https://github.com/sunsetmountain/raspberry_LibreNMS

Change into the directory and run the installation script:
cd raspberry_LibreNMS
chmod +x initialsoftware.sh
./initialsoftware.sh

Configure a basic SNMP config file – we will move the template and create a new file:

sudo nano /etc/snmp/snmpd.conf
Add your new SNMP parameters to the config file (replace with the appropriate info):

rocommunity infosoda
syslocation My Laboratory
syscontact Call the HelpDesk

Restart SNMP:
sudo service snmpd restart

Initialize the database:

cd /opt/librenms/
sudo php build-base.php

Add user in the following format:

sudo php adduser.php <name> <pass> 10 <email>

Validate the install, and correct any errors:

sudo php validate.php 
Add the localhost:

sudo php addhost.php localhost public v2c
Discover the newly added localhost:

php discovery.php -h all

Create a cronjob:

cp librenms.nonroot.cron /etc/cron.d/librenms


At this point, your setup is complete and you should be able to log into the web interface utilizing the credentials created with the adduser.php command. Open your browser and browse to http://yourip
