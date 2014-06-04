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

  io                      # status codes
  io.rpc                  # client only, server methods call

  logger                  # logger instance

  # server only

  config                  # parsed config file

  validate                # rpc/http params validator

  models                  # server models (universal, implementation independent
  settings                # settings class, see ./lib/system/init/store.js

  views                   # compiled views

  # server & client, dynamic data

  runtime                 # `dynamic` structures

    version               # global app version, to force clients reload
    router                # router instance, filled with routes from config

    env                   # runtime enviroment ???client only???

    i18n                  # translator (BabelFish) instance (different on server & client)

      # client only (on serverside those are placed in `env`)

      t()                 # shortcuts, with current locale
      t.exists()          #

    # server-specific

    client_routes         # RAW router config data, used to initialize router on server side

    args                  # CLI params
    mainApp               # root application
    apps                  # array of loaded apps info { name, absolute_path }

    assets                # assets-related data
      environment         # Mincer.Environmant instanse
      manifest            # Mincer manifest of assets
      server              # distribution map for `loadAssets.init`
      distribution

    mongoose
    redis
    redback

    # for additional client-specific properties see `env.runtime` content

```
