#!/usr/bin/env bash

# Sample deploy script

echo 'set rights'

php -v

chown -R user:group httpdocs/
chmod -R 755 httpdocs/
find . -type d -exec chmod 770 {} \;
find . -type f -exec chmod 660 {} \;
chmod u+x bin/magento

echo '---------------------------------------------------------'

php httpdocs/bin/magento maintenance:enable

cd httpdocs/
git pull

php composer install --no-cache --no-dev
cd ..

echo '---------------------------------------------------------'

php httpdocs/bin/magento cache:flush
php httpdocs/bin/magento setup:upgrade
php httpdocs/bin/magento setup:di:compile
php httpdocs/bin/magento setup:static-content:deploy de_DE en_US -f
php httpdocs/bin/magento indexer:reindex
php httpdocs/bin/magento maintenance:disable

echo '---------------------------------------------------------'
echo 'set rights'

chmod -R 755 httpdocs/
chown -R user:group httpdocs/
