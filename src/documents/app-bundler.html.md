---
title: "Bundler"
isPage: true
order: 20
---

Resourses
---------

Each application has `bundle.yml` in the root dir. It defines resources
roots & bundling rules.

In each resource dir we have `config.yml`. It defines resource
files and options. Currently, we know:

- `recursive` - scan sub folders
- `public` - will be loaded on client and server side if `true` (only server side if `false`)
- `inherit` - use parent folder config (default `true`)
- `type`
  - `widget_css` - CSS
  - `widget_i18n` - translations
  - `widget_view` - templates
  - `widget_js` - client side JS (wrapped as client modules)
  - `js` - client side JS (not wrapped)
  - `bin` - static files of any types

We process resources in 3 steps (first two are not mandatory):

1. Scan folders in deep (for JS/CSS/templates/translations) & process tree
2. Compile files, and create `manifest.json` for next step
3. Load assets info from `manifest.json`

That helps to combine application modules with external 'old-style' libraries
(jquery, twitter bootstrap, and others).

**NOTE**. We CAN'T guarantee order of JS/CSS for client modules. Only for wraper.
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
be available for heavy WISYWIG editor, that's not required on first load.


Bundler config example
----------------------

That's a real file from `nodeca.core` application.

``` none
bundles:
  lib:
    - lib

  frontend:
    - l10n
    - lib-frontend
    - common

  backend:
    - l10n
    - lib-admin
    - admin

  mdedit:
    - mdedit

packages:

  admin:
    depends:
      - lib
      - l10n
      - lib-admin
    entries:
      - client/admin
      - server/admin

  common:
    depends:
      - lib
      - l10n
    entries:
      - client/common
      - server/common

  lib:
    vendor:
      # shared
      - lodash
      - async
      - jquery
      - knockout
      - event-wire
      - co
      - steady # scroll tracker
      - raf.js
      - faye/browser/faye-browser
      - tabex
      # stub for jade runtime
      - fs: nodeca.core/lib/system/dummy.js
      # reuse global bug.js from the loader
      - bag.js: nodeca.core/lib/bag.js
      # Used by kernel & DateFormatter
      - babelfish

    entries: client/lib

  lib-admin:
    entries: client/lib-admin

  lib-frontend:
    entries: client/lib-frontend

  l10n: {}

  mdedit:
    entries: client/mdedit
```

Client resource root `config.yml` example.

``` none
recursive: true
public: true
type:
  widget_css:
    - "*.css"
    - "*.styl"
    - "*.less"
  widget_i18n: i18n/*.yml
  widget_view: "*.jade"
  widget_js: "*.js"
```

Server resource root `config.yml` example.

``` none
recursive: true
public: false
type:
  widget_i18n: i18n/*.yml
  widget_view: "*.jade"
```
