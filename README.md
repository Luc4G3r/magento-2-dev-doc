# magento-2-dev-doc

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
