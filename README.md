# magento-2-dev-doc - miscellaneous dev task flows for magento 2 development

## List of contents
1. [Command line reference](#command-line-reference)
2. [Module development](#module-development)

## Command line reference
For a list of magento 2 commands [look here](https://devdocs.magento.com/guides/v2.4/config-guide/cli/config-cli-subcommands.html) or run `bin/magento list`

## Module development
* Consider using [Mage2Gen module generator cli tool](https://pypi.org/project/Mage2Gen/) or [Silksoftware module creator online tool](https://modulecreator.silksoftware.com/magento-module-creator/magento2-module-creator.php)
* [Module development documentation](https://devdocs.magento.com/videos/fundamentals/create-a-new-module/)
### In webshop package
* Create custom `vendor/module` directory in `app/code` folder
### Git package within project
* Create custom directory in project root
  * f.e. `src/`
* Add custom module to `src/` directory
```
vendor/module
```
* Update `composer.json` `autoload-dev` section with namespace and path
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
* Add module to `require` section
```
"require": {
   ...
   "vendor/module": "version"
   ...
}
```
* Add a path to `repository` section
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
