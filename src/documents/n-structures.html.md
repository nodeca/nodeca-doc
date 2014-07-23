---
title: "N.*"
isPage: true
order: 60
---

Special sandbox object `N` keeps ALL info about application. Here is map of
available properties. There can be difference on server and client.

```
N
  wire                    # Message bus
  logger                  # logger instance

  version                 # global app version, to force clients reload
  enviroment              # runtime enviroment ???client only???

  i18n                    # translator (BabelFish) instance
                          # (client version is loaded with single locale only)

  router                  # router instance, filled with routes from config
  views                   # compiled views

  # client only

  io                      # status codes
  io.rpc                  # client only, server methods call

  runtime                 # `dynamic` structures

    t()                 # shortcuts, with current locale
    t.exists()          #

    # for additional client-specific properties see `env.runtime` content

  # server only

  args                  # CLI params

  mainApp                 # root application
  apps                    # array of loaded apps info { name, absolute_path }

  config                  # parsed config file

  assets                  # assets-related data
    environment           # Mincer.Environmant instanse
    manifest              # Mincer manifest of assets
    server                # distribution map for `loadAssets.init`
    distribution

  validate                # rpc/http params validator

  models                  # server models (universal, implementation independent
  settings                # settings class, see ./lib/system/init/store.js

  redis
  redback
```
