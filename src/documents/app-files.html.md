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

**NOTE**. You can exclude files or directories from autoloading, if start its
name with underscore `_`. That can be convenient, if you like to split one big
file to submodules.


Namespaces
----------

We use namespaces, to separate application resources. For example users do not
need admin templates and translations.


Packages & Bundles
------------------

Different types of resources are organised into `packages`. Each package defines
sources locations, that should be scanned, compiled & loaded on start. Packages
are combined into bundles. You can place all packages in single bundle, or split
to multiple ones, to optimize loading time.

Every app has `bundle.yml` in the root, that defines all available resources and
bundling rules.
