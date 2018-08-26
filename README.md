# raspberry_LibreNMS

Update packages and install git:
```
apt-get upgrade
apt-get install git
```

Clone this repository:
```
git clone https://github.com/sunsetmountain/raspberry_LibreNMS
```

Change into the directory and run the first script:
```
cd raspberry_LibreNMS
chmod +x step1.sh step2.sh
./step1.sh
```

Configure a basic SNMP config file – we will move the template and create a new file:
```
sudo nano /etc/snmp/snmpd.conf
```
Add your new SNMP parameters to the config file (replace with the appropriate info):
```
rocommunity infosoda
syslocation My Laboratory
syscontact Call the HelpDesk
```

Run the second script:
```
./step2.sh
```

Edit the SNMP configuration:
```
sudo nano config.php
```
Change the values to the right of the equal sign for lines beginning with $config[db_] to match your database information as setup above.

Change the value of $config['snmp']['community'][] from public to whatever your read-only SNMP community is. Also add detection for your network IP range. (NOTE: Make sure that SNMP v1 or v2 is enabled for any systems you want to monitor and that the community string matches whatever you set here)
```
$config['snmp']['community'][] = "myhome";
$config['discovery_by_ip'] = true;
$config['nets'][] = "192.1698.0.0/24";
```
Note that the format in the original file could be $config['snmp']['community'] = array["public"] and should be changed

Initialize the database:
```
cd /opt/librenms/
sudo php build-base.php
```
Add user in the following format:
```
sudo php adduser.php <name> <pass> 10 <email>
```
(e.g. sudo php adduser.php admin LibreNMS!123 10 admin@myhome.net)

Validate the install, and correct any errors:
```
sudo php validate.php 
```

Add the localhost:
```
sudo php addhost.php localhost public v2c
```

Discover the newly added localhost:
```
php discovery.php -h all
```
If all of the systems aren't detected, looking into using the snmp-scan.py script.

Create a cronjob:
```
cp librenms.nonroot.cron /etc/cron.d/librenms
```

At this point, your setup is complete and you should be able to log into the web interface utilizing the credentials created with the adduser.php command. Open your browser and browse to http://yourip
