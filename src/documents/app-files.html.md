---
title: "App Files & Dirs"
isPage: true
order: 10
---

Files
-----

Directores below are processed automaticallty during init.

``` none
.
├─ config/
│   └─ **/*.yml
│
├─ cli/*.js                     # commands implementations
│
├─ models/**/*.js
│
├─ stores/**/*.js               # setting stores
│
├─ server/                      # server modules (responders & translations) 
│   └─ <namespace>/
│       ├─ **/i18n/*.yml
│       └─ **/*.js
│
├─ client/                      # client modules (code, templates, css, i18n)
│   └─ <namespace>/
│       ├─ blocks/**/*
│       └─ pages/**/*
│
├─ assets/                      # static files (images, vendor libraries, wrappers)
│   └─ ...                      # not yet stable
│
├─ db/                          # migrations & seeds
│   ├─ migrate/**/<ts>_*.js     # migration steps (ts [timestamp] = YYYYMMDDhhmmss)
│   └─ seeds/**/*.js            # seeds
│
├─ lib/hooks/**/*.js            # hooks to inject code on `wire`
│
└─ index.js
```

**NOTE**. If you wish to hide some files from autoloading, stars their name with
underscore `_`. If you name directory with leading `_`, it's content will be
excluded from scan. That can be convenient, if you write complex models, server
methods, and others.


Namespaces
----------

We use namespaces, to separate application resources. Also, those can be used to
cut loading bundled resources. For example users do not need admin templates and
translations.


Packages & Bundles
------------------

Different types of resources are organised into `packages`. Each package defines
sources locations, that should be scanned & loaded on start. Clientside code &
css are packed into bundles for effective load.

Every app has `bundle.yml` in the root, that defines all available resources and
bundling rules.
