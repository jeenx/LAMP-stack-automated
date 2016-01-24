#!/bin/bash

#Automation - By Jim Tario
#Install LAMP stack on Ubuntu Machines
#
#Instruction: 
#	      give permission bit
#             -chmod +x ubuntuStack.sh
#             -chmod 755 ubuntuStack.sh
#	      run script as sudo
#	      -sudo ./ubuntuStack.sh
#

echo -e "\n"
echo "  ==================================================== "
echo "  ==================================================== "
echo -e "    Welcome and lets all thank laziness for scripts!\n\n
    Beginning Script...
    ~Average script time: 3 minutes"
echo "  ==================================================== "
echo "  ==================================================== "
echo -e "\n"
read -p "Press [Enter] key to start!..." 

#update repos and packages
apt-get -y update  && apt-get -y upgrade 

#install apache2
apt-get -y install apache2

#set password for root in mysql: L@mp
echo mysql-server mysql-server/root_password password L@mp | sudo debconf-set-selections
echo mysql-server mysql-server/root_password_again password L@mp | sudo debconf-set-selections
#install mysql
sudo apt-get -y install mysql-server

#MySQL secure installation automated - 
#Forked from: https://gist.github.com/Mins/4602864
apt-get -y install expect
MYSQL="L@mp"

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

apt-get -y purge expect
#end of automating mysql_secure installation
#source: https://gist.github.com/Mins/4602864

#install PHP
apt-get -y install php5 php-pear

#install MySQL support 
apt-get -y install php5-mysql

#Installation complete
#Let's restart the services 
service apache2 restart > /dev/null
/etc/init.d/mysql restart > /dev/null

echo -e "\n"

if [ $? -ne 0 ]; then
   echo "-----------------------------------------------------"
   echo "Please Check the services, There is a problem"
else
   echo "-----------------------------------------------------"
   echo "Installed Services run successfully, script worked perfectly :D"
fi

echo -e "\n"

echo "End of Script! Have fun with your new stack"

echo -e "\n"
