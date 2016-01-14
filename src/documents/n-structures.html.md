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

  version_hash            # global assets hash, to force clients reload
  environment             # runtime environment ???client only???

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
    files                 # array of assets info (path, digest)
    distribution          # assets info for loader
    asset_url(path)       # returns url for asset
    asset_body(path)      # returns compiled asset as a string

  validate                # rpc/http params validator

  models                  # server models (universal, implementation independent
  settings                # settings class, see ./lib/system/init/store.js

  redis
  redback
```
