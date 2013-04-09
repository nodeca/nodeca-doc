---
title: "Modules & helpers"
isPage: true
order: 80
---

Application structure is inspired by different "scaleable" metodologies.
In practice that means:

- Split all to independed modules (can be nested)
- All module resources (js, views, i18n, ...) are in single folder
- Avoid global modules availability - use events or local requires
- Use FS path to calculate resource path, for convenience.

That's acheived by advanced bundler. Note, that we don't have local config
for each module, as in [BEM](http://bem.info/). Instead, we use global
rules for each resource type (in `bundle.yml`). That's more simple in our case.

See `Bundler` section for details.


Local helpers, to simplify resources include
--------------------------------------------

We support extentions for jade / stylus / i18n, to simplify files references:

- `@` means root of package:
  - `@/path` - from the root of current package
  - `@package/path` - from the root of foreign package
- i18n names are relative to current module, by default
- on client side, `require` automatically bundle code. `bundle.yml` can define
  location of bundled module

Notes:

- `require` in node is NOT extended. Use `require('<node.module>/path/to/file')`,
   it's enougth
- `require` in client
  - understands relative paths and node.modules names (works as on server)
  - bundles code
- `self.partial(template[, locals])` in jade
  - understands `@`
  - allow to render relative i18n paths
- `import` in stylus
  - understands relative paths and node.modules names (works as on server)

See `env.helpers` in [server modules](modules-server.html) for standard functions


Views Rendering
---------------

In the server, views renderer is an after-filter middleware. Render expect
environment to contain `response` object (see Request Environment) with properties:

- **data** raw output data (used as JSON output or as sandbox for views)
- **layout** name to use (when rendering HTML)
- **view** name to use (when rendering HTML or sending data to the client)

Rendering consists of 2 steps:

1. Rendering page inner
2. Embedding it into layout

On client side, process looks similar, but automated via `navigate.to` listener.


### Layouts

Usually, page wrapper (layout) is set by hook for all pages of `server:**` methods.
But u can customize it as you wish from your template via `set_layout()` helper.

Layout looks like usual client block, wich wraps `content` variable.