#!/usr/bin/env bash

# Sample deploy script

echo 'set rights'

php -v

chmod -R 755 httpdocs/
chown -R user:group httpdocs/

echo '---------------------------------------------------------'

php httpdocs/bin/magento maintenance:enable
cd httpdocs/

git pull

pwd
php composer install --no-cache --no-dev

cd ..
pwd

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
