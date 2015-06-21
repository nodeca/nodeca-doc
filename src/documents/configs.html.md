---
title: "Config files"
isPage: true
order: 30
---

Configs are placed in `./config/**/*.yml` files in every app. Final result is
nested tree, merged from that files. You can split data as you wish, override
defaults, and have custom values for each environment.

Config loading algorythm
------------------------

1. Load root app config
2. Deep merge all data from child apps
   - If object has property `~override: true`, it will replace any existing
     value. Use it, if you want to erase branch, instead if deep merge.
3. Search branches `^env_name` for current environment, and use it to override
   values. Recommended env names:
   - production
   - development
   - test
   - staging

See original configs for details:
[nodeca.core](https://github.com/nodeca/nodeca.core/tree/master/config) defaults,
and [nodeca main app](https://github.com/nodeca/nodeca/tree/master/config)
settings.


Сonfig structure
----------------

Not exact, only for overview. See real configs in `nodeca` & `nodeca.core`

``` none
configured                  # = true, if not exists -> config missed

applications                # array of active aplication (npm packages)

locales                     # existing locales config
  default
  enabled

logger                      # logger config

bind                        # server listen & router bindings
router                      # router rules
  map
  direct_invocators

database                    # db connections params
  mongo
    host
    port
    database
    user
    password
  redis
    host
    port
    index

options                     # minor variables, to keep root clear
  recaptcha
    private_key
    public_key

setting_schemas             # Setting configs & defaults
setting_groups              # Settings tabs/groups definitions

menus                       # menus.<namespace>.<menu_id>.items.configs

i18n                        # i18n.<locale>.<namespase>.my.phrase.translation
```
