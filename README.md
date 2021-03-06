# magento-2-dev-doc
miscellaneous dev task flows for magento 2 development

## List of contents
1. [Installation](#installation)
2. [Command line reference](#command-line-reference)
3. [Performance considerations](#performance-considerations)
4. [Quality Tools](#quality-tools)
5. [Module development](#module-development)
6. [Design tasks](#design-tasks)
7. [Deployment](#deployment)

## Installation
Clone git / [Use install guide](https://devdocs.magento.com/guides/v2.4/install-gde/composer.html)
* run `bin/magento setup:install --base-url=... --base-url-secure=... --language=de_DE --currency=EUR --timezone=Europe/Berlin --admin-user=... --admin-firstname=... --admin-lastname=... --admin-email=... --admin-password=... --use-rewrites=0 --db-host=127.0.0.1 --db-user=... --db-name=one2buy --db-password=... --search-engine=elasticsearch7 --elasticsearch-host=127.0.0.1 --elasticsearch-port=9200`

## Command line reference
For a list of magento 2 commands [look here](https://devdocs.magento.com/guides/v2.4/config-guide/cli/config-cli-subcommands.html) or run `bin/magento list`

## Performance considerations
[See this link](https://www.atwix.com/magento-2/ways-to-make-theme-faster/)

## Quality tools
* I highly recomment to have following tools in `"require-dev"` section of `composer.json`:  
    <details>
        <summary><i>expand</i></summary>

    ```
        "require-dev": {
            ...
            "friendsofphp/php-cs-fixer": "*",
            "magento/magento-coding-standard": "*",
            "magento/magento2-functional-testing-framework": "*",
            "phpmd/phpmd": "*",
            "phpstan/phpstan": "*",
            "phpunit/phpunit": "*",
            "squizlabs/php_codesniffer": "*"
            ...
        },
    ```
    
    </details>

* All of these tools are configurable with PHPStorm and have own documentations

## Module development
* Consider using [Mage2Gen module generator cli tool](https://pypi.org/project/Mage2Gen/) or [Silksoftware module creator online tool](https://modulecreator.silksoftware.com/magento-module-creator/magento2-module-creator.php)
* [Module development documentation](https://devdocs.magento.com/videos/fundamentals/create-a-new-module/)
### In webshop package
* Create custom `vendor/module` directory in `app/code` folder
### Git package within project
* Create custom directory in project root
  * f.e. `src/`  
**_NOTE: It's best to add `src/` path to shop project's `.gitignore` to prevent any accidential commits_**  
* Add custom module to `src/` directory
```
vendor/module
```
* Add module to `require` section
```
"require": {
   ...
   "vendor/module": "version"
   ...
}
```
* Add dev and git paths to `repository` section
    <details>
        <summary><i>expand</i></summary>

    ```
    "repositories": {
       ...
       "vendor.module": {
                "type": "package",
                "package": {
                    "name": "vendor/module",
                    "version": "x.x.x",
                    "source": {
                        "type": "vcs|git",
                        "url": "{url}",
                        "reference": "x.x.x"
                    },
                    "dist": {
                        "type": "path",
                        "url": "src/vendor/module",
                        "options": {
                            "symlink": true
                        }
                    },
                    "autoload": {
                        "files": [
                            "registration.php"
                        ],
                        "psr-4": {
                            "Vendor\\Module\\": ""
                        }
                    }
                }
            },
       ...
    }
    ```

    </details>

[It might be possible to do this easier](https://laracasts.com/discuss/channels/general-discussion/switch-composer-package-from-vcs-to-path-and-back)  
Composer automatically preferences `dist` for packages, so in development it should always load from the path if it exists.  
On the other hand, if the module path does not exist, composer will then try to fetch from the `source`.  
If you run into issues, its best to run `composer require vendor/module` or `composer remove vendor/module` and `composer install vendor/module` again.

To install run `composer install vendor/module`

## Design tasks

<details>
    <summary><b>How <i>app/design/</i> directory works</b></summary>
    
* Create designs within the directory by
    * Adding subdirectory like `vendor/design_name`
    * Adding `registration.php`
        <details>
            <summary><i>expand</i></summary>

        ```
                <?php
                \Magento\Framework\Component\ComponentRegistrar::register(
                \Magento\Framework\Component\ComponentRegistrar::THEME,
                'frontend/vendor/design_name',
                __DIR__
                );     
        ```        

        </details>

    * Adding `theme.xml`
        <details>
            <summary><i>expand</i></summary>

        ```
            <theme xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:Config/etc/theme.xsd">
                <title>{{THEME TILE}}</title>
                <parent>Magento/blank</parent> <!-- This can be any installed theme -->
                <media>
                    <preview_image>/media/theme/preview/preview_image.jpeg</preview_image> <!-- relative to the themes directory -->
                </media>
            </theme>
        ```

        </details>    
</details>
<details>
    <summary><b>Common design tasks</b></summary>

* Overriding layout/ template files:
    * To override those files, see their original path in the vendor module
    * You can then place a file in your theme under `Vendor_Module/layout`, `Vendor_Module/templates`, etc.
    * Omit the area in the file path (as the theme is based on an area already)
    * Examples
        <details>
                <summary><i>Example 1</i></summary>

        * To replace `vendor/magento/module-theme/view/frontend/templates/html/footer.phtml`, copy it to `app/design/frontend/vendor/design-name/Magento_Theme/view/templates/html/footer.phtml`

        </details>

        <details>
                <summary><i>Example 2</i></summary>

        * To replace `vendor/magento/module-theme/view/frontend/templates/html/topmenu.phtml`, copy it to `app/design/frontend/vendor/design-name/Magento_Theme/view/templates/html/topmenu.phtml`

        </details>
 
        <details>
                <summary><i>Example 3</i></summary>

        * To replace `vendor/magento/module-theme/view/frontend/layout/default.xml`, copy it to `app/design/frontend/vendor/design-name/Magento_Theme/layout/default.xml`

        </details>
</details>

## Deployment
[See sample deploy.sh](https://github.com/Luc4G3r/magento-2-dev-doc/blob/main/SAMPLES/deploy.sh)
