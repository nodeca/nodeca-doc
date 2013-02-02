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

  ?stores

  # server & client, dynamic data

  runtime                 # `dynamic` structures

    version               # global app version, to force clients reload
    router                # router instance, filled with routes from config

    ?env                   # runtime enviroment ???client only???

    i18n                  # translator (BabelFish) instance (different on server & client)

    ?client_routes

    # server-specific

    args                  # CLI params
    mainApp               # root application
    apps                  # array of loaded apps info { name, absolute_path }

    ?views                 # compiled views
    ?client

    ??assets                # assets-related data
      environment         # Mincer.Environmant instanse
      manifest            # Mincer manifest of assets
      server                 # distribution map for `loadAssets.init`
      distribution

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
