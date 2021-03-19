# magento-2-dev-doc - miscellaneous dev task flows for magento 2 development

## contents
1. [module development](#magento-2-module-development)

## magento 2 command line reference
For a list of magento 2 commands [look here](https://devdocs.magento.com/guides/v2.4/config-guide/cli/config-cli-subcommands.html) or run `bin/magento list`

## magento 2 module development (in project)
* create custom directory in project root
  * f.e. `src/`
* add custom module to `src/` directory
```
vendor/module
```
* update `composer.json` `autoload-dev` section with namespace and path
```
"autoload-dev": {
   ...
   "psr-4": {
            ...
            "Vendor\\Module\\": "src/vendor/module"
            ...
        }
   ...
}
```
* add module to `require` section
```
"require": {
   ...
   "vendor/module": "version"
   ...
}
```
* add a path to `repository` section
```
"repositories": {
   ...
   "vendor.module": {
       "type": "path",
       "url": "src/vendor/module"
   }
   ...
}
```
Note: It's best to add `src/` path to shop project's `.gitignore` to prevent any accidential commits  
  
If you run into issues, its best to run `composer remove vendor/module` and `composer install vendor/module` again.

To install newly created module, change repository section
```
"repositories": {
   ...
   "vendor.module": {
       "type": "vcs|git",
       "url": "{url}"
   }
   ...
}
```
and run `composer install vendor/module`
