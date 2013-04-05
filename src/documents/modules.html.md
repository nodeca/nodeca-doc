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

Helpers:

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

