---
title: "Bundler"
isPage: true
order: 20
---

Resourses
---------

Each application has `bundle.yml` in the root dir. It defines all available
resources & bundling rules. Currently, we know:

- `client` - clientside JS
- `views` - templates (universal, for client & server)
- `styles` - CSS
- `i18n_client` - translations (for both client & server)
- `server` - server responders
- `i18n_server` - serverside translations (not exposed to client)
- `bin` - static files of any types

We process resources in 2 steps (both are not mandatory):

1. Scan folders in deep (for JS/CSS/templates) & process tree
2. Wrap result with main files (with [mincer](https://github.com/nodeca/mincer))

That helps to combine application modules with external 'old-style' librarues
(jquery, twitter bootstrap, and others)

**NOTE**. We CAN'T guarantee order of JS/CSS if app modules. Only for wraper.
But we have lazy-coupling event-driven init & [BEM](http://bem.info/)-style
notation for CSS. That prevents possible conflicts.


Packages
--------

Every set of resources is named `package`. Usually, each application has 1
custom package & extends `admin` package. But there are no special limits.


Bundles
-------

To load resources fast, we need to minimaze file count on the client. So,
we join multiple resources & packages into single CSS/JS files.

Currently, we have `frontend` & `backend` bundles. Also, separate bundle will
be available for heavy WISYWIG editors, not required on first load.


Bundler config example
----------------------

That's a real file from `nodeca.core` application.

```
bundles:
  frontend:
    - lib
    - core
    - common

  backend:
    - lib
    - core
    - admin


packages:
  admin:
    client:
      root:       "./client/admin"
      include:    "*.js"
      exclude:    "/(^|\\/)_.*/"

    views:
      root:       "./client/admin"
      include:    "*.jade"
      exclude:    "/(^|\\/)_.*/"

    i18n_client:
      root:       "./client/admin"
      include:    "i18n/*.yml"

    styles:
      root:       "./client/admin"
      main:       "app.styl"
      include:    "*.styl"

    server:
      root:       "./server/admin"
      include:    "*.js"
      exclude:    "/(^|\\/)_.*/"

    i18n_server:
      root:       "./server/admin"
      include:    "i18n/*.yml"


  common:
    client:
      root:       "./client/common"
      include:    "*.js"
      exclude:    "/(^|\\/)_.*/"

    views:
      root:       "./client/common"
      include:    "*.jade"
      exclude:    "/(^|\\/)_.*/"

    i18n_client:
      root:       "./client/common"
      include:    "i18n/*.yml"

    styles:
      root:       "./client/common"
      main:       "app.styl"
      include:    "*.styl"

    server:
      root:       "./server/common"
      include:    "*.js"
      exclude:    "/(^|\\/)_.*/"

    i18n_server:
      root:       "./server/common"
      include:    "i18n/*.yml"


  core:
    server:
      root:       "./server/core"
      include:    "*.js"
      exclude:    "/(^|\\/)_.*/"

    # Remove later, client layout should be in `common` 
    views:
      root:       "./views/desktop/layouts"
      include:    "*.jade"
      exclude:    "/(^|\\/)_.*/"
      apiPrefix:  "layouts"


  lib:
    client:
      root:       "./assets"
      main:       "javascripts/lib.js"

    bin:
      root:       "./assets"
      include:
        - javascripts/loader.js.ejs
        - vendor/es5-shim.js
        - vendor/json2.js
```
