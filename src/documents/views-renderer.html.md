---
title: "-Views Renderer"
isPage: true
---


Views Renderer
--------------

Views renderer is an after-filter middleware.

Render expect environment to contain `response` object (see Request Environment)
with properties:

- **data** raw output data (used as JSON output or as sandbox for views)
- **layout** name to use (when rendering HTML)
- **view** name to use (when rendering HTML or sending data to the client)

If error occurs, `env.response` will have these fields as well:

- **err.code** (Integer)
- **err.message** (String)

When request comes from RPC origin, we simply pass `env.response` object to the
callback, while upon HTTP request we can return it as JSON or as rendered HTML
depending on requested `format`. By default upon HTTP request we render HTML and
return it. When `format` is *JSON* we return whole `env.response` serialized.

**TBD** Format dependent rendering is not yet supported.

We look for the requested format in following places (first one found is used):

- `env.format`
- `env.response.format`


**NOTICE** `html` renderer expect presence of `env.session.locale` and
`env.session.theme` in order to choose correct view. If it wasn't, we use
default language (en) and theme (default) instead.


## Helpers and Variables

**NOT YET IMPLEMENTED**

We provide constants available in templates on both server and client:

- **ASSETS**: Base URL of assets, e.g. `/assets/`
- **THEME**: Base URL of current theme assets, e.g. `/assets/theme-desktop-red/`

### Helpers

##### partial(apiPath, locals)

Renders template named by `apiPath`. The path is resolved relative to the current
template by default. You can specify an absolute API path using `@` symbol.

Example: `"@common.blocks.recaptcha"`

##### asset_path(logicalPath)

Returns full URL to asset (with digest)

##### asset_include(logicalPath) -> String

Returns bundled source of asset (asset should be precompiled)

##### link_to(name, params) -> String

Returns generated URL for `name` API path and given `params`.

##### date(dateObjectOrString, format) -> String

- dateObjectOrString (Date|String): Date object, or date string.
- format (String): Output format `time`, `date`, `datetime` or `iso8601`.

##### t(phrase, params) -> String

Returns translated `phrase`.

##### t.exists(phrase) -> Boolean

Returns `true` if there is an existent `phrase` translation. `false` otherwise.

##### get_apipath()

Returns API path of the requested server method. (e.g. `forum.index`)

##### set_layout(template)

Allows to change layout for use by renderer. Or disable it by passing null.
