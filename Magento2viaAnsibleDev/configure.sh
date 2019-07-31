#!/bin/bash
green=`tput setaf 2`
red=`tput setaf 1`
white=`tput setaf 7`

# Change the following Variable's Values below
host_to_install=AnsibleTest
host_to_install_with_user=admin
magento_dir=/var/www/magento21
host_ipaddress=192.168.1.2361
#mysql_db_dump_archive=int_magento2_2017_02_27_truncated.sql.gz1
mysql_db_dump_sql=magentodb.sql
mysql_dbname=magento
mysql_root_pwd=Password
mysql_db_user=magento
mysql_db_pwd=Password

# Don't change below this line
sed -i "s|hosts: AnsibleTest|hosts: $host_to_install|" install.yml
sed -i "s|user: admin|user: $host_to_install_with_user|" install.yml
sed -i "s|/var/www/magento2/bin/magento|$magento_dir/bin/magento|" install.yml
sed -i "s|dest=/var/www/magento2/app/etc/config.php|dest=$magento_dir/app/etc/config.php|" install.yml

sed -i "s|magentodb.sql|$mysql_db_dump_sql|" roles/addrepo/tasks/main.yml

sed -i "s|magento_dir: /var/www/magento2|magento_dir: $magento_dir|" roles/algolia/vars/main.yml

sed -i "s|git_home: /home/administrator/magento/|git_home: /home/$host_to_install_with_user/magento/|" roles/importmagento/vars/main.yml
sed -i "s|magento_dir: /var/www/magento2|magento_dir: $magento_dir|" roles/importmagento/vars/main.yml
sed -i "s|host_ipaddress: 192.168.1.236|host_ipaddress: $host_ipaddress|" roles/importmagento/vars/main.yml
sed -i "s|user: admin|user: $host_to_install_with_user|" roles/importmagento/vars/main.yml
sed -i "s|group: admin|group: $host_to_install_with_user|" roles/importmagento/vars/main.yml

sed -i "s|magento_dir: /var/www/magento2|magento_dir: $magento_dir|" roles/magento/vars/main.yml
sed -i "s|owner: admin|owner: $host_to_install_with_user|" roles/magento/vars/main.yml
sed -i "s|group: admin|group: $host_to_install_with_user|" roles/magento/vars/main.yml
sed -i "s|sql_src_file: /tmp/int_magento2_2017_02_27_truncated.sql.gz|sql_src_file: /tmp/$mysql_db_dump_archive|" roles/magento/vars/main.yml
sed -i "s|sql_target_file: /tmp/magentodb.sql|sql_target_file: /tmp/$mysql_db_dump_sql|" roles/magento/vars/main.yml
sed -i "s|db_name: magento|db_name: $mysql_dbname|" roles/magento/vars/main.yml
sed -i "s|login_password: 'Password'|login_password: '$mysql_root_pwd'|" roles/magento/vars/main.yml

sed -i "s|magento_dir: /var/www/magento2|magento_dir: $magento_dir|" roles/mongodb/vars/main.yml

sed -i "s|login_password: 'Password'|login_password: '$mysql_root_pwd'|" roles/mysql/vars/main.yml
sed -i "s|db_name: magento|db_name: $mysql_dbname|" roles/mysql/vars/main.yml
sed -i "s|db_user: magento|db_user: $mysql_db_user|" roles/mysql/vars/main.yml
sed -i "s|db_password: Password|db_password: $mysql_db_pwd|" roles/mysql/vars/main.yml

sed -i "s|magento_dir: /var/www/magento2|magento_dir: $magento_dir|" roles/nginx/vars/main.yml

# Print Changed Values
echo "Ansible Host is now set to: ${green}$host_to_install${white}"
echo "Ansible Client User is now set to: ${green}$host_to_install_with_user${white}"
echo "Magento Installation Directory is now set to: ${green}$magento_dir${red} Please verfiy the same in tmp/installmagento.sh${white}"
echo "Server IP Address is now set to: ${green}$host_ipaddress${white}"
echo "MySQL Database Dump Archive is now set to: ${green}$mysql_db_dump_archive${red} Please verify the same in tmp/${white}"
echo "MySQL Database SQL File is now set to: ${green}$mysql_db_dump_sql${red} Please verify the same in tmp/${white}"
echo "MySQL Database Name for Magento is now set to: ${green}$mysql_dbname${red} Please verify the same in tmp/installmagento.sh${white}"
echo "MySQL root Password is now changed to: ${green}$mysql_root_pwd${red} Please verify the same in tmp/mysqlscript.sh${white}"
echo "MySQL Magento Database User is now changed to: ${green}$mysql_db_user${red} Please verify the same in tmp/installmagento.sh${white}"
echo "MySQL Magento Database User's Password is now changed to: ${green}$mysql_db_pwd${white}"