#!/usr/bin/env bash

# Prepare environment vars
SCRIPTPATH=$(dirname "$(realpath -- "$0")")
if [ -f "$SCRIPTPATH"/.deploy_env ]
then
  export $(cat "$SCRIPTPATH"/.deploy_env | sed 's/#.*//g' | xargs)
fi

if [[ -z "${user}" ]]; then
  echo "Please set user variable in .deploy_env"
  exit
fi

if [[ -z "${group}" ]]; then
  group=$user
fi

if [[ -z "${git_branch_name}" ]]; then
  git_branch_name=master
fi

if [[ -z "${magento_root_subdir}" ]]; then
  magento_root_subdir=httpdocs
fi

if [[ -z "${php_executable}" ]]; then
  php_executable=php
fi

echo "$user:$group @$git_branch_name in $magento_root_subdir running $php_executable"

# Sample deploy script

echo 'set rights'

$php_executable -v

chown -R $user:$group $magento_root_subdir
chmod -R 755 $magento_root_subdir
find ./$magento_root_subdir/ -type d -exec chmod 770 {} \;
find ./$magento_root_subdir/ -type f -exec chmod 660 {} \;
chmod u+x ./$magento_root_subdir/bin/magento

echo '---------------------------------------------------------'

date=`date +"%Y-%m-%d"`
printf "%s\n" $date | tee -a /$magento_root_subdir/var/log/git_deploy_history.log

$php_executable $magento_root_subdir/bin/magento maintenance:enable

cd $magento_root_subdir
git pull origin $git_branch_name >&1 | tee -a /$magento_root_subdir/var/log/git_deploy_history.log

$php_executable composer install --no-cache --no-dev
cd ..

echo '---------------------------------------------------------'

$php_executable $magento_root_subdir/bin/magento cache:flush
$php_executable $magento_root_subdir/bin/magento setup:upgrade
$php_executable $magento_root_subdir/bin/magento setup:di:compile
$php_executable $magento_root_subdir/bin/magento setup:static-content:deploy de_DE en_US -f
$php_executable $magento_root_subdir/bin/magento indexer:reindex
$php_executable $magento_root_subdir/bin/magento maintenance:disable

echo '---------------------------------------------------------'
echo 'set rights'

#chmod -R 755 $magento_root_subdir/
chown -R $user:$group $magento_root_subdir
