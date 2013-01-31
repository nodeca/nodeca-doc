---
title: "N.*"
isPage: true
order: 60
---

Special sandbox object `N` keeps ALL info about application. Here is map of
available properties. There can be difference on server and client.

```
N
  wire                    # Message bus object

  io                      # status codes
  io.rpc                  # client only, server methods call

  # server only

  logger                  # logger instance
  config                  # parsed config file

  validate                # rpc/http params validator

  models                  # server models (universal, implementation independent
  settings                # settings class, see ./lib/system/init/store.js

  # server & client, dynamic data

  runtime                 # `dynamic` structures

    version               # global app version, to force clients reload
    router                # router instance, filled with routes from config
    env                   # runtime enviroment

    i18n                  # translator (BabelFish) instance (different on server & client)

    # server-specific

    args                  # CLI params
    mainApp               # root application
    apps                  # array of loaded apps info { name, absolute_path }

    ?views                 # compiled views
    ?assets                # assets-related data
      environment         # Mincer.Environmant instanse
      manifest            # Mincer manifest of assets
      map                 # distribution map for `loadAssets.init`

    mongoose
    redis
    redback

    # client-specific

    ?debug                 #
    ?user_id               #
    ?theme_id              #
    ?language              #

    ?views
```
