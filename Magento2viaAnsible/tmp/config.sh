#Edit fpm/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 1024M/' /etc/php/7.0/fpm/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 1800/' /etc/php/7.0/fpm/php.ini
sed -i 's/zlib.output_compression = Off/zlib.output_compression = On/' /etc/php/7.0/fpm/php.ini

#Edit cli/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 1024M/' /etc/php/7.0/cli/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 1800/' /etc/php/7.0/cli/php.ini
sed -i 's/zlib.output_compression = Off/zlib.output_compression = On/' /etc/php/7.0/cli/php.ini
