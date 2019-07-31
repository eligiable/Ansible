/var/www/magento2/bin/magento setup:install --backend-frontname="adminlogin" \
--db-host="localhost" \
--db-name="magento" \
--db-user="magento" \
--db-password="Password" \
--language="en_US" \
--currency="USD" \
--timezone="Asia/Dubai" \
--use-rewrites=1 \
--use-secure=0 \
--base-url="http://www.example.com" \
--base-url-secure="https://www.example.com" \
--admin-user=admin \
--admin-password=Password \
--admin-email=it-support@example.com \
--admin-firstname=User_FirstName \
--admin-lastname=User_LastName \
--cleanup-database

