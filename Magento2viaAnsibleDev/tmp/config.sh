# Edit fpm/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 1024M/' /etc/php/7.0/fpm/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 1800/' /etc/php/7.0/fpm/php.ini
sed -i 's/zlib.output_compression = Off/zlib.output_compression = On/' /etc/php/7.0/fpm/php.ini

# Edit cli/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 1024M/' /etc/php/7.0/cli/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 1800/' /etc/php/7.0/cli/php.ini
sed -i 's/zlib.output_compression = Off/zlib.output_compression = On/' /etc/php/7.0/cli/php.ini

# Disable Magento Staging Modules
sed -i "s|'Magento_CatalogStaging' => 1,|'Magento_CatalogStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_CatalogImportExportStaging' => 1,|'Magento_CatalogImportExportStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_Staging' => 1,|'Magento_Staging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_CheckoutStaging' => 1,|'Magento_CheckoutStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_CmsStaging' => 1,|'Magento_CmsStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_GiftMessageStaging' => 1,|'Magento_GiftMessageStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_GiftWrappingStaging' => 1,|'Magento_GiftWrappingStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_GoogleOptimizerStaging' => 1,|'Magento_GoogleOptimizerStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_GroupedProductStaging' => 1,|'Magento_GroupedProductStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_LayeredNavigationStaging' => 1,|'Magento_LayeredNavigationStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_MsrpStaging' => 1,|'Magento_MsrpStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_PaymentStaging' => 1,|'Magento_PaymentStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_ConfigurableProductStaging' => 1,|'Magento_ConfigurableProductStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_ReviewStaging' => 1,|'Magento_ReviewStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_RmaStaging' => 1,|'Magento_RmaStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_SalesRuleStaging' => 1,|'Magento_SalesRuleStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_SearchStaging' => 1,|'Magento_SearchStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_CatalogInventoryStaging' => 1,|'Magento_CatalogInventoryStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_GiftCardStaging' => 1,|'Magento_GiftCardStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_BundleStaging' => 1,|'Magento_BundleStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_CatalogRuleStaging' => 1,|'Magento_CatalogRuleStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_CatalogUrlRewriteStaging' => 1,|'Magento_CatalogUrlRewriteStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_DownloadableStaging' => 1,|'Magento_DownloadableStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_WeeeStaging' => 1,|'Magento_WeeeStaging' => 0,|" /var/www/magento2/app/etc/config.php
sed -i "s|'Magento_ProductVideoStaging' => 1,|'Magento_ProductVideoStaging' => 0,|" /var/www/magento2/app/etc/config.php
