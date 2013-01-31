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

That's acheaved via advanced bundler. Note, that we don't have local config
for each module, as in BEM. Instead, we use global rules for each resource type.
That's more simple in our case.

See `Bundler` section for details.


Local helpers, to simplify resources include
--------------------------------------------

We support extentions for jade / stylus / i18n, to simplify resource include:

- `@` means root of package:
  - `@/path` - from the root of current package
  - `@package/path` - from the root of foreign package
- i18n names are always relative to current module, by default
- on client code, `require` automaticcaly bundle code. bundle.yml can define
  location of bundled module

Helpers:

- `require` in node is not extended / monkey-patched
- `require` in client
  - understands `.` (relative to current path)
  - understands `@`
  - bundles code
- `self.include()` (helper, do not miss with `include` directive) in jade
  - understands `@`
  - autopatch relative i18n paths
- `import` in stylus
  - understands `@` (TBD)

